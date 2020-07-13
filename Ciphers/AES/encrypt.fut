import "aes_tools"
import "../../lib/github.com/athas/vector/vector"
module vec2 = cat_vector vector_1 vector_1
module vec4 = cat_vector vec2 vec2

let encrypt_block (block: vec4.vector u32) : (vec4.vector u32) = 
    let rk = vec4.from_array (
        [0x2b_28_ab_09, 0x7e_ae_f7_cf, 0x15_d2_15_4f, 0x16_a6_88_3c] :> [vec4.length]u32
    )
    let r0 = vec4.map2 (^) block rk
    let s = vec4.map sub_word r0 
    let s0 : u32 = rot_word 0xd4_e0_b8_1e 0
    let s1 : u32 = vec4.get 0 s
    let s2 : u32 = rot_word (vec4.get 0 s) 0
    let s3 : u32 = ((vec4.get 0 s) << 0) | ((vec4.get 0 s) >> (4<<3))

    in vec4.from_array ([s0, s1, s2, s3] :> [vec4.length]u32)