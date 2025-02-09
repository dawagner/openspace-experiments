#!/usr/bin/env python
# coding: utf-8

import sys
import asyncio
import bisect
import importlib

import sshkeyboard
import openspace

ADDRESS = "localhost"
PORT = 4681

# toggle controlling whether the movie is paused
pause = False
pause_event = asyncio.Event()


async def on_keypress(key):
    global pause
    if key == "space":
        pause = not pause
        next_action = "resume" if pause else "pause"
        print(f"Press <space> to {next_action}")
        pause_event.set()


async def init():
    api = openspace.Api(ADDRESS, PORT)
    await api.connect()
    os = await api.singleReturnLibrary()
    return os


async def mk_scenes(os, times):
    return {await os.time.convertTime(t): times[t] for t in times}


# FIXME: works ok for linear movies but not for movies going back in time
def find_scene(scenes, time):
    """Finds the scene that contains the given time, return its start time"""
    scene_times = list(scenes)
    start = max(bisect.bisect_right(scene_times, time) - 1, 0)
    # # TODO: how to manage the end of the movie?
    # end = min(start + 1, len(scene_times) - 1)
    return scene_times[start]  # , scene_times[end]


async def movie(os, movie_name):
    movie_module = importlib.import_module(movie_name)

    async def load_scenes(mod):
        return await mk_scenes(os, mod.scenes())

    scenes = await load_scenes(movie_module)

    first_scene_time = next(iter(scenes))
    last_known_scene_time = first_scene_time
    await scenes[first_scene_time](os)
    await os.time.setPause(False)

    while True:
        timeout = None if pause else 0.5
        pause_task = asyncio.create_task(pause_event.wait())
        pause_event.clear()
        done, _ = await asyncio.wait((pause_task,), timeout=timeout)
        if pause:
            print("Pausing playback and simulation")
            await os.time.setPause(True)
            continue
        if pause_task in done:
            print("Resuming playback (but simulation is not restarted automatically)")
            # We're resuming playback - reload the movie definition. This allows for dynamic movie
            # edition.
            importlib.reload(movie_module)
            scenes = await load_scenes(movie_module)
        current_time = await os.time.currentTime()
        # TODO: upon pausing the movie, backup the navigation state (inc. time); upon resuming,
        # restore the navigation state.
        time = find_scene(scenes, current_time)
        if time != last_known_scene_time:
            # time has advanced or was set to another scene, let's change to it
            last_known_scene_time = time
            print(f"switching scene to {time}")
            await scenes[time](os)


async def main(movie_name):
    os = await init()
    # FIXME: listen_keyboard will probably spin forever so this will never end?
    await asyncio.gather(
        sshkeyboard.listen_keyboard_manual(on_press=on_keypress), movie(os, movie_name)
    )
    # Automatically pause when the movie is over
    await os.time.setPause(True)


if __name__ == "__main__":
    movie_name = sys.argv[1]

    asyncio.run(main(movie_name))
