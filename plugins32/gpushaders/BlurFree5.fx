


float TextureScale <

	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 10.0f;

> = 1.0f;

float BlurRadius <

	bool vd_tunable = true;
	float vd_tunablemin = 0;
	float vd_tunablemax = 500;

> = 0;

float BlurScatter <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 0.1f;

> = 0.0f;

float BlurSampleSize <

	bool vd_tunable = true;
	float vd_tunablemin = 2;
	float vd_tunablemax = 16;

> = 16;

texture vd_srctexture;
float4 vd_texsize;

//////////////////////////////////////////////////////////////

texture preProcessTexture : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurTexture : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurTexture1 : RENDERCOLORTARGET <
	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

//////////////////////////////////////////////////////////////

sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler preSrc = sampler_state {
	Texture = <preProcessTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler blurSrc = sampler_state {
	Texture = <blurTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler blurSrc1 = sampler_state {
	Texture = <blurTexture1>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};


float Random(float2 p) {

	const float2 r = float2(23.1406926327792690, 2.6651441426902251);

	return frac(cos(fmod(123456789.0, 1e-7 + 256.0 * dot(p,r))));  
}

float4 CrossSample (sampler input, float2 uv, float2 size) {

	float4 C = tex2Dlod(input, float4(uv, 0.0, 0.0));

	float width = 1 / size.x;					
	float height = 1 / size.y;					

		float4 sampleTop = (tex2Dlod(input, float4(clamp(uv + float2(-1.0 * width, -2.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						    tex2Dlod(input, float4(clamp(uv + float2( 0.0 * width, -2.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						    tex2Dlod(input, float4(clamp(uv + float2(-1.0 * width, -1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						    tex2Dlod(input, float4(clamp(uv + float2( 0.0 * width, -1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)));


		float4 sampleRight = (tex2Dlod(input, float4(clamp(uv + float2( 1.0 * width, -1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						      tex2Dlod(input, float4(clamp(uv + float2( 2.0 * width, -1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						      tex2Dlod(input, float4(clamp(uv + float2( 1.0 * width,  0.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						      tex2Dlod(input, float4(clamp(uv + float2( 2.0 * width,  0.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)));


		float4 sampleBottom = (tex2Dlod(input, float4(clamp(uv + float2( 0.0 * width,  1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						       tex2Dlod(input, float4(clamp(uv + float2( 1.0 * width,  1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						       tex2Dlod(input, float4(clamp(uv + float2( 0.0 * width,  2.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						       tex2Dlod(input, float4(clamp(uv + float2( 1.0 * width,  2.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)));


		float4 sampleLeft = (tex2Dlod(input, float4(clamp(uv + float2(-2.0 * width,  0.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						     tex2Dlod(input, float4(clamp(uv + float2(-1.0 * width,  0.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						     tex2Dlod(input, float4(clamp(uv + float2(-2.0 * width,  1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)) +
						     tex2Dlod(input, float4(clamp(uv + float2(-1.0 * width,  1.0 * height), float2(0.0, 0.0), vd_texsize.xy), 0.0, 0.0)));


		C += (sampleTop + sampleRight + sampleBottom + sampleLeft) * 0.5;

		C *= 0.1111;


	return C; 
}

float4 BlurH (sampler input, float2 size, float2 uv, int radius) {


	float4 C = float4(0.0, 0.0, 0.0, 1.0); 	
	float width = 1 / size.x;					
	float divisor = 0.0; 

	for (float x = -radius; x <= radius; x++)
	{
		C += CrossSample(input, uv + float2(x * width, 0.0), size);
		divisor++;
	}
	
	return C / divisor; 

	return tex2D(input, uv);  
}

float4 BlurV (sampler input, float2 size, float2 uv, int radius) {


	float4 C = float4(0.0, 0.0, 0.0, 1.0);	
	float height = 1 / size.y;					
	float divisor = 0.0; 
	
	for (float y = -radius; y <= radius; y++)
	{
		C += CrossSample(input, uv + float2(0.0, y * height), size);
		divisor++;
	}

	return C / divisor; 

	return tex2D(input, uv);  
}


//////////////////////////////////////////////////////////////

void VS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0;
}

void DownScaleVS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0 * TextureScale;
}

void UpScaleVS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0 / TextureScale;
}

//////////////////////////////////////////////////////////////

float4 PreProcessPS (float2 uv : TEXCOORD0) : COLOR0 {

	float4 S = tex2D(src, uv);

	float dispersion_a = Random(uv + S.rg) * BlurScatter;
	float dispersion_b = Random(uv + S.gb) * BlurScatter;
	float dispersion_c = Random(uv + S.rb) * BlurScatter; 
	float dispersion_d = Random(uv + S.ba) * BlurScatter;

	float4 A = tex2D(src, uv + float2(dispersion_a - dispersion_b, dispersion_c - dispersion_d));
		
			// TODO
			// color processing before blur,
			// apply a logistic / sigmoid
			// transformation to all pixels here
			// (might be faster) (or not)
			// +
			// This downscales the texture for more
			// blur radius

	return A;
}

float4 BlurHorizontalPS (float2 uv : TEXCOORD0) : COLOR0 {

	float4 A = BlurH (preSrc, 
					  float2(vd_texsize.x, vd_texsize.y), 
					  uv,
					  BlurRadius); 

	return A;
}

float4 BlurVerticalPS (float2 uv : TEXCOORD0) : COLOR0 {

	float4 A = BlurV (blurSrc, 
					  float2(vd_texsize.x, vd_texsize.y), 
					  uv,
					  BlurRadius);

	return A;
}

float4 PostProcessPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = tex2D(blurSrc1, uv);
		
	return A;
}

//////////////////////////////////////////////////////////////

technique {

	pass preProcess < string vd_target = "preProcessTexture"; > 
	{

		VertexShader = compile vs_3_0 DownScaleVS();
		PixelShader = compile ps_3_0 PreProcessPS();
	}

	pass blurH < string vd_target = "blurTexture"; >
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 BlurHorizontalPS();
	}

	pass blurV < string vd_target = "blurTexture1"; >
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 BlurVerticalPS();
	}

	pass final < string vd_target = ""; >
	{
		VertexShader = compile vs_3_0 UpScaleVS();
		PixelShader = compile ps_3_0 PostProcessPS();
	}
}
