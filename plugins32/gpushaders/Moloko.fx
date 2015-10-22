


float threshold <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 0.9f;

float distance <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 0.05f;


texture vd_srctexture;
float4 vd_texsize;

//////////////////////////////////////////////////////////////

texture blurTexture : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;


//////////////////////////////////////////////////////////////

sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = None;
};

sampler blurSrc = sampler_state {
	Texture = <blurTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

//////////////////////////////////////////////////////////////

float4 BlurRadius7 (sampler input, float2 size, float2 uv : TEXCOORD0) : COLOR0 {

	float width = 1 / size.x;
	float height = 1 / size.y; 

  return (

    tex2D(input, uv + float2(-3.0f * width,     -3.0f * height)) +
    tex2D(input, uv + float2(-2.0f * width,     -3.0f * height)) +
    tex2D(input, uv + float2(-1.0f * width,     -3.0f * height)) +
    tex2D(input, uv + float2(0,                   -3.0f * height)) +
    tex2D(input, uv + float2(1.0f * width,      -3.0f * height)) +
    tex2D(input, uv + float2(2.0f * width,      -3.0f * height)) +
    tex2D(input, uv + float2(3.0f * width,      -3.0f * height)) +
 
    tex2D(input, uv + float2(-3.0f * width,     -2.0f * height)) +
    tex2D(input, uv + float2(-2.0f * width,     -2.0f * height)) +
    tex2D(input, uv + float2(-1.0f * width,     -2.0f * height)) +
    tex2D(input, uv + float2(0,                   -2.0f * height)) +
    tex2D(input, uv + float2(1.0f * width,      -2.0f * height)) +
    tex2D(input, uv + float2(2.0f * width,      -2.0f * height)) +
    tex2D(input, uv + float2(3.0f * width,      -2.0f * height)) +
 
    tex2D(input, uv + float2(-3.0f * width,     -1.0f * height)) +
    tex2D(input, uv + float2(-2.0f * width,     -1.0f * height)) +
    tex2D(input, uv + float2(-1.0f * width,     -1.0f * height)) +
    tex2D(input, uv + float2(0,                   -1.0f * height)) +
    tex2D(input, uv + float2(1.0f * width,      -1.0f * height)) +
    tex2D(input, uv + float2(2.0f * width,      -1.0f * height)) +
    tex2D(input, uv + float2(3.0f * width,      -1.0f * height)) +
 
    tex2D(input, uv + float2(-3.0f * width,     0)) +
    tex2D(input, uv + float2(-2.0f * width,     0)) +
    tex2D(input, uv + float2(-1.0f * width,     0)) +
    tex2D(input, uv + float2(0,                   0)) +
    tex2D(input, uv + float2(1.0f * width,      0)) +
    tex2D(input, uv + float2(2.0f * width,      0)) +
    tex2D(input, uv + float2(3.0f * width,      0)) +
 
    tex2D(input, uv + float2(-3.0f * width,     1.0f * height)) +
    tex2D(input, uv + float2(-2.0f * width,     1.0f * height)) +
    tex2D(input, uv + float2(-1.0f * width,     1.0f * height)) +
    tex2D(input, uv + float2(0,                   1.0f * height)) +
    tex2D(input, uv + float2(1.0f * width,      1.0f * height)) +
    tex2D(input, uv + float2(2.0f * width,      1.0f * height)) +
    tex2D(input, uv + float2(3.0f * width,      1.0f * height)) +
 
    tex2D(input, uv + float2(-3.0f * width,     2.0f * height)) +
    tex2D(input, uv + float2(-2.0f * width,     2.0f * height)) +
    tex2D(input, uv + float2(-1.0f * width,     2.0f * height)) +
    tex2D(input, uv + float2(0,                   2.0f * height)) +
    tex2D(input, uv + float2(1.0f * width,      2.0f * height)) +
    tex2D(input, uv + float2(2.0f * width,      2.0f * height)) +
    tex2D(input, uv + float2(3.0f * width,      2.0f * height)) +
 
    tex2D(input, uv + float2(-3.0f * width,     3.0f * height)) +
    tex2D(input, uv + float2(-2.0f * width,     3.0f * height)) +
    tex2D(input, uv + float2(-1.0f * width,     3.0f * height)) +
    tex2D(input, uv + float2(0,                   3.0f * height)) +
    tex2D(input, uv + float2(1.0f * width,      3.0f * height)) +
    tex2D(input, uv + float2(2.0f * width,      3.0f * height)) +
    tex2D(input, uv + float2(3.0f * width,      3.0f * height))
  
  ) / 49;

}

//////////////////////////////////////////////////////////////

void BlurVS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0;
}

float4 FirstBlurPS (float2 uv : TEXCOORD0) : COLOR0 {

   float4 A = tex2D(src, uv);

   		A = BlurRadius7(src, 
   						float2(vd_texsize.x, vd_texsize.y), 
   						uv);

   return A;
}

float4 BlurPS (float2 uv : TEXCOORD0) : COLOR0 {

   float4 A;
   float4 B = tex2D(src, uv);

   		A = BlurRadius7(blurSrc, 
   						float2(vd_texsize.x, vd_texsize.y), 
   						uv);


   		if (A.r < B.r || A.g < B.g || A.b < B.b)
   		{
   			A = lerp(A, B, threshold);
   		}

   		
   		if (A.r > B.r + distance || A.g > B.g + distance || A.b > B.b + distance)
   		{
   			A = lerp(A, B, threshold);
   		}

   		

   return A;
}

//////////////////////////////////////////////////////////////

technique {

	pass blur < string vd_target = "blurTexture"; > {

		VertexShader = compile vs_3_0 BlurVS();
		PixelShader = compile ps_3_0 BlurPS();
	}


	// pass blur2 < string vd_target = "blurTexture"; > {

	// 	VertexShader = compile vs_3_0 BlurVS();
	// 	PixelShader = compile ps_3_0 BlurPS();
	// }

	// pass blur3 < string vd_target = "blurTexture"; > {

	// 	VertexShader = compile vs_3_0 BlurVS();
	// 	PixelShader = compile ps_3_0 BlurPS();
	// }

	// pass blur4 < string vd_target = "blurTexture"; > {

	// 	VertexShader = compile vs_3_0 BlurVS();
	// 	PixelShader = compile ps_3_0 BlurPS();
	// }

	// pass blur5 < string vd_target = "blurTexture"; > {

	// 	VertexShader = compile vs_3_0 BlurVS();
	// 	PixelShader = compile ps_3_0 BlurPS();
	// }

	pass final < string vd_target = ""; > {

		VertexShader = compile vs_3_0 BlurVS();
		PixelShader = compile ps_3_0 BlurPS();
	}
}
