local one_minute = 60
local one_hour = 60 * one_minute

-- nice close view of the take-off:
-- {'Anchor': 'Earth',
-- 'Pitch': 0.8223378899877442,
-- 'Position': [886708.7511619244, -5622674.594097832, 3007143.335715321],
-- 'Timestamp': '1968 DEC 21 12:53:04',
-- 'Up': [0.3179628346406082, 0.48564056601941774, 0.8142805882640509],
-- 'Yaw': 0.29227254398770475}

-- nice view of A8 going out of the atmosphere:
-- {'Anchor': 'Earth',
--  'Pitch': 1.5749997192404859,
--  'Position': [844484.4389369619, -5556090.264981303, 3069051.4636229915],
--  'Timestamp': '1968 DEC 21 12:52:52',
--  'Up': [0.9900033896854753, 0.0909043549631067, -0.1078410249395429],
--  'Yaw': -0.013556703273582889}
--  up until 12:55:00 ?

if scene == "lift-off" then
  openspace.time.interpolateDeltaTime(5, 0)
  openspace.setPropertyValue("Dashboard.ElapsedTime.LowestTimeUnit", 3) -- seconds
  -- Have the camera follow the earth rotation for now
  openspace.setPropertyValueSingle(
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
elseif scene == "leaving-atmo" then
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
  openspace.pathnavigation.jumpToNavigationState(navstate, 0.5)
elseif scene == "1" then
  scene_1_navstate = {
      Anchor = "Earth",
      Pitch = 0,
      Position = {6293676.95904541, 5468725.167415619, 20957880.594990373},
      ReferenceFrame = "Root",
      -- Timestamp = "1968 DEC 21 12:51:02",
      Up = {-0.2921629243111312, 0.9431645300075538, -0.15837138312712412},
      Yaw = 0,
      Roll = 0,
  }
  openspace.navigation.setNavigationState(scene_1_navstate, false)

  -- Prevent the camera from rotating with the Earth
  openspace.setPropertyValueSingle(
      "NavigationHandler.OrbitalNavigator.FollowAnchorNodeRotation", false
  )

  openspace.setPropertyValueSingle(
      "Scene.Apollo8LaunchTrail.Renderable.Opacity", 1.0, 0
  )
  openspace.setPropertyValueSingle(
      "Scene.Apollo8LaunchTrail.Renderable.Appearance.EnableFade", false
  )
  openspace.setPropertyValueSingle("Scene.Apollo8LaunchTrail.Renderable.Enabled", true)

  openspace.setPropertyValueSingle(
      "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 0
  )
  openspace.setPropertyValueSingle(
      "Scene.Apollo8EarthBarycenterTrail.Renderable.Appearance.EnableFade", false
  )
  openspace.setPropertyValueSingle(
      "Scene.Apollo8EarthBarycenterTrail.Renderable.Enabled", true
  )

  openspace.setPropertyValueSingle("Scene.Apollo8MoonTrail.Renderable.Opacity", 0.0, 0)
  openspace.setPropertyValueSingle(
      "Scene.Apollo8MoonTrail.Renderable.Appearance.EnableFade", false
  )
  openspace.setPropertyValueSingle("Scene.Apollo8MoonTrail.Renderable.Enabled", true)

  -- Hide the moon trail for now: the perpective may be misleading
  openspace.setPropertyValueSingle("Scene.MoonTrail.Renderable.Opacity", 0)

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
  openspace.setPropertyValueSingle(
    "NavigationHandler.OrbitalNavigator.Anchor", "Apollo8"
  )
  -- openspace.navigation.addTruckMovement(-15)
  openspace.pathnavigation.flyToNavigationState(
    {
      Anchor = 'Apollo8',
      Pitch = -0.004338812347983791,
      Position = {6635192.436218262, 5271771.01994133, 23208498.501390725},
      ReferenceFrame = 'Root',
    }
    , 2)

  openspace.time.interpolateDeltaTime(5 * one_minute, 1)
elseif scene == "3" then
  local scene_3_navstate = {
    Anchor = "Apollo8",
    ReferenceFrame = "Root",
    Position = {-49977208.20648193, 36950276.16604614, 1425664.9150595963},
    Up = {-0.18822411488912283, -0.21763145572127995, -0.957709889295732},
    -- TODO: fix the yaw, pitch and roll
  }

  -- move the camera above A8 and zoom out a bit
  openspace.pathnavigation.createPath(
    {
      TargetType = "NavigationState",
      PathType = "AvoidCollisionWithLookAt",
      NavigationState = scene_3_navstate,
      Duration = 4,
    }
  )

  -- show the A8/Barycenter trail
  openspace.setPropertyValueSingle("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 1.0, 0.5)
elseif scene == "3b" then
  -- zoom out a bit again
  -- TODO: use an absolute position?
  openspace.navigation.addTruckMovement(-15)
elseif scene == "looking-back-earth" then
  openspace.time.interpolateDeltaTime(5 * one_minute, 0)
  navstate = {
    Anchor = 'Apollo8',
    Position = {16.64434814453125, 19.53519630432129, -15.535307258367538},
    ReferenceFrame = 'Root',
    Up = {-0.6885357172367306, 0.009984720611865505, -0.7251336921172566}
  }
  -- hide the trails, as they are misleading
  openspace.setPropertyValueSingle("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 0.5)
  openspace.setPropertyValueSingle("Scene.Apollo8LaunchTrail.Renderable.Opacity", 0.0, 0.5)
  openspace.pathnavigation.jumpToNavigationState(navstate, 0.5)
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

  openspace.pathnavigation.jumpToNavigationState(scene_4_navstate, 0.5)
  -- put the A8 trails back
  openspace.setPropertyValueSingle("Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 1.0, 0.5)
  openspace.setPropertyValueSingle("Scene.Apollo8LaunchTrail.Renderable.Opacity", 1.0, 0.5)

  -- show the moon trail and make it stand out more
  openspace.setPropertyValueSingle(
    "Scene.MoonTrail.Renderable.Appearance.LineFadeAmount", 0.15
  )
  openspace.setPropertyValueSingle(
    "Scene.MoonTrail.Renderable.Appearance.LineWidth", 30, 0
  )
  openspace.setPropertyValueSingle("Scene.MoonTrail.Renderable.Opacity", 1.0, 3)
  -- speed time up, but very gradually (over 10s)
  openspace.time.interpolateDeltaTime(30 * one_minute, 10)
elseif scene == "4b" then
  -- hide the launch trail
  openspace.setPropertyValueSingle("Scene.Apollo8LaunchTrail.Renderable.Opacity", 0, 0.5)
  -- show the A8/Moon trail - it will start showing up at December 23, 00:00
  openspace.setPropertyValueSingle("Scene.Apollo8MoonTrail.Renderable.Opacity", 1.0)
  -- and accelerate a lot
  openspace.time.interpolateDeltaTime(2 * one_hour)
elseif scene == "5" then
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
  openspace.setPropertyValueSingle(
    "Scene.Apollo8EarthBarycenterTrail.Renderable.Opacity", 0.0, 2.0
  )
end
