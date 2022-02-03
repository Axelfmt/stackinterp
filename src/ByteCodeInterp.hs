module ByteCodeInterp where

import ByteCode ( ByteCode(..) )
import Prelude hiding (lookup)
import System.Mem (performGC)

data Interp = Interp {
    codememory :: [ByteCode],
    datamemory :: [(String, Int)],
    stack :: [Int],
    ip :: Int
}

cpu :: Interp -> Int
cpu (Interp cm dm stck ip) =
    case cm !! ip of
        LOAD_VAL v -> cpu (Interp cm dm (v:stck) (ip+1))
        WRITE_VAR s -> cpu (Interp cm
                                   (writeval s (head stck) dm)
                                   (tail stck)
                                   (ip+1))
        READ_VAR s -> cpu (Interp cm dm (lookup s dm:stck) (ip+1))
        ADD -> cpu (Interp cm dm (compute (+) stck) (ip+1))
        MULTIPLY -> cpu (Interp cm dm (compute (*) stck) (ip+1))
        SUB -> cpu (Interp cm dm (compute (-) stck) (ip+1))
        DIV -> cpu (Interp cm dm (compute div stck) (ip+1))
        LESS_THAN -> if head $ compute (<) stck
                        then cpu (Interp cm dm [] (ip+1))
                        else cpu (Interp cm dm stck (ip+2))
        BRANCH v -> cpu (Interp cm dm [] v)
        RETURN_VALUE -> head stck

lookup :: String -> [(String, Int)] -> Int
lookup _ [] = -1
lookup id ((s, v):xs) =
    if id == s
       then v
       else lookup id xs

compute :: (a -> a -> b) -> [a] -> [b]
compute op lst = [result] where
    result = op (last lst) (head lst)

writeval :: String -> Int -> [(String, Int)] -> [(String, Int)]
writeval str val pairs =
    if not (any (\pair -> fst pair == str) pairs)
       then (str, val):pairs
       else map (\pair -> if fst pair == str
                             then (str, val)
                             else pair)
                pairs
