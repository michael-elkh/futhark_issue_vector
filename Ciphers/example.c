#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include "ciphers.h"

void print_blk(uint32_t *blk)
{
	for (size_t i = 0; i < 4; i++)
	{
		printf("%.2x-%.2x-%.2x-%.2x\n",
			   (blk[i] >> 24) & 0xff,
			   (blk[i] >> 16) & 0xff,
			   (blk[i] >> 8) & 0xff,
			   (blk[i] >> 0) & 0xff);
	}
	printf("\n");
}

int main()
{
	//Init
  	struct futhark_context_config *cfg = futhark_context_config_new();
 	struct futhark_context *ctx = futhark_context_new(cfg);
	//Encrypt blocks
	uint32_t blk[4] = {
		0x328831e0,
		0x435a3137,
		0xf6309807,
		0xa88da234};

	struct futhark_u32_2d *out, *in;
	in = futhark_new_u32_2d(ctx, blk, 1, 4);
	futhark_entry_aes_encrypt_buffer(ctx, &out, in);
	futhark_context_sync(ctx);
	futhark_values_u32_2d(ctx, out, blk);

	printf("Blk result:\n");
	print_blk(blk);
	//Destroy
	futhark_free_u32_2d(ctx, in);
	futhark_free_u32_2d(ctx, out);
	futhark_context_free(ctx);
	futhark_context_config_free(cfg);
	return EXIT_SUCCESS;
}