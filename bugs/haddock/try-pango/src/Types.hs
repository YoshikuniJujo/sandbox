{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE PatternSynonyms, ViewPatterns #-}
{-# OPTIONS_GHC -Wall -fno-warn-tabs #-}

module Types where

import Language.Haskell.TH
import Foreign.Ptr
import Foreign.C.String
import Data.Int
import System.IO.Unsafe

mkMemberGen :: Name -> Name -> String -> Integer -> DecsQ
mkMemberGen t c n v = sequence [
	patSynSigD (mkName n) (conT t),
	patSynD (mkName n) (prefixPatSyn [])
		(explBidir [clause [] (normalB (conE c `appE` litE (IntegerL v))) []])
		(conP c [litP (IntegerL v)])
	]

newtype PangoScript = PangoScript Int32 deriving Show

mkMemberPangoScript :: String -> Integer -> DecsQ
mkMemberPangoScript = mkMemberGen ''PangoScript 'PangoScript

newtype PangoLanguage = PangoLanguage_ (Ptr PangoLanguage)

pangoLanguageFromString :: String -> PangoLanguage
pangoLanguageFromString l = unsafePerformIO $ withCString l \cl ->
	PangoLanguage_ <$> c_pango_language_from_string cl

foreign import ccall "pango_language_from_string"
	c_pango_language_from_string :: CString -> IO (Ptr PangoLanguage)
