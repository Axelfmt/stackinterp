module Main where

import ByteCodeInterp
import ByteCode

code = [LOAD_VAL 1, WRITE_VAR "x", 
        LOAD_VAL 2, WRITE_VAR "y",
        READ_VAR "x", LOAD_VAL 1,
        ADD, READ_VAR "y", 
        MULTIPLY, RETURN_VALUE]

machine = Interp {codememory = code, datamemory = [], stack = []}

main :: IO ()
main = print $ cpu machine
