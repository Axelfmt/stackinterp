module ByteCodeInterp where

import ByteCode ( ByteCode(..) )
import Prelude hiding (lookup)
import System.Mem (performGC)

data Interp = Interp {
    codememory :: [ByteCode],
    datamemory :: [(String, Int)],
    stack :: [Int]
}

cpu :: Interp -> Int
cpu (Interp cm dm stck)
    | null cm = head stck
    | otherwise = case head cm of
        LOAD_VAL v -> cpu (Interp (tail cm) dm (v:stck))
        WRITE_VAR s -> cpu (Interp (tail cm) ((s, head stck):dm) (tail stck))
        READ_VAR s -> cpu (Interp (tail cm) dm (lookup s dm:stck))
        ADD -> cpu (Interp (tail cm) dm (compute (+) stck))
        MULTIPLY -> cpu (Interp (tail cm) dm (compute (*) stck))
        SUB -> cpu (Interp (tail cm) dm (compute (-) stck))
        DIV -> cpu (Interp (tail cm) dm (compute div stck))
        RETURN_VALUE -> head stck

lookup :: String -> [(String, Int)] -> Int
lookup _ [] = -1
lookup id ((s, v):xs) =
    if id == s
       then v
       else lookup id xs

compute :: (Int -> Int -> Int) -> [Int] -> [Int]
compute op lst = [result] where
    result = op (head lst) (last lst)