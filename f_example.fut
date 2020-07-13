import "lib/github.com/athas/vector/vector"
module vec2 = cat_vector vector_1 vector_1
module vec4 = cat_vector vec2 vec2

let encrypt_buffer [n] 
    (f: (vec4.vector u32) -> (vec4.vector u32))
    (buffer: [n][4]u32) : [n][4]u32  =
        map (\row ->
            let blk = vec4.from_array (row :> [vec4.length]u32)
            let res = f blk
            in (vec4.to_array res) :> [4]u32
        ) buffer

let rot_word (word: u32) (n: u32) : u32 = (word << (n<<3)) | (word >> ((4-n)<<3))

let encrypt_block (block: vec4.vector u32) : (vec4.vector u32) = 
    let s0 : u32 = rot_word 0x32_88_31_e0 0
    let s1 : u32 = vec4.get 0 block
    let s2 : u32 = rot_word (vec4.get 0 block) 0
    let s3 : u32 = ((vec4.get 0 block) << 0) | ((vec4.get 0 block) >> (4<<3))

    in vec4.from_array ([s0, s1, s2, s3] :> [vec4.length]u32)

entry example [n] (buffer: [n][4]u32) : [n][4]u32 = encrypt_buffer encrypt_block buffer