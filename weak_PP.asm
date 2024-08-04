; rcx == VERTICES_PTR
; rdx == VERTICES size
; r8 == OUT_PTR (OUT size == VERTICES size)
project:
	pcmpeqw xmm0, xmm0
	pslld xmm0, 26
	psrld xmm0, 2 ; xmm0 = 0.5 f32

	cvtsi2ss xmm1, [RES_WIDTH]
	cvtsi2ss xmm2, [RES_HEIGHT]

	mulss xmm1, xmm0 ; half_width = RES_WIDTH / 2
	mulss xmm2, xmm0 ; half_height = RES_HEIGHT / 2

	movss xmm3, [FOCAL_DISTANCE]
	movss xmm4, [SCALE]

.loop_project:
	movss xmm5, [rcx+rdx-4] ; z
	addss xmm5, xmm3 ; z = z + focal distance

	movss xmm0, [rcx+rdx-12] ; x
	mulss xmm0, xmm3 ; x = x * focal distance
	mulss xmm0, xmm4 ; x = x * scale
	divss xmm0, xmm5 ; x = x / z
	addss xmm0, xmm1 ; x = x + half_width
	movss [r8+rdx-12], xmm0 ; out_x = x

	movss xmm0, [rcx+rdx-8] ; y
	mulss xmm0, xmm3 ; y = y * focal distance
	mulss xmm0, xmm4 ; y = y * scale
	divss xmm0, xmm5 ; y = y / z
	addss xmm0, xmm2 ; y = y + half_height
	movss [r8+rdx-8], xmm0 ; out_y = y

	sub rdx, 12
	test rdx, rdx
	jnz .loop_project



	ret
