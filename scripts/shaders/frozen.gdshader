shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform float border_size = 0.2;
uniform float distortion = 0.008;
uniform float strength = 0.7;

float rand(vec2 p)
{
    return fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453);
}

void fragment()
{
    vec2 uv = SCREEN_UV;

    float edge = min(min(uv.x,1.0-uv.x),min(uv.y,1.0-uv.y));
    float mask = 1.0 - smoothstep(0.0,border_size,edge);

    float angle = rand(floor(uv*250.0))*6.2831;
    vec2 offset = vec2(cos(angle), sin(angle)) * distortion * mask;

    vec4 screen = texture(screen_tex, uv + offset);

    screen.rgb = mix(screen.rgb, vec3(0.85,0.92,1.0), mask * strength);

    float frost = rand(floor(uv*500.0));
    frost = smoothstep(0.8,1.0,frost);

    screen.rgb += frost * mask * 0.2;

    COLOR = screen;
}