function love.conf(t)
  t.window.title = "Dashing through the sunrise"
  t.window.fullscreen = true
  t.window.fullscreentype = "desktop"
  t.window.msaa = 8
  
  t.releases = {
    title = "Dashing through the sunrise",              -- The project title (string)
    package = 'DashingThroughSunrise',            -- The project command and package name (string)
    loveVersion = '0.10.2',        -- The project LÖVE version
    version = '0.2',            -- The project version
    author = 'Peter Kiss',             -- Your name (string)
    email = 'peter@yscik.com',              -- Your email (string)
    description = '',        -- The project description (string)
    homepage = 'http://badpoet.itch.io/dashing-through-the-sunrise',           -- The project homepage (string)
    identifier = 'io.badpoet.sunrise',         -- The project Uniform Type Identifier (string)
    releaseDirectory = 'build',   -- Where to store the project releases (string)
  }
end