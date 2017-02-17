function love.conf(t)
  t.title = "Cellular AutoMaton"
  t.version = "0.10.2"
  t.window.width = 800
  t.window.height = 600

  t.releases = {
    title = "CellularAutomaton",              -- The project title (string)
    package = "CellularAutomaton",            -- The project command and package name (string)
    loveVersion = '0.10.2',        -- The project LÖVE version
    version = '0.1.1',            -- The project version
    author = 'Jon.Xie',             -- Your name (string)
    email = 'xiejiangzhi@gmail.com',              -- Your email (string)
    description = nil,        -- The project description (string)
    homepage = nil,           -- The project homepage (string)
    identifier = 'com.jon_xie.CellularAutomaton',         -- The project Uniform Type Identifier (string)
    excludeFileList = {'spec/*', 'releases/*'},     -- File patterns to exclude. (string list)
    releaseDirectory = 'releases',   -- Where to store the project releases (string)
  }
end

