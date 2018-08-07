{-# LANGUAGE CPP #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}
#ifdef USE_REFLEX_OPTIMIZER
{-# OPTIONS_GHC -fplugin=Reflex.Optimizer #-}
#endif
module Reflex.NotReady.Class
  ( NotReady(..)
  ) where

import Control.Monad.Reader (ReaderT)
import Control.Monad.Trans

import Reflex.Class
import Reflex.DynamicWriter.Base (DynamicWriterT)
import Reflex.EventWriter.Base (EventWriterT)
import Reflex.PerformEvent.Base (PerformEventT)
import Reflex.PostBuild.Base (PostBuildT)
import Reflex.Query.Base (QueryT)
import Reflex.Requester.Base (RequesterT)
import Reflex.TriggerEvent.Base (TriggerEventT)

class Monad m => NotReady t m | m -> t where
  notReadyUntil :: Event t a -> m ()
  default notReadyUntil :: (MonadTrans f, m ~ f m', NotReady t m') => Event t a -> m ()
  notReadyUntil = lift . notReadyUntil

  notReady :: m ()
  default notReady :: (MonadTrans f, m ~ f m', NotReady t m') => m ()
  notReady = lift notReady

instance NotReady t m => NotReady t (ReaderT r m)
instance NotReady t m => NotReady t (PostBuildT t m)
instance NotReady t m => NotReady t (EventWriterT t w m)
instance NotReady t m => NotReady t (DynamicWriterT t w m)
instance NotReady t m => NotReady t (QueryT t q m)
instance NotReady t m => NotReady t (PerformEventT t m)
instance NotReady t m => NotReady t (RequesterT t request response m)
instance NotReady t m => NotReady t (TriggerEventT t m)
