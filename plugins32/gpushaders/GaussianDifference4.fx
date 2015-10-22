


float Strength <

	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 100.0f;

> = 18.0f;

float OutlineCutoff <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 3.0f;

> = 0.2f;

float OutlineRadius <

	bool vd_tunable = true;
	int vd_tunablemin = 0;
	int vd_tunablemax = 20;

> = 3;

float Noise_Reduction <

	bool vd_tunable = true;
	float vd_tunablemin = 0;
	float vd_tunablemax = 100;

> = 2;

float Highlights <

	bool vd_tunable = true;
	float vd_tunablemin = 50.0f;
	float vd_tunablemax = -50.0f;

> = -18.0f;

float Shadows <

	bool vd_tunable = true;
	float vd_tunablemin = 50.0f;
	float vd_tunablemax = -50.0f;

> = 5.0f;

float Blend <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;

> = 1.0f;

float Contrast <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;

> = 1.0f;

float Highlight_Steepness <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 500.0f;

> = 200.0f;

float Shadows_Steepness <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 500.0f;

> = 200.0f;

float Highlight_Blur <

	bool vd_tunable = true;
	int vd_tunablemin = 0;
	int vd_tunablemax = 100;

> = 3;

float Shadows_Blur <

	bool vd_tunable = true;
	int vd_tunablemin = 0;
	int vd_tunablemax = 100;

> = 3;

float Gamma <

	bool vd_tunable = true;
	float vd_tunablemin = 0.35f;
	float vd_tunablemax = 3.0f;

> = 1.0f;

texture vd_srctexture;
float4 vd_texsize;

//////////////////////////////////////////////////////////////

texture edgeMapTexture_h : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture edgeMapTexture_v : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurTexture_h : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurTexture_v : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurHighlightsTexture : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture highlightsTexture : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture blurShadowsTexture : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture shadowsTexture : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture preProcessTexture : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;

texture preProcessTexture2 : RENDERCOLORTARGET <

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

sampler edgeMapSrc_h = sampler_state {
	Texture = <edgeMapTexture_h>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler edgeMapSrc_v = sampler_state {
	Texture = <edgeMapTexture_v>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler blurSrc_h = sampler_state {
	Texture = <blurTexture_h>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler blurSrc_v = sampler_state {
	Texture = <blurTexture_v>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler blurHighlightsSrc = sampler_state {
	Texture = <blurHighlightsTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler highlightsSrc = sampler_state {
	Texture = <highlightsTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler blurShadowsSrc = sampler_state {
	Texture = <blurShadowsTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler shadowsSrc = sampler_state {
	Texture = <shadowsTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler preProcessSrc = sampler_state {
	Texture = <preProcessTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

sampler preProcessSrc2 = sampler_state {
	Texture = <preProcessTexture2>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Point;
	MagFilter = Point;
	MipFilter = None;
};

//////////////////////////////////////////////////////////////


float Cubic (float value) {
	
    // Possibly slightly faster calculation
    // when compared to Sigmoid
    
    if (value < 0.5)
    {
        return value * value * value * value * value * 16.0; 
    }
    
    else
    {
    	value -= 1.0;
    
    	return value * value * value * value * value * 16.0 + 1.0;
    }

    return value; 
}

float Sigmoid (float x) {

	//return 1.0 / (1.0 + (exp(-(x * 14.0 - 7.0))));
    return 1.0 / (1.0 + (exp(-(x - 0.5) * 14.0))); 
}


float4 BlurH (sampler input, float2 size, float2 uv, int radius) {


	float2 coordinate = float2(0.0, 0.0);

	float4 A = float4(0.0, 0.0, 0.0, 1.0); 
	float4 C = float4(0.0, 0.0, 0.0, 1.0); 

	float weight = 1.0; 

	float width = 1.0 / size.x;
					
	float divisor = 0.000001; 

	for (float x = -radius; x <= radius; x++)
	{
		coordinate = uv + float2(x * width, 0.0);
		coordinate = clamp(coordinate, 0.0, 1.0); 

		A = tex2Dlod(input, float4(coordinate, 0.0, 0.0));
		
			weight = Cubic(1.0 - (abs(x) / radius)); 
		
			C += A * weight; 
		
		divisor += weight;
	}
	
	return C / divisor; 
}

float4 BlurV (sampler input, float2 size, float2 uv, int radius) {


	float2 coordinate = float2(0.0, 0.0);

	float4 A = float4(0.0, 0.0, 0.0, 1.0); 
	float4 C = float4(0.0, 0.0, 0.0, 1.0); 

	float weight = 1.0; 
	
	float height = 1.0 / size.y;
					
	float divisor = 0.000001; 
	
	for (float y = -radius; y <= radius; y++)
	{
		coordinate = uv + float2(0.0, y * height);
		coordinate = clamp(coordinate, 0.0, 1.0);
		
		A = tex2Dlod(input, float4(coordinate, 0, 0));
		
			weight = Cubic(1.0 - (abs(y) / radius)); 
		
			C += A * weight; 
		
		divisor += weight;
	}

	return C / divisor; 
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


//////////////////////////////////////////////////////////////

float4 PreProcessHPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurH (src, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  Noise_Reduction);
	return A;
}

float4 PreProcessVPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurV (preProcessSrc, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  Noise_Reduction);	
	
	return pow(A, Gamma);
}

float4 BlurHighlightsHorizontalPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurH (preProcessSrc2, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  Highlight_Blur);

	return A;
}

float4 BlurHighlightsVerticalPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurV (blurHighlightsSrc, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  Highlight_Blur);
	return A;
}

float4 BlurShadowsHorizontalPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurH (preProcessSrc2, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  Shadows_Blur);
	return A;
}

float4 BlurShadowsVerticalPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurV (blurShadowsSrc, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  Shadows_Blur);
	return A;
}

float4 BlurHorizontalPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurH (preProcessSrc2, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  OutlineRadius);
	return A;
}

float4 BlurVerticalPS (float2 uv : TEXCOORD0) : COLOR0 {


	float4 A = BlurV (blurSrc_h, 
				  float2(vd_texsize.x, vd_texsize.y), 
				  uv,
				  OutlineRadius);	
	return A;
}

float4 Main (float2 uv : TEXCOORD0) : COLOR0 {


	float A = dot(float3(0.333, 0.333, 0.333), tex2D(blurSrc_v, uv).rgb);
	float4 B = tex2D(preProcessSrc2, uv);
	float B_g = dot(float3(0.333, 0.333, 0.333), B.rgb);

	float C = 0.5;

	float B_s = B_g * Strength; 
	float A_s = A * Strength; 

		if (abs(B_s - A_s) > OutlineCutoff)
		{
			C = (0.5 - A_s) + B_s; 
		}
		
		C = clamp(C, 0.0, 1.0);

	float mask = 0.0;
	
	// Apply a sigmoid contrast curve to the original image
	float4 E = lerp(B, float4(Cubic(B.r), Cubic(B.g), Cubic(B.b), 1.0), Contrast); 

	// Blend the outlines with the original using a PTLight formula
	float4 D = (1 - C) * (C * E) + C * (1 - (1 - C) * (1 - E));

		D = lerp (D, C, Blend);

	// Create the highlight and shadow areas

	float F_HL = dot(float3(0.333, 0.333, 0.333), tex2D(highlightsSrc, uv).rgb);
	float F_SH = dot(float3(0.333, 0.333, 0.333), tex2D(shadowsSrc, uv).rgb);

	float F_high = F_HL * (1 + Highlight_Steepness) - Highlight_Steepness * 0.5 + Highlights; 
	float F_low = F_SH * (1 + Shadows_Steepness) - Shadows_Steepness * 0.2 + Shadows; 

		// Make sure we won't go over budget 
		// (with ugly color artifacts)
		F_high = clamp(F_high, 0.0, 1.0);
		F_high += 0.5;

		F_low = clamp(F_low, 0.0, 1.0);
		F_low -= 0.5; 


	float4 G = D;;

	float H = dot(float3(0.333, 0.333, 0.333), D.rgb);

		// Blend the highlights
		// G = 1.0 - (1.0 - F_high) * (1.0 - D); 

		// Blend the shadows
		if (H > 0.5)
		{
			G = 1.0 - 2.0 * (1.0 - F_high) * (1.0 - G);
			G = 1.0 - 2.0 * (1.0 - F_low) * (1.0 - G);
		}

		else
		{
			G = 2 * F_high * G; 
			G = 2 * F_low * G; 
		}

	float4 I = float4(0.5, 0.0, 0.0, 1.0);

	// return float4(E.r, E.g, E.b, 1.0);
	return float4(G.r, G.g, G.b, 1.0);
	// return float4(F_SH, F_SH, F_SH, 1.0);
	// return float4(F_HL, F_HL, F_HL, 1.0);
}

//////////////////////////////////////////////////////////////

technique {

	pass preProcess1 < string vd_target = "preProcessTexture"; >
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PreProcessHPS();
	}

	pass preProcess2 < string vd_target = "preProcessTexture2"; >
	{
		PixelShader = compile ps_3_0 PreProcessVPS();
	}

	pass blurHighlights_h < string vd_target = "blurHighlightsTexture"; >
	{
		PixelShader = compile ps_3_0 BlurHighlightsHorizontalPS();
	}

	pass blurHighlights_v < string vd_target = "highlightsTexture"; >
	{
		PixelShader = compile ps_3_0 BlurHighlightsVerticalPS();
	}

	pass blurShadow_h < string vd_target = "blurShadowsTexture"; >
	{
		PixelShader = compile ps_3_0 BlurShadowsHorizontalPS();
	}

	pass blurShadow_v < string vd_target = "shadowsTexture"; >
	{
		PixelShader = compile ps_3_0 BlurShadowsVerticalPS();
	}

	pass blurH < string vd_target = "blurTexture_h"; >
	{
		PixelShader = compile ps_3_0 BlurHorizontalPS();
	}

	pass blurV < string vd_target = "blurTexture_v"; >
	{
		PixelShader = compile ps_3_0 BlurVerticalPS();
	}

	pass final < string vd_target = ""; >
	{
		PixelShader = compile ps_3_0 Main();
	}
}
