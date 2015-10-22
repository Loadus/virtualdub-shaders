
float Radius <

	bool vd_tunable = true;
	int vd_tunablemin = 0;
	int vd_tunablemax = 100;

> = 2;

float Threshold <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;

> = 0.0f;

float Direction <
	
	bool vd_tunable = true; 
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 3.0f;

> = 3.0f;

float Strength <

	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 100.0f;

> = 10.0f;


float Blend <

	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;

> = 1.0f;


texture vd_srctexture;
float4 vd_texsize;


texture blurTexture_h : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = { 1.0, 1.0 };
>;

texture blurTexture_v : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = { 1.0, 1.0 };
>;

texture postProcessTexture : RENDERCOLORTARGET <

	string Format = "A8R8G8B8";
	float2 ViewportRatio = {1.0, 1.0};
>;


sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = ANISOTROPIC;
	MagFilter = ANISOTROPIC;
	MipFilter = None;
};

sampler blurSrc_h = sampler_state {
	Texture = <blurTexture_h>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = ANISOTROPIC;
	MagFilter = ANISOTROPIC;
	MipFilter = None;
};

sampler blurSrc_v = sampler_state {
	Texture = <blurTexture_v>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = ANISOTROPIC;
	MagFilter = ANISOTROPIC;
	MipFilter = None;
};

sampler postProcessSrc = sampler_state {
	Texture = <postProcessTexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = ANISOTROPIC;
	MagFilter = ANISOTROPIC;
	MipFilter = None;
};

float SigmoidCurve (float _value, float _amount) {

    if (_value < 0.5f)
    {
        _value = pow(_value, _amount) * pow(2.0f, _amount) * 0.5f; 
    }
        
    else
    { 	
    	_value = 1.0f - pow(1.0f - _value, _amount) * pow(2.0f, _amount) * 0.5f; 
    }

    return _value;
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
		
			weight = SigmoidCurve(1.0 - (abs(x) / radius), 2.0f); 
		
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
		
			weight = SigmoidCurve(1.0 - (abs(y) / radius), 2.0f); 
		
			C += A * weight; 
		
		divisor += weight;
	}

	return C / divisor; 
}

void VS (float4 pos : POSITION,	
 		 float2 t0 : TEXCOORD0,
		 out float4 oPos : POSITION, 
		 out float2 oT0 : TEXCOORD0)
{
	oPos = pos;
	oT0 = t0;
}

float4 BlurHorizontalPS (float2 uv : TEXCOORD0) : COLOR0 {

	float4 A;

			Direction = floor(Direction);

			if (Direction == 0.0f || Direction >= 2.0f)
			{
				A = BlurH (src, 
				    float2(vd_texsize.x, vd_texsize.y), 
				    uv,
					Radius);
			}

			else
			{
				A = tex2D(src, uv);
			}

	return A;
}

float4 BlurVerticalPS (float2 uv : TEXCOORD0) : COLOR0 {

	float4 A;
			
			Direction = floor(Direction);

			if (Direction == 1.0f || Direction >= 2.0f)
			{
				A = BlurV (blurSrc_h, 
				    float2(vd_texsize.x, vd_texsize.y), 
				    uv,
					Radius);
			}

			else
			{
				A = tex2D(blurSrc_h, uv);
			}

	return A;
}

float4 Main (float2 uv : TEXCOORD0) : COLOR0 {

	float4 A = tex2D(blurSrc_v, uv);
	float4 B = tex2D(src, uv); 
	float C = 0.5f;

	float A_g = dot(float3(0.3333f, 0.3333f, 0.3333f), A.rgb);
	float B_g = dot(float3(0.3333f, 0.3333f, 0.3333f), B.rgb);

	float A_s = A_g * Strength;
	float B_s = B_g * Strength;

		if (abs(A_s - B_s) > Threshold)
		{
			C = (0.5f - A_s) + B_s;
		}

		//C = clamp(C, 0.0f, 1.0f);

	float4 D;

		//D = (1.0f - C) * (C * B) + C * (1.0f - (1.0f - C) * (1.0f - B));

		if (C < 0.5)

			D = (2 * C - 1) * (B - B * B) + B;

		else

			D = (2 * C - 1) * (sqrt(B) - B) + B;

	return lerp(B, D, Blend);

}

technique {

	pass blurHorizontal < string vd_target = "blurTexture_h"; >
	{
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 BlurHorizontalPS();
	}

	pass blurVertical < string vd_target = "blurTexture_v"; >
	{
		PixelShader = compile ps_3_0 BlurVerticalPS();
	}

	pass mainPass < string vd_target = ""; >
	{
		PixelShader = compile ps_3_0 Main();
	}
}