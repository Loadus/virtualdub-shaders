

float amount <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 1.0f;

float BlurRadius <

	bool vd_tunable = true;
	float vd_tunablemin = 0;
	float vd_tunablemax = 300;

> = 10;

float BlurScatter <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 0.2f;

> = 0.0f;

float sigmoid_r <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 0.7f;

float sigmoid_g <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 0.7f;

float sigmoid_b <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 0.7f;

float gamma <
	bool vd_tunable = true;
	float vd_tunablemin = 0.01f;
	float vd_tunablemax = 2.2f;
> = 1.00f;

float TextureScale <

	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 10.0f;

> = 1.0f;


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

//////////////////////////////////////////////////////////////

float Sigmoid (float x) {

	return 1.0 / (1.0 + (exp(-(x / 0.8 * 2.0 - 1.2) * 5.0 * 1.0)));
}

float Random(float2 p)
{
	const float2 r = float2(23.1406926327792690, 2.6651441426902251);

	return frac(cos(fmod(123456789.0, 1e-7 + 256.0 * dot(p,r))));  
}

float4 BlurH (sampler input, float2 size, float2 uv, int radius) {


	float4 C = float4(0.0, 0.0, 0.0, 1.0); 
	
	float width = 1 / size.x;
					
	int divisor = 0; 

	for (float x = -radius; x <= radius; x++)
	{
		C += tex2Dlod(input, float4(uv + float2(x * width, 0.0), 0, 0));
		divisor++;
	}
	
	return C / divisor; 

	return tex2D(input, uv);  
}

float4 BlurV (sampler input, float2 size, float2 uv, int radius) {


	float4 C = float4(0.0, 0.0, 0.0, 1.0); 
	
	float height = 1 / size.y;
					
	int divisor = 0; 
	
	for (float y = -radius; y <= radius; y++)
	{
		C += tex2Dlod(input, float4(uv + float2(0.0, y * height), 0, 0));
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
   		
   		A = pow(A, gamma);

   		A.r = lerp(A.r, Sigmoid(A.r), sigmoid_r);
   		A.g = lerp(A.g, Sigmoid(A.g), sigmoid_g);
   		A.b = lerp(A.b, Sigmoid(A.b), sigmoid_b);

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
	float4 B = tex2D(src, uv);

	float4 C = 1.0 - (1.0 - A) * (1.0 - B);  // Screen
   	// float4 C = (1.0 - A) * (A * B) + A * (1.0 - (1.0 - A) * (1.0 - B)); // PTLight

   		C = lerp(B, C, amount);

	return C;
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
