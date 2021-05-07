{-# OPTIONS_GHC -Wall -fno-warn-tabs #-}

module Types where

import Language.Haskell.TH
import Foreign.Ptr
import Foreign.C

some :: DecsQ
some = pure []

foreign import ccall "pango_language_from_string"
	c_pango_language_from_string :: CString -> IO (Ptr ())
