module ByteCode where

data ByteCode = 
    LOAD_VAL Int |
    WRITE_VAR String |
    READ_VAR String |
    ADD |
    MULTIPLY |
    SUB |
    DIV |
    RETURN_VALUE
    deriving (Eq, Show)
