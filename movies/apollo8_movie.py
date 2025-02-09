#!/usr/bin/env python
# coding: utf-8

from movielib import one_minute, one_hour, one_day


async def scene_1(os):
    nav = os.navigation
    scene_1_navstate = {
        "Anchor": "Earth",
        "Pitch": 0,
        "Position": [6293676.95904541, 5468725.167415619, 20957880.594990373],
        "ReferenceFrame": "Root",
        "Timestamp": "1968 DEC 21 12:51:02",
        "Up": [-0.2921629243111312, 0.9431645300075538, -0.15837138312712412],
        "Yaw": 0,
        "Roll": 0,
    }
    print("Scene 1")
    await nav.setNavigationState(scene_1_navstate, True)

    # Prevent the camera from rotating with the Earth
    await os.setPropertyValueSingle(
        "NavigationHandler.OrbitalNavigator.FollowAnchorNodeRotation", False
    )

    await os.setPropertyValueSingle(
        "Scene.Apollo8LaunchTrail.Renderable.Opacity", 1.0, 0
    )
    await os.setPropertyValueSingle(
        "Scene.Apollo8LaunchTrail.Renderable.Appearance.EnableFade", False
    )
    await os.setPropertyValueSingle("Scene.Apollo8LaunchTrail.Renderable.Enabled", True)

    await os.setPropertyValueSingle(
        "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 0
    )
    await os.setPropertyValueSingle(
        "Scene.Apollo8EarthBarycenterTrail.Renderable.Appearance.EnableFade", False
    )
    await os.setPropertyValueSingle(
        "Scene.Apollo8EarthBarycenterTrail.Renderable.Enabled", True
    )

    await os.setPropertyValueSingle("Scene.Apollo8MoonTrail.Renderable.Opacity", 0.0, 0)
    await os.setPropertyValueSingle(
        "Scene.Apollo8MoonTrail.Renderable.Appearance.EnableFade", False
    )
    await os.setPropertyValueSingle("Scene.Apollo8MoonTrail.Renderable.Enabled", True)

    # Hide the moon trail for now: the perpective may be misleading
    await os.setPropertyValueSingle("Scene.MoonTrail.Renderable.Opacity", 0)

    # TODO: remove other solar system trails (or even remove their assets entirely?)
    # TODO: remove earth trail as well

    await os.time.interpolateDeltaTime(5 * one_minute, 1)


async def scene_1b(os):
    # A8 is behind the Earth - speed up time a bit
    await os.time.interpolateDeltaTime(20 * one_minute, 1)


async def scene_1c(os):
    # A8 is in front of the Earth and will start travelling towards the Moon. Slow down a bit
    await os.time.interpolateDeltaTime(5 * one_minute, 1)


async def scene_2(os):
    nav = os.navigation
    # start following Apollo8
    print("Scene 2")
    await os.setPropertyValueSingle(
        "NavigationHandler.OrbitalNavigator.Anchor", "Apollo8"
    )
    # FIXME: replace with an absolute command (setNavigationState)
    await nav.addTruckMovement(-15)


async def scene_3(os):
    scene_3_navstate = {
        "Anchor": "Apollo8",
        "ReferenceFrame": "Root",
        # "Position": [-5560758.05960083, 11376215.199085236, 7332644.892368421],
        # "Up": [-0.2282031962759847, 0.44621628335270114, -0.8653405859430877],
        "Position": [-49977208.20648193, 36950276.16604614, 1425664.9150595963],
        "Up": [-0.18822411488912283, -0.21763145572127995, -0.957709889295732],
        # TODO: fix the yaw, pitch and roll
    }
    # better camera angle? Farther away from earth
    # {
    #     "Position": [-49977208.20648193, 36950276.16604614, 1425664.9150595963],
    #     "Up": [-0.18822411488912283, -0.21763145572127995, -0.957709889295732],
    # }

    goto_3 = lambda: os.pathnavigation.createPath(
        {
            "TargetType": "NavigationState",
            "PathType": "AvoidCollisionWithLookAt",
            "NavigationState": scene_3_navstate,
            "Duration": 4,
        }
    )

    print("Scene 3")
    # move the camera above A8 and zoom out a bit
    await goto_3()
    # show the A8/Barycenter trail
    await os.setPropertyValueSingle(
        "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 1.0, 0.5
    )


async def scene_3b(os):
    nav = os.navigation

    # zoom out a bit, again
    # FIXME: replace with an absolute position
    await nav.addTruckMovement(-15)


async def scene_4(os):
    # TODO: get a navstate where the view is centered on the middle of the earth/moon system?
    scene_4_navstate = {
        "Anchor": "Earth",
        "Pitch": 0.19893809701272958,
        "Position": [122772301.26016235, 388187185.74944305, 69396110.59022844],
        "ReferenceFrame": "Root",
        "Up": [-0.5346885916522564, 0.3096670007774672, -0.7862661499685808],
        "Yaw": 0.27984183932213347,
        # "Anchor": "Earth",
        # "Pitch": 0.19893809701276685,
        # "Position": [-69041286.35406494, 105918808.32658577, 17105056.777462244],
        # "ReferenceFrame": "Root",
        # "Timestamp": "1968 DEC 21 17:48:34",  # plutot 17:25 ?
        # "Up": [-0.10734536338792167, 0.08992969456597477, -0.9901462634350469],
        # "Yaw": 0.2798418393212451,
    }

    print("Scene 4")
    await os.pathnavigation.jumpToNavigationState(scene_4_navstate, 0.5)
    # show the moon trail and make it stand out more
    await os.setPropertyValueSingle(
        "Scene.MoonTrail.Renderable.Appearance.LineFadeAmount", 0.15, 0
    )
    await os.setPropertyValueSingle(
        "Scene.MoonTrail.Renderable.Appearance.LineWidth", 30, 0
    )
    await os.setPropertyValueSingle("Scene.MoonTrail.Renderable.Opacity", 1.0)
    # speed time up, but very gradually (over 10s)
    await os.time.interpolateDeltaTime(30 * one_minute, 10)


async def scene_4b(os):
    # hide the launch trail and accelerate a lot
    await os.setPropertyValueSingle(
        "Scene.Apollo8LaunchTrail.Renderable.Opacity", 0, 0.5
    )
    # show the A8/Moon trail - it will start showing up at December 23, 00:00
    await os.setPropertyValueSingle("Scene.Apollo8MoonTrail.Renderable.Opacity", 1.0)
    await os.time.interpolateDeltaTime(2 * one_hour)


async def scene_5(os):
    nav = os.navigation

    # scene_5_navstate = {
    #     "Anchor": "Earth",
    #     "Position": [102005333.71444702, 494797175.9400406, 236052410.95812607],
    #     "ReferenceFrame": "Root",
    #     "Timestamp": "1968 DEC 23 09:33:26",  # plutot "1968 DEC 22 02:22:28" ?
    #     "Up": [-0.9007647294947052, 0.32378797914309143, -0.2894550857400223],
    # }

    # await os.pathnavigation.jumpToNavigationState(scene_5_navstate, 0.5)
    # scene_5_end_navstate = {
    #     "Anchor": "Earth",
    #     "Position": [102005333.71444702, 494797175.9400406, 236052410.9581251],
    #     "ReferenceFrame": "Root",
    #     "Timestamp": "1968 DEC 24 07:37:51",
    #     "Up": [-0.9007647294947188, 0.3237879791430799, -0.2894550857399934],
    # }

    navstate = {
        "Anchor": "Moon",
        "Pitch": 0.002506849476056914,
        "Position": [18903234.865875244, 59631720.832969666, 29449524.456306458],
        "ReferenceFrame": "Root",
        "Timestamp": "1968 DEC 24 04:21:33",
        "Up": [-0.8800567998343979, 0.40301353931432915, -0.25115755253341676],
        "Yaw": -0.0029955000285278284,
    }

    # {
    #    "Anchor": "Moon",
    #    "Pitch": 0.00253720299222337,
    #    "Position": [7992032.456542969, 25211486.378623962, 12450861.291872978],
    #    "ReferenceFrame": "Root",
    #    "Timestamp": "1968 DEC 24 07:37:51",
    #    "Up": [-0.8839624067862186, 0.3998768917848854, -0.24229926703391957],
    #    "Yaw": -0.002969834306467446,
    # }
    # focus on the moon and get closer, for the A8 approach.
    print("Scene 6")
    await os.pathnavigation.flyToNavigationState(navstate, 5)

    # then, at 1968 DEC 24 09:25:22, zoom a bit
    # await nav.addTruckMovement(30)
    # and hide the A8/Barycenter trail
    await os.setPropertyValueSingle(
        "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 2.0
    )


def scenes():
    return {
        "1968 DEC 21 12:51:02": scene_1,
        # A8 get behind the Earth
        "1968 DEC 21 13:15:00": scene_1b,
        # A8 is in front of the Earth
        "1968 DEC 21 15:45:00": scene_1c,
        #
        # A8 is en route to the Moon, start following it
        "1968 DEC 21 16:00:00": scene_2,
        #
        # Get to a higher PoV
        "1968 DEC 21 16:20:00": scene_3,
        # zoom out a bit, again
        "1968 DEC 21 17:10:00": scene_3b,
        #
        # global earth/moon view
        "1968 DEC 21 18:30:00": scene_4,
        # hide the launch trail and accelerate a lot
        "1968 DEC 21 21:00:00": scene_4b,
        #
        # focus on the moon and get closer, for the A8 approach.
        "1968 DEC 24 04:15:00": scene_5,
    }
