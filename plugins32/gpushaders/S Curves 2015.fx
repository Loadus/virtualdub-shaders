float Contrast <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.01f;
> = 0.0f;

float Linearize <
	bool vd_tunable = true;
	float vd_tunablemin = 0.01f;
	float vd_tunablemax = 10.0f;
> = 1.0f;

float ColorGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 0.45;
	float vd_tunablemax = 2.2f;
> = 1.0f;

float Saturation <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0;
	float vd_tunablemax = 8.0f;
> = 1.0f;

float RGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 2.2;
	float vd_tunablemax = 0.01f;
> = 1.0f;

float GGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 2.2;
	float vd_tunablemax = 0.01f;
> = 1.0f;

float BGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 2.2;
	float vd_tunablemax = 0.01f;
> = 1.0f;

float RContrast <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.01f;
> = 0.0f;

float GContrast <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.01f;
> = 0.0f;

float BContrast <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.01f;
> = 0.0f;

float RedCurve <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0;
	float vd_tunablemax = 8.0f;
> = 1.0f;

float GreenCurve <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0;
	float vd_tunablemax = 8.0f;
> = 1.0f;

float BlueCurve <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0;
	float vd_tunablemax = 8.0f;
> = 1.0f;

float Blend <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.0f;
> = 0.0f;

texture vd_srctexture;
float4 vd_texsize;

sampler src = sampler_state {
	Texture = <vd_srctexture>;
	AddressU = clamp;
	AddressV = clamp;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = None;
};

void VS(
	float4 pos : POSITION,
	float2 t0 : TEXCOORD0,
	out float4 oPos : POSITION,
	out float2 oT0 : TEXCOORD0
)
{
	oPos = pos;
	oT0 = t0;
}

float SCurve (float _value, float _amount) {

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

float4 PS(float2 uv : TEXCOORD0) : COLOR0 {

	float4 B = tex2D(src, uv);

		float4 A = B;

		A.r = lerp(A.r, 0.1, RContrast);
		A.g = lerp(A.g, 0.1, GContrast);
		A.b = lerp(A.b, 0.1, BContrast);

		A.r = pow(A.r, RGamma);
		A.g = pow(A.g, GGamma);
		A.b = pow(A.b, BGamma);

		A.r = SCurve(A.r, RedCurve);
		A.g = SCurve(A.g, GreenCurve);
		A.b = SCurve(A.b, BlueCurve);

		A = pow(A, 1/Linearize);

		float4 value = max(max(A.r, A.g), A.b);
		float4 color = A / value;

		color = pow(color, 1 / ColorGamma);

		float4 c0 = color * value;

		float luma = dot(c0, float3(0.30, 0.59, 0.11));
		// float luma = dot(c0, float3(0.33333, 0.33333, 0.33333));
		float4 chroma = c0 - luma;

		c0 = luma + chroma * Saturation;

		c0 = lerp(c0, B, Blend);

	return c0;

}

technique {
	pass {
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS();
	}
}