module Main where

import ByteCodeInterp ( Interp(..), cpu )
import ByteCode ( ByteCode(..) )

code1 :: [ByteCode]
code1 = [LOAD_VAL 1, WRITE_VAR "x", 
        LOAD_VAL 2, WRITE_VAR "y",
        READ_VAR "x", LOAD_VAL 1,
        ADD, READ_VAR "y", 
        MULTIPLY, RETURN_VALUE]

code2 :: [ByteCode]
code2 = [LOAD_VAL 0, WRITE_VAR "i",
        READ_VAR "i", LOAD_VAL 10,
        LESS_THAN,
        BRANCH 7, RETURN_VALUE, 
        READ_VAR "i", LOAD_VAL 1,
        ADD,
        WRITE_VAR "i",
        BRANCH 2]

testwrite :: [ByteCode]
testwrite = [LOAD_VAL 10, WRITE_VAR "i",
             READ_VAR "i", RETURN_VALUE]

machine :: Interp
machine = Interp {codememory = code2, datamemory = [], stack = [], ip = 0}

main :: IO ()
main = print $ cpu machine
