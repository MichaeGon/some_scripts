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
        f = map toFilePath . otherModules . buildInfo
        hsfiles = f exec1
        ldfacc = foldr (\x acc -> "-l" ++ x ++ " " ++ acc) ("-L" ++ (unwords . lines) ldflags) (extraLibs . buildInfo $ exec1)
        buildpath = "./dist/build/" ++ exeName exec1
        tmppath = buildpath ++ "/" ++ exeName exec1 ++ "-tmp"
        cvt = foldr g ""
        g x acc
            | x == '/' = '_' : acc
            | otherwise = x : acc
    createDirectoryIfMissing True tmppath
    putStrLn "compiling c files..."
    forM_ cfiles $ \x -> do
        let cmd = "clang++ -c ./" ++ x ++ " -o " ++ tmppath ++ "/" ++ cvt x ++ ".o " ++ cxxflags
        putStrLn cmd
        callCommand cmd
    putStrLn "compiling and linking haskell files..."
    {-
    let hscmd = "ghc -c -O --make ./" ++ modulePath exec1 ++ " -odir " ++ tmppath
    putStrLn hscmd
    callCommand hscmd
    putStrLn "linking..."
    -}
    callCommand $ "ghc -o --make " ++ buildpath ++ "/" ++ exeName exec1 ++ " Main.hs " ++ foldr (\x acc -> tmppath ++ "/"  ++ cvt x ++ ".o " ++ acc) ldfacc cfiles
    putStrLn "done"
