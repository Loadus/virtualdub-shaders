

float amount <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 8.0f;
> = 1.0f;




// desc										x		y		z		w

float4 vd_vpsize;	// viewport				w		h		1/h		1/w
float4 vd_srcsize;	// source size			w		h		1/h		1/w
float4 vd_texsize;	// source texture size	w		h		1/h		1/w
float4 vd_vpcorrect2;// target screenspace	xscale	yscale	yadd	xadd

//////////////////////////////////////////////////////////////

texture vd_srctexture;

texture downScaledTexture : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurTexture : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture downScaledTexture2 : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurTexture2 : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture bloomTexture : RENDERCOLORTARGET <
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
	MipFilter = Linear;
};

sampler downScaleSrc = sampler_state {
	Texture = <downScaledTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler blurSrc = sampler_state {
	Texture = <blurTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler downScaleSrc2 = sampler_state {
	Texture = <downScaledTexture2>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler blur2Src = sampler_state {
	Texture = <blurTexture2>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

sampler bloomSrc = sampler_state {
	Texture = <bloomTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
};

//////////////////////////////////////////////////////////////

void ScaleDownVS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos * amount;
	oT0 = t0 * amount;
}

float4 ScaleDownPS (float2 uv : TEXCOORD0) : COLOR0 {
   
   float4 A = tex2D(src, uv);

   return A;
}

//////////////////////////////////////////////////////////////

void BlurVS(float4 pos : POSITION,
			float2 t0 : TEXCOORD0,
			out float4 oPos : POSITION,
			out float2 oT0 : TEXCOORD0,
			out float2 oT1 : TEXCOORD1,
			out float2 oT2 : TEXCOORD2,
			out float2 oT3 : TEXCOORD3,
			out float2 oT4 : TEXCOORD4) {
	
	oPos = pos;
	oT0 = t0 + float2( 0.0f,  0.0f) * vd_texsize.wz;
	oT1 = t0 + float2( 0.0f, -1.2f) * vd_texsize.wz;
	oT2 = t0 + float2( 0.0f,  1.2f) * vd_texsize.wz;
	oT3 = t0 + float2(-1.2f,  0.0f) * vd_texsize.wz;
	oT4 = t0 + float2( 1.2f,  0.0f) * vd_texsize.wz;
}

float4 BlurPS(	float2 t0 : TEXCOORD0,
				float2 t1 : TEXCOORD1,
				float2 t2 : TEXCOORD2,
				float2 t3 : TEXCOORD3,
				float2 t4 : TEXCOORD4) : COLOR0 {


	float4 p0 = tex2D(downScaleSrc, t0);
	float4 p1 = tex2D(downScaleSrc, t1);
	float4 p2 = tex2D(downScaleSrc, t2);
	float4 p3 = tex2D(downScaleSrc, t3);
	float4 p4 = tex2D(downScaleSrc, t4);
	float4 p5 = tex2D(downScaleSrc, float2(t3.x, t1.y));
	float4 p6 = tex2D(downScaleSrc, float2(t4.x, t1.y));
	float4 p7 = tex2D(downScaleSrc, float2(t3.x, t2.y));
	float4 p8 = tex2D(downScaleSrc, float2(t4.x, t2.y));

	float4 Blur = p0 * (36.0f * 0.00390625f)
				+ p1 * (30.0f * 0.00390625f)
				+ p2 * (30.0f * 0.00390625f)
				+ p3 * (30.0f * 0.00390625f)
				+ p4 * (30.0f * 0.00390625f)
				+ p5 * (25.0f * 0.00390625f)
				+ p6 * (25.0f * 0.00390625f)
				+ p7 * (25.0f * 0.00390625f)
				+ p8 * (25.0f * 0.00390625f);

	return Blur; 
}


//////////////////////////////////////////////////////////////

void ScaleDownVS2 (float4 pos : POSITION,	
			 		 float2 t0 : TEXCOORD0,
					 out float4 oPos : POSITION, 
					 out float2 oT0 : TEXCOORD0)
{
	oPos = pos * amount;
	oT0 = t0 * amount;
}

float4 ScaleDownPS2 (float2 uv : TEXCOORD0) : COLOR0 {
   
   float4 A = tex2D(blurSrc, uv);

   return A;
}

//////////////////////////////////////////////////////////////

void BlurVS2 (float4 pos : POSITION,
				float2 t0 : TEXCOORD0,
				out float4 oPos : POSITION,
				out float2 oT0 : TEXCOORD0,
				out float2 oT1 : TEXCOORD1,
				out float2 oT2 : TEXCOORD2,
				out float2 oT3 : TEXCOORD3,
				out float2 oT4 : TEXCOORD4) {
	
	oPos = pos;
	oT0 = t0 + float2( 0.0f,  0.0f) * vd_texsize.wz;
	oT1 = t0 + float2( 0.0f, -1.2f) * vd_texsize.wz;
	oT2 = t0 + float2( 0.0f,  1.2f) * vd_texsize.wz;
	oT3 = t0 + float2(-1.2f,  0.0f) * vd_texsize.wz;
	oT4 = t0 + float2( 1.2f,  0.0f) * vd_texsize.wz;
}

float4 BlurPS2 (float2 t0 : TEXCOORD0,
					float2 t1 : TEXCOORD1,
					float2 t2 : TEXCOORD2,
					float2 t3 : TEXCOORD3,
					float2 t4 : TEXCOORD4) : COLOR0 {


	float4 p0 = tex2D(downScaleSrc2, t0);
	float4 p1 = tex2D(downScaleSrc2, t1);
	float4 p2 = tex2D(downScaleSrc2, t2);
	float4 p3 = tex2D(downScaleSrc2, t3);
	float4 p4 = tex2D(downScaleSrc2, t4);
	float4 p5 = tex2D(downScaleSrc2, float2(t3.x, t1.y));
	float4 p6 = tex2D(downScaleSrc2, float2(t4.x, t1.y));
	float4 p7 = tex2D(downScaleSrc2, float2(t3.x, t2.y));
	float4 p8 = tex2D(downScaleSrc2, float2(t4.x, t2.y));

	float4 Blur = p0 * (36.0f * 0.00390625f)
				+ p1 * (30.0f * 0.00390625f)
				+ p2 * (30.0f * 0.00390625f)
				+ p3 * (30.0f * 0.00390625f)
				+ p4 * (30.0f * 0.00390625f)
				+ p5 * (25.0f * 0.00390625f)
				+ p6 * (25.0f * 0.00390625f)
				+ p7 * (25.0f * 0.00390625f)
				+ p8 * (25.0f * 0.00390625f);

	return Blur; 
}

//////////////////////////////////////////////////////////////

void ScaleUpVS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos / amount / amount;
	oT0 = t0 / amount / amount;
}

float4 ScaleUpPS (float2 uv : TEXCOORD0) : COLOR0 {
   
   float4 A = tex2D(blur2Src, uv);

   return A;
}


//////////////////////////////////////////////////////////////

void BloomVS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0;
}

float4 BloomPS (float2 uv : TEXCOORD0) : COLOR0 {
   
   float4 A = tex2D(bloomSrc, uv);
   float4 B = tex2D(src, uv);

   float D = dot(float3(0.333, 0.333, 0.333), A.rgb);

   float4 C = 1 - (1 - A) * (1 - B);


   return C;
}


//////////////////////////////////////////////////////////////


technique {

	pass downScale < string vd_target = "downScaledTexture"; > {

		VertexShader = compile vs_3_0 ScaleDownVS();
		PixelShader = compile ps_3_0 ScaleDownPS();
	}

	pass blur < string vd_target = "blurTexture"; > {

		VertexShader = compile vs_3_0 BlurVS();
		PixelShader = compile ps_3_0 BlurPS();
	}
	
	pass downScale2 < string vd_target = "downScaledTexture2"; > {

		VertexShader = compile vs_3_0 ScaleDownVS2();
		PixelShader = compile ps_3_0 ScaleDownPS2();
	}

	pass blur2 < string vd_target = "blurTexture2"; > {

		VertexShader = compile vs_3_0 BlurVS2();
		PixelShader = compile ps_3_0 BlurPS2();
	}

	pass bloom < string vd_target = "bloomTexture"; > {

		VertexShader = compile vs_3_0 ScaleUpVS(); 
		PixelShader = compile ps_3_0 ScaleUpPS(); 
	}

	pass final < string vd_target = ""; > {

		VertexShader = compile vs_3_0 BloomVS(); 
		PixelShader = compile ps_3_0 BloomPS(); 
	}
}
