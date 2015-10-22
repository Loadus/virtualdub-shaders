float Exposure <
	bool vd_tunable = true;
	float vd_tunablemin = 0.01f;
	float vd_tunablemax = 10.0f;
> = 2.2f;

float ExposureShift <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 1.0f;

float Contrast <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.01f;
> = 0.1f;

float Linearize <
	bool vd_tunable = true;
	float vd_tunablemin = 0.01f;
	float vd_tunablemax = 2.5f;
> = 2.5f;

float ColorGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 0.1;
	float vd_tunablemax = 5.0f;
> = 1.0f;

float Saturation <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0;
	float vd_tunablemax = 8.0f;
> = 1.0f;

float Bleach <
	bool vd_tunable = true;
	float vd_tunablemin = 0.0f;
	float vd_tunablemax = 1.0f;
> = 0.0f;

float RGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 3.0;
	float vd_tunablemax = 0.01f;
> = 0.45f;

float GGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 3.0;
	float vd_tunablemax = 0.01f;
> = 0.45f;

float BGamma <
	bool vd_tunable = true;
	float vd_tunablemin = 3.0;
	float vd_tunablemax = 0.01f;
> = 0.45f;

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
	float vd_tunablemax = 20.0f;
> = 1.0f;

float GreenCurve <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0;
	float vd_tunablemax = 20.0f;
> = 1.0f;

float BlueCurve <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0;
	float vd_tunablemax = 20.0f;
> = 1.0f;

float Blend <
	bool vd_tunable = true;
	float vd_tunablemin = 1.0f;
	float vd_tunablemax = 0.0f;
> = 0.2f;

static float4x4 RGB =
{
2.67147117265996,-1.26723605786241,-0.410995602172227,0,
-1.02510702934664,1.98409116241089,0.0439502493584124,0,
0.0610009456429445,-0.223670750812863,1.15902104167061,0,
0, 0, 0, 0
};

static float4x4 XYZ =
{
0.500303383543316,0.338097573222739,0.164589779545857,0,
0.257968894274758,0.676195259144706,0.0658358459823868,0,
0.0234517888692628,0.1126992737203,0.866839673124201,0,
0, 0, 0, 0
};

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

float4 PS(float2 uv : TEXCOORD0) : COLOR0 {
   float4 A = tex2D(src, uv);

	    float4 An = A;

	    float4 C = A;

	    A = (A * (1 - Contrast)) + Contrast / 3;
	    A.r = (A.r * (1 - RContrast)) + RContrast / 3;
	    A.g = (A.g * (1 - GContrast)) + GContrast / 3;
	    A.b = (A.b * (1 - BContrast)) + BContrast / 3;

	    A = pow(A, Linearize);

	    float4 Ap = A;

	    Ap = pow(Ap, 1/Linearize);

		  A = 1 - A;

		  A = pow(A, Exposure);

		  A = 1 - A;

	    float4 a0 = lerp(Ap, A, ExposureShift);

	    float4 B = dot(float3(1.0/3.0, 1.0/3.0, 1.0/3.0), a0.rgb);

	    float4 Bb = 1 - B;
  
	    Bb = pow(Bb, Linearize);

	    B = lerp(B, Bb, Bleach);

	    B.r = (1 /(1 + exp(- RedCurve * (B.r - .5))) - (1 / (1 + exp(RedCurve / 2))))/(1 - 2 * (1 / (1 + exp(RedCurve / 2))));				
	    B.g = (1 /(1 + exp(- GreenCurve * (B.g - .5))) - (1 / (1 + exp(GreenCurve / 2))))/(1 - 2 * (1 / (1 + exp(GreenCurve / 2))));				
	    B.b = (1 /(1 + exp(- BlueCurve * (B.b - .5))) - (1 / (1 + exp(BlueCurve / 2))))/(1 - 2 * (1 / (1 + exp(BlueCurve / 2))));					

	    B.r = pow(B.r, RGamma);
	    B.g = pow(B.g, GGamma);
	    B.b = pow(B.b, BGamma);

	    if (B.r < 0.5)

		C.r = (2 * B.r - 1) * (A.r - A.r * A.r) + A.r;

	      else

		C.r = (2 * B.r - 1) * (sqrt(A.r) - A.r) + A.r;

	    if (B.g < 0.5)

		C.g = (2 * B.g - 1) * (A.g - A.g * A.g) + A.g;

	      else

		C.g = (2 * B.g - 1) * (sqrt(A.g) - A.g) + A.g;

	    if (B.b < 0.5)

		C.b = (2 * B.b - 1) * (A.b - A.b * A.b) + A.b;

	      else

		C.b = (2 * B.b - 1) * (sqrt(A.b) - A.b) + A.b;

	    A = C;

	    B = dot(float3(1.0/3.0, 1.0/3.0, 1.0/3.0), A.rgb);

	    Bb = 1 - B;
  
	    Bb = pow(Bb, Linearize);

	    B = lerp(B, Bb, Bleach);

	    B = (B * (1 - Contrast)) + Contrast / 3;
	    B.r = (B.r * (1 - RContrast)) + RContrast / 3;
	    B.g = (B.g * (1 - GContrast)) + GContrast / 3;
	    B.b = (B.b * (1 - BContrast)) + BContrast / 3;

	    B.r = (1 /(1 + exp(- RedCurve * (B.r - .5))) - (1 / (1 + exp(RedCurve / 2))))/(1 - 2 * (1 / (1 + exp(RedCurve / 2))));				
	    B.g = (1 /(1 + exp(- GreenCurve * (B.g - .5))) - (1 / (1 + exp(GreenCurve / 2))))/(1 - 2 * (1 / (1 + exp(GreenCurve / 2))));				
	    B.b = (1 /(1 + exp(- BlueCurve * (B.b - .5))) - (1 / (1 + exp(BlueCurve / 2))))/(1 - 2 * (1 / (1 + exp(BlueCurve / 2))));					

	    B.r = pow(B.r, RGamma);
	    B.g = pow(B.g, GGamma);
	    B.b = pow(B.b, BGamma);

	    if (B.r < 0.5)

		C.r = (2 * B.r - 1) * (A.r - A.r * A.r) + A.r;

	      else

		C.r = (2 * B.r - 1) * (sqrt(A.r) - A.r) + A.r;

	    if (B.g < 0.5)

		C.g = (2 * B.g - 1) * (A.g - A.g * A.g) + A.g;

	      else

		C.g = (2 * B.g - 1) * (sqrt(A.g) - A.g) + A.g;

	    if (B.b < 0.5)

		C.b = (2 * B.b - 1) * (A.b - A.b * A.b) + A.b;

	      else

		C.b = (2 * B.b - 1) * (sqrt(A.b) - A.b) + A.b;


	   C = pow(C, 1/Linearize);

	   float4 value = max(max(C.r, C.g), C.b);
	   float4 color = C / value;
	
	   color = pow(color, 1/ColorGamma);
	
	   float4 c0 = color * value;

	   c0 = mul(XYZ, c0);

	   float luma = dot(c0, float3(0.30, 0.59, 0.11));
	   float4 chroma = c0 - luma;

	   c0 = luma + chroma * Saturation;
	   c0 = mul(RGB, c0);

	   c0 = lerp(c0, An, Blend);

  return c0;

}

technique {
	pass {
		VertexShader = compile vs_3_0 VS();
		PixelShader = compile ps_3_0 PS();
	}
}