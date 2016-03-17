import Distribution.Simple
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.Setup
import Distribution.PackageDescription
import Distribution.ModuleName hiding (main)
import System.Directory
import System.FilePath
import System.Process

main :: IO ()
main = defaultMainWithHooks simpleUserHooks{buildHook = myBuildHook}

myBuildHook :: PackageDescription -> LocalBuildInfo -> UserHooks -> BuildFlags -> IO ()
myBuildHook desc lbinfo _ _ = mapM_ (compileExecutable lbinfo) $ executables desc


compileExecutable :: LocalBuildInfo -> Executable -> IO ()
compileExecutable lbinfo exec = createDirectoryIfMissing True tmppath
                            >> putStrLn "compiling c files..."
                            >> mapM_ cmpcf cfiles
                            >> putStrLn "compiling and linking haskell files..."
                            >> hscmd >>= putStrLn
                            >> hscmd >>= callCommand
                            >> putStrLn "done"
    where
        tmppath = buildpath </> exeName exec ++ "-tmp"
        buildpath = buildDir lbinfo </> exeName exec
        cmpcf x = cmd >>= putStrLn >> cmd >>= callCommand
            where
                cmd = (("clang++ -c ./" ++ x ++ " -o " ++ tmppath </> cvt x -<.> "o ") ++) <$> cxxflags
                cxxflags = readProcess "llvm-config" ["--cxxflags"] []
        cfiles = cSources . buildInfo $ exec
        cvt = foldr g ""
        g x acc
            | x == '/' = '_' : acc
            | otherwise = x : acc
        hscmd = (("ghc -O -hidir " ++ tmppath ++ " -odir " ++ tmppath ++ " -tmpdir " ++ tmppath ++ " --make -o " ++ buildpath </> exeName exec ++ " " ++ modulePath exec ++ " ") ++) <$> ofiles
            where
                ofiles = flip (foldr (\x acc -> tmppath </> cvt x -<.> "o " ++ acc)) cfiles <$> ldfacc
                ldfacc = flip (foldr (\x acc -> "-l" ++ x ++ " " ++ acc)) (extraLibs . buildInfo $ exec) <$> ldflags
                ldflags = (("-L" ++) . unwords . lines) <$> readProcess "llvm-config" ["--libdir", "--system-libs", "--libs", "core", "mcjit", "native"] []
