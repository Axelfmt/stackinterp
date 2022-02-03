module Main where

import ByteCodeInterp ( Interp(..), cpu )
import ByteCode
    ( ByteCode(RETURN_VALUE, MULTIPLY, ADD, READ_VAR, WRITE_VAR,
               LOAD_VAL) )

code :: [ByteCode]
code = [LOAD_VAL 1, WRITE_VAR "x", 
        LOAD_VAL 2, WRITE_VAR "y",
        READ_VAR "x", LOAD_VAL 1,
        ADD, READ_VAR "y", 
        MULTIPLY, RETURN_VALUE]

machine :: Interp
machine = Interp {codememory = code, datamemory = [], stack = []}

main :: IO ()
main = print $ cpu machine
