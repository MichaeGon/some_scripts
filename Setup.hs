import Distribution.Simple
import Distribution.Simple.LocalBuildInfo
import Distribution.Simple.Setup
import Distribution.PackageDescription
import Distribution.ModuleName hiding (main)
import System.Directory
import System.Process
import Control.Monad

main :: IO ()
main = defaultMainWithHooks simpleUserHooks{buildHook = myBuildHook}

myBuildHook :: PackageDescription -> LocalBuildInfo -> UserHooks -> BuildFlags -> IO ()
myBuildHook desc _ _ _ = do
    cxxflags <- readProcess "llvm-config" ["--cxxflags"] []
    ldflags <- readProcess "llvm-config" ["--libdir", "--system-libs", "--libs", "core", "mcjit", "native"] []
    let exec1 = head . executables $ desc
        cfiles = cSources . buildInfo $ exec1
        f = (:) <$> modulePath <*> (map ((++ ".hs") . toFilePath) . otherModules . buildInfo)
        hsfiles = f exec1
        ldfacc = foldr (\x acc -> "-l" ++ x ++ " " ++ acc) ("-L" ++ (unwords . lines) ldflags) (extraLibs . buildInfo $ exec1)
        buildpath = "./dist/build/" ++ exeName exec1
        tmppath = buildpath ++ "/" ++ exeName exec1 ++ "-tmp"
    createDirectoryIfMissing True tmppath
    putStrLn "compiling c files..."
    forM_ cfiles $ \x -> do
        let cmd = "clang++ -c ./" ++ x ++ " -o " ++ tmppath ++ "/" ++ x ++ ".o " ++ cxxflags
        putStrLn cmd
        callCommand cmd
    putStrLn "compiling haskell files..."
    forM_ hsfiles $ \x -> do
        let cmd = "ghc -c ./" ++ x ++ " -o " ++ tmppath ++ "/" ++ x ++ ".o"
        putStrLn cmd
        callCommand cmd
    putStrLn "linking..."
    callCommand $ "ghc -o " ++ buildpath ++ "/" ++ exeName exec1 ++ " " ++ foldr (\x acc -> "./dist/build/" ++ exeName exec1 ++ "/" ++ exeName exec1 ++ "-tmp/" ++ x ++ ".o " ++ acc) ldfacc (hsfiles ++ cfiles)
    putStrLn "done"
