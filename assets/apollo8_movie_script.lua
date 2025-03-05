local one_minute = 60
local one_hour = 60 * one_minute

local function legend1(text)
  openspace.setPropertyValue("Dashboard.Legend1.Text", text)
end
local function legend2(text)
  openspace.setPropertyValue("Dashboard.Legend2.Text", text)
end

if scene == "init" then
  -- hide screen noise
  openspace.setPropertyValue("RenderEngine.ShowLog", false)
  openspace.setPropertyValue("RenderEngine.ShowCamera", false)
  openspace.setPropertyValue("RenderEngine.ShowVersion", false)

  -- hide most trails: they only add noise
  -- openspace.action.triggerAction("os.FadeDownTrails")
  openspace.setPropertyValue("Scene.*Trail.Renderable.Fade", 0.0)
  openspace.setPropertyValue("Scene.Apollo8*Trail.Renderable.Fade", 1.0)
  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Fade", 1.0)

  -- minimal margin for the dashboard
  openspace.setPropertyValue("Dashboard.StartPositionOffset", {5.0, 0.0})

  -- Set the dashboard refresh rate to make it more readable
  openspace.setPropertyValue("Dashboard.RefreshRate", 500)

  -- hide default dashboard items
  -- TODO: use a new screenspace dashboard for that
  openspace.setPropertyValue("Dashboard.Distance.Enabled", false)
  openspace.setPropertyValue("Dashboard.GlobeLocation.Enabled", false)
  openspace.setPropertyValue("Dashboard.Framerate.Enabled", false);

  -- hide our dashboard items for now
  openspace.setPropertyValue("Dashboard.MyDate.Enabled", false)
  openspace.setPropertyValue("Dashboard.DistanceToEarth.Enabled", false)
  openspace.setPropertyValue("Dashboard.DistanceToMoon.Enabled", false)
  openspace.setPropertyValue("Dashboard.ElapsedTime.Enabled", false)
  openspace.setPropertyValue("Dashboard.ElapsedTime.FormatString", "Time to launch: {}")
  legend1("")
  legend2("")

  openspace.setPropertyValue("ScreenSpace.TitleScreen.Opacity", 0)
  openspace.setPropertyValue("ScreenSpace.Patch.Opacity", 0)
  openspace.setPropertyValue("ScreenSpace.Earthrise.Opacity", 0)

  openspace.resetCamera()
elseif scene == "titlescreen" then
  openspace.time.interpolateDeltaTime(1, 0)
  openspace.setPropertyValue("ScreenSpace.TitleScreen.Opacity", 1)
  openspace.setPropertyValue("ScreenSpace.Patch.Opacity", 1)
  openspace.setPropertyValue("RenderEngine.BlackoutFactor", 0, 0)
elseif scene == "lift-off" then
  openspace.setPropertyValue("Dashboard.MyDate.Enabled", true)
  openspace.setPropertyValue("Dashboard.ElapsedTime.Enabled", true)

  legend1("Apollo 8 takes off from Cape Canaveral")

  openspace.setPropertyValue(
      "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 0
  )
  openspace.setPropertyValue(
      "Scene.Apollo8EarthBarycenterTrail.Renderable.Appearance.EnableFade", false
  )
  openspace.setPropertyValue(
      "Scene.Apollo8EarthBarycenterTrail.Renderable.Enabled", true
  )

  openspace.setPropertyValue(
      "Scene.Apollo8LaunchTrail.Renderable.Opacity", 1.0, 0
  )
  openspace.setPropertyValue(
      "Scene.Apollo8LaunchTrail.Renderable.Appearance.EnableFade", false
  )
  openspace.setPropertyValue("Scene.Apollo8LaunchTrail.Renderable.Enabled", true)

  -- Hide the moon trail for now: the perpective may be misleading
  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Opacity", 0)

  openspace.time.interpolateDeltaTime(5, 0)
  openspace.setPropertyValue("Dashboard.ElapsedTime.LowestTimeUnit", 3) -- seconds
  -- Have the camera follow the earth rotation for now
  openspace.setPropertyValue(
      "NavigationHandler.OrbitalNavigator.FollowAnchorNodeRotation", true
  )
  -- Put the sun behind the camera to have a better view on Cape Canaveral
  openspace.setPropertyValue("Scene.EarthAtmosphere.Renderable.SunFollowingCamera", true)

  -- nice view on Cape Canaveral and the coast
  navstate = {
    Anchor = 'Earth',
    Pitch = 0.8223378899028281,
    Position = {899148.9425395278, -5618585.885686883, 3011088.983413647},
    Up = {0.31584699215321127, 0.48695258755010107, 0.814320486679557},
    Yaw = 0.29227254402220043
  }
  openspace.navigation.setNavigationState(navstate)

  openspace.setPropertyValue("ScreenSpace.TitleScreen.Opacity", 0)
  openspace.setPropertyValue("ScreenSpace.Patch.Opacity", 0)
  openspace.setPropertyValue("RenderEngine.BlackoutFactor", 1, 2)
elseif scene == "leaving-atmo" then
  legend1("")

  openspace.time.interpolateDeltaTime(5, 0)

  openspace.setPropertyValue("Dashboard.ElapsedTime.LowestTimeUnit", 4) -- minutes
  openspace.setPropertyValue("Scene.EarthAtmosphere.Renderable.SunFollowingCamera", false)
  openspace.setPropertyValue("Dashboard.DistanceToEarth.Enabled", true)
  openspace.setPropertyValue("Dashboard.DistanceToMoon.Enabled", true)
  navstate = {
    Anchor = 'Earth',
    Pitch = 1.5749997192404859,
    Position = {844484.4389369619, -5556090.264981303, 3069051.4636229915},
    Up = {0.9900033896854753, 0.0909043549631067, -0.1078410249395429},
    Yaw = -0.013556703273582889
  }
  -- OS 0.20.1
  -- openspace.pathnavigation.jumpToNavigationState(navstate, 0.5)
  -- OS latest
  openspace.pathnavigation.jumpToNavigationState(navstate, false, 0.3)
elseif scene == "1" then
  legend1("A8 is on low-earth-orbit and checks the spacecraft is in good condition to go to the Moon")

  scene_1_navstate = {
      Anchor = "Earth",
      Pitch = 0,
      Position = {6293676.95904541, 5468725.167415619, 20957880.594990373},
      ReferenceFrame = "Root",
      -- Timestamp = "1968 DEC 21 12:51:02",
      Up = {-0.2921629243111312, 0.9431645300075538, -0.15837138312712412},
      Yaw = 0,
  }
  openspace.navigation.setNavigationState(scene_1_navstate, false)

  -- Prevent the camera from rotating with the Earth
  openspace.setPropertyValue(
      "NavigationHandler.OrbitalNavigator.FollowAnchorNodeRotation", false
  )

  openspace.setPropertyValue("Scene.Apollo8MoonTrail.Renderable.Opacity", 0.0, 0)
  openspace.setPropertyValue(
      "Scene.Apollo8MoonTrail.Renderable.Appearance.EnableFade", false
  )
  openspace.setPropertyValue("Scene.Apollo8MoonTrail.Renderable.Enabled", true)

  -- TODO: remove other solar system trails (or even remove their assets entirely?)
  -- TODO: remove earth trail as well

  -- 5 minutes/s, acceleration spread over 5s to make it smooth
  openspace.time.interpolateDeltaTime(5 * one_minute, 5)
elseif scene == "1b" then
  -- A8 is behind the Earth - speed up time a bit
  openspace.time.interpolateDeltaTime(20 * one_minute, 1)
elseif scene == "1c" then
  -- A8 is in front of the Earth and will start travelling towards the Moon. Slow down a bit.
  openspace.time.interpolateDeltaTime(5 * one_minute, 1)
elseif scene == "2" then
  legend1("Apollo 8 is en route for the moon")

  -- TODO: remove this setup entirely and keep 1c instead? Or just zoom out a bit?
  -- openspace.setPropertyValue(
  --   "NavigationHandler.OrbitalNavigator.Anchor", "Apollo8"
  -- )
  -- openspace.navigation.addTruckMovement(-15)
  openspace.pathnavigation.flyToNavigationState(
    -- {
    --   Anchor = 'Earth',
    --   Pitch = -0.004338812347983791,
    --   Position = {6635192.436218262, 5271771.01994133, 23208498.501390725},
    --   ReferenceFrame = 'Root',
    -- }
    {
      Anchor = 'Earth',
      Pitch = -0.004214958230153339,
      Position = {10630453.039978027, 8446072.183139801, 37183074.31481825},
      ReferenceFrame = 'Root',
      Up = {-0.2850643244796526, 0.9490836293375169, -0.13408428480804957},
      Yaw = -0.0010292842092629018
    }
    , 2)

  openspace.time.interpolateDeltaTime(5 * one_minute, 1)
elseif scene == "3" then
  legend1("Yellow trail: trajectory as seen from the launch pad")
  legend2("Red trail: compensated for Earth rotation")

  local scene_3_navstate = {
    Anchor = "Earth",
    ReferenceFrame = "Root",
    Position = {-49977208.20648193, 36950276.16604614, 1425664.9150595963},
    Up = {0.1543550315475728, 0.24569678465415035, -0.9569783771050212},
    Yaw = 0.0,
    Pitch = 0.0,
  }

  -- move the camera above A8 and zoom out a bit
  openspace.pathnavigation.createPath(
    {
      TargetType = "NavigationState",
      PathType = "AvoidCollisionWithLookAt",
      NavigationState = scene_3_navstate,
      UseTargetUpDirection = true,
      Duration = 4,
    }
  )

  -- show the A8/Barycenter trail
  openspace.setPropertyValue("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 1.0, 0.5)
elseif scene == "3b" then
  -- zoom out a bit again
  -- TODO: use an absolute position?
  -- FIXME: not needed?
  -- openspace.navigation.addTruckMovement(-15)
elseif scene == "looking-back-earth" then
  legend1("")
  legend2("")
  -- cf. https://github.com/OpenSpace/OpenSpace/issues/3549
  openspace.setPropertyValue("NavigationHandler.OrbitalNavigator.StereoscopicDepthOfFocusSurface", 100)
  -- FIXME: find another A8 model with less details, so that Earth doesn't flicker?
  openspace.time.interpolateDeltaTime(5 * one_minute, 0)
  navstate = {
    Anchor = 'Apollo8',
    Position = {16.64434814453125, 19.53519630432129, -15.535307258367538},
    ReferenceFrame = 'Root',
    Up = {-0.6885357172367306, 0.009984720611865505, -0.7251336921172566}
  }
  -- hide the trails, as they are misleading
  openspace.setPropertyValue("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 1)
  openspace.setPropertyValue("Scene.Apollo8LaunchTrail.Renderable.Opacity", 0.0, 1)
  -- OS 0.20.1
  -- openspace.pathnavigation.jumpToNavigationState(navstate, 0.5)
  -- OS latest
  openspace.pathnavigation.jumpToNavigationState(navstate, false, 0.5)
elseif scene == "4" then
  -- TODO: get a navstate where the view is centered on the middle of the earth/moon system?
  local scene_4_navstate = {
    Anchor = "Earth",
    Pitch = 0.19893809701272958,
    Position = {122772301.26016235, 388187185.74944305, 69396110.59022844},
    ReferenceFrame = "Root",
    Up = {-0.5346885916522564, 0.3096670007774672, -0.7862661499685808},
    Yaw = 0.27984183932213347,
  }

  -- OS 0.20.1
  -- openspace.pathnavigation.jumpToNavigationState(scene_4_navstate, 0.5)
  -- OS latest
  openspace.pathnavigation.jumpToNavigationState(scene_4_navstate, false, 0.5)
  -- put the A8 trails back
  openspace.setPropertyValue("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 1.0, 0.5)
  openspace.setPropertyValue("Scene.Apollo8LaunchTrail.Renderable.Opacity", 1.0, 0.5)

  -- show the moon trail and make it stand out more
  openspace.setPropertyValue(
    "Scene.MoonTrail.Renderable.Appearance.LineFadeAmount", 0.15
  )
  openspace.setPropertyValue(
    "Scene.MoonTrail.Renderable.Appearance.LineWidth", 30, 0
  )
  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Opacity", 1.0, 3)
  openspace.setPropertyValue("Scene.MoonLabel.Renderable.Enabled", true, 0)
  openspace.setPropertyValue("Scene.MoonLabel.Translation.Position", {50000000.0, -5000000.0, 0.0})

  -- speed time up, but very gradually (over 10s)
  openspace.time.interpolateDeltaTime(30 * one_minute, 10)
elseif scene == "4b" then
  legend1("")
  legend2("")
  -- hide the launch trail
  openspace.setPropertyValue("Scene.Apollo8LaunchTrail.Renderable.Opacity", 0, 0.5)
  -- show the A8/Moon trail - it will start showing up at December 23, 00:00
  openspace.setPropertyValue("Scene.Apollo8MoonTrail.Renderable.Opacity", 1.0)
  -- and accelerate a lot
  openspace.time.interpolateDeltaTime(2 * one_hour)
elseif scene == "4c" then
  legend1("Yellow trail: trajectory as seen from the Moon")
  -- hide the moon label - it's been up for long enough
  openspace.setPropertyValue("Scene.MoonLabel.Renderable.Enabled", false, 0)
elseif scene == "5" then
  legend1("")
  navstate = {
    Anchor = "Moon",
    Pitch = 0.002506849476056914,
    Position = {18903234.865875244, 59631720.832969666, 29449524.456306458},
    ReferenceFrame = "Root",
    Up = {-0.8800567998343979, 0.40301353931432915, -0.25115755253341676},
    Yaw = -0.0029955000285278284,
  }

  -- focus on the moon and get closer, for the A8 approach.
  openspace.pathnavigation.flyToNavigationState(navstate, 5)

  -- then, at 1968 DEC 24 09:25:22, zoom a bit
  -- nav.addTruckMovement(30)
  -- and hide the A8/Barycenter trail
  openspace.setPropertyValue(
    "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 2.0
  )
elseif scene == "moon-orbits-1" then
  legend1("Apollo 8 gets into moon orbit")

  openspace.time.interpolateDeltaTime(20 * one_minute)

  -- PoV "above" the moon and the trajectory
  navstate = {
    Anchor = 'Moon',
    Pitch = -0.003018411954946569,
    Position = {762558.5507202148, 7040098.491146088, 3023640.91159153},
    ReferenceFrame = 'Root',
    Up = {0.24641197804449436, 0.3598063043297566, -0.8999003058343529},
    Yaw = -0.002479214381488832
  }

  openspace.pathnavigation.flyToNavigationState(navstate, 3)
elseif scene == "earthrise" then
  legend1("")

  -- hide the A8/Moon trail and the Moon trail for this scene
  openspace.setPropertyValue("Scene.Apollo8MoonTrail.Renderable.Opacity", 0.0, 0.5)
  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Opacity", 0, 0.5)

  openspace.time.interpolateDeltaTime(5, 0)

  openspace.pathnavigation.jumpToNavigationState({
    Anchor = "Apollo8",
    Position = { 14.94592, 32.36777, -41.71296 },
    ReferenceFrame = "Root",
    Timestamp = "1968 DEC 24 16:37:25",
    Up = { 0.960608, -0.212013, 0.179675 }
  }, true, 1)
elseif scene == "earthrise-complete" then
  legend1("The Apollo 8 astronauts witness the first \"Earthrise\"")
  openspace.setPropertyValue("ScreenSpace.Earthrise.Opacity", 1, 0.5)
elseif scene == "moon-orbits-2" then
  legend1("")
  openspace.setPropertyValue("ScreenSpace.Earthrise.Opacity", 0, 0.5)

  -- PoV "above" the moon and the trajectory
  navstate = {
    Anchor = 'Moon',
    Pitch = -0.003018411954946569,
    Position = {762558.5507202148, 7040098.491146088, 3023640.91159153},
    ReferenceFrame = 'Root',
    Up = {0.24641197804449436, 0.3598063043297566, -0.8999003058343529},
    Yaw = -0.002479214381488832
  }

  openspace.pathnavigation.jumpToNavigationState(navstate, false, 0.5)
  openspace.time.interpolateDeltaTime(15 * one_minute, 5)

  openspace.setPropertyValue("Scene.Apollo8MoonTrail.Renderable.Opacity", 1.0, 1)
  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Opacity", 1.0, 1)
elseif scene == "moon-orbits-3" then
  legend1("A8 scaled x30'000")
  openspace.setPropertyValue("Scene.Apollo8.Scale.Scale", 30000, 2)
  openspace.time.interpolateDeltaTime(45 * one_minute, 5)
elseif scene == "depart-from-moon" then
  legend1("")
  openspace.time.interpolateDeltaTime(5 * one_minute, 0)
  openspace.setPropertyValue("Scene.Apollo8.Scale.Scale", 1, 2)
elseif scene == "looking-back-moon" then
  navstate = {
    Anchor = 'Apollo8',
    Pitch = 0,
    Position = {42.02239990234375, 1.6455459594726562, 22.808905601501465},
    ReferenceFrame = 'Root',
    Up = {0.47690043345713606, -0.13055571842081304, -0.8692072140496884},
    Yaw = 0,
  }

  openspace.time.interpolateDeltaTime(1 * one_minute, 0)
  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Opacity", 0.0, 1)

  openspace.pathnavigation.jumpToNavigationState(navstate, false, 0.5)
elseif scene == "back-to-earth" then
  navstate = {
    Anchor = 'Earth',
    Pitch = 0.002429006922084879,
    Position = {2434507.703063965, 449202283.677475, 266114544.18418694},
    ReferenceFrame = 'Root',
    Up = {-0.9814003185733762, -0.09388151599726902, 0.1674505170434833},
    Yaw = -0.003938608658881565
  }

  openspace.pathnavigation.jumpToNavigationState(navstate, false, 0.5)
  openspace.time.interpolateDeltaTime(3 * one_hour, 5)

  openspace.setPropertyValue("Scene.MoonTrail.Renderable.Opacity", 1.0, 2)
elseif scene == "change-trail" then
  openspace.setPropertyValue("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 1.0, 3)
  openspace.setPropertyValue("Scene.Apollo8MoonTrail.Renderable.Opacity", 0.0, 10)
elseif scene == "approaching-earth" then
  -- TODO: remove the Moon trail and the A8/Barycenter trail
  navstate = {
    Anchor = 'Apollo8',
    Position = {-13.491363525390625, 21.084396362304688, -16.53566551208496},
    ReferenceFrame = 'Root',
    Up = {-0.5811361921001542, 0.23838590012751837, 0.7781085328228483}
  }

  openspace.time.interpolateDeltaTime(5 * one_minute, 0)
  openspace.pathnavigation.jumpToNavigationState(navstate, false, 0.5)
elseif scene == "end" then
  openspace.time.interpolateDeltaTime(1, 0)
  openspace.setPropertyValue("RenderEngine.BlackoutFactor", 0, 2)
elseif scene == "loop" then
  -- FIXME: this, together with the "end" scene, is hacky but I couldn't find a better idea yet.
  openspace.time.interpolateTime("1968 DEC 21 12:51:10")
end
--
