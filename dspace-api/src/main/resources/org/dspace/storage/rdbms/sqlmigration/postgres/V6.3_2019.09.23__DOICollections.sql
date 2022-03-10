
-------------------------------------------
-- Add support for DOICollections (table and seq.) --
-- * Hrafn Malmquist
-- * 25/09/2019
-------------------------------------------

CREATE SEQUENCE IF NOT EXISTS doicollection_seq;

CREATE TABLE IF NOT EXISTS Doicollection
(
  doicollection_id           INTEGER PRIMARY KEY,
  doicollection_uuid              UUID UNIQUE
);