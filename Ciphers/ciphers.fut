module aes_encrypt = import "AES/encrypt"
module vec4 = aes_encrypt.vec4

import "AES/aes_tools"

-- Common
let encrypt_buffer [n] 
    (f: (vec4.vector u32) -> (vec4.vector u32))
    (buffer: [n][4]u32) : [n][4]u32  =
        map (\row ->
            let blk = vec4.from_array (row :> [vec4.length]u32)
            let res = f blk
            in (vec4.to_array res) :> [4]u32
        ) buffer
-- AES

entry aes_encrypt_buffer [n]
    (buffer: [n][4]u32)
    : [n][4]u32 = encrypt_buffer aes_encrypt.encrypt_block buffer