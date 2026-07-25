shader_type canvas_item;

uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int line_count : hint_range(10, 200, 1) = 60;
uniform float line_width : hint_range(0.01, 0.5, 0.01) = 0.1;
uniform float min_length : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform float max_length : hint_range(0.0, 1.0, 0.01) = 0.7;
uniform float speed : hint_range(0.1, 10.0, 0.1) = 3.0;

float random(float seed) {
    return fract(sin(seed * 12.9898) * 43758.5453123);
}

void fragment() {
    vec2 screen_size = SCREEN_PIXEL_SIZE;
    float ratio = screen_size.x / screen_size.y;

    vec2 uv = UV - 0.5;
    uv.x *= ratio;

    float angle = atan(uv.y, uv.x);

    float radius = length(uv) * 2.0;

    float angle_fraction = (angle + 3.14159265359) / (2.0 * 3.14159265359);

    float scaled_angle = angle_fraction * float(line_count);
    float index = floor(scaled_angle);
    float f = fract(scaled_angle);

    float time_val = TIME * speed;
    float rnd1 = random(index);
    float rnd2 = random(index + 54.23);

    float twitch = sin(time_val * (10.0 + rnd1 * 15.0) + rnd2 * 6.28);
    float current_length = mix(min_length, max_length, rnd1) + twitch * 0.1;

    float width_mod = smoothstep(0.0, line_width, f) * (1.0 - smoothstep(line_width * 0.5, line_width, f));

    // Ограничиваем линии, чтобы они начинались не из центра
    float mask = step(current_length, radius);

    float alpha = width_mod * mask;

    COLOR = vec4(line_color.rgb, line_color.a * alpha);
}