MTA00:
    .db $2B,$2B,$2B,$2B
MTA01:
    .db $2E,$2F,$30,$31

MetaTilesetA:
    .word MTA00,MTA01

meta_tile_sets:
    .word MetaTilesetA