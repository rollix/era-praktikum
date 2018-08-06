;-------------------------------------------------------------------------------
; filter5(int N, int *start, int length, int *dest):
; Applies a median filter to a signal array at start, writes the result to dest
;-------------------------------------------------------------------------------

section .data

; error messages
msg_blockLength db '-- ERROR : Block length must be odd and positive',0xa,0xa
msg_signalLength db '-- ERROR : Signal length cannot be negative',0xa,0xa


section .text

global filter5

; Main function: Check parameters, copy array, sort blocks, find and write medians
; edi: int N (block length)
; esi: int *start (start address)
; edx: int length (signal length)
; ecx: int *dest (destination address)
filter5:
	; check if block length is positive
	cmp edi, 0
	jle error_blockLength

	; check if block length is odd
	test edi, 1
	je error_blockLength
	
	; check if signal length is non-negative
	test edx, edx
	js error_signalLength
	
	; Copy the array from start to dest
	call copy_array
	
	; Sort the copied array by blocks
	call sort_array
	
	; Find medians and write them to dest
	call find_medians
	
	; End function
	ret

	
; Copy the array from start to dest
; esi: start
; edi: dest
copy_array:
	push rax
	push rsi
	push rcx
	push rdx
	
; Loop over the array at start and copy integers to dest
copy_loop:
	cmp edx, 0		; if no values are left, end loop
	je end_copy
	
	mov eax, [esi]		; copy current value (4 bytes)
	mov [ecx], eax		; post value at destination (4 bytes)
	
	add esi, 4		; move to next int (4 bytes)
	add ecx, 4		; move to next int (4 bytes)
	dec edx		; decrement counter
	
	jmp copy_loop

end_copy:
	pop rdx
	pop rcx
	pop rsi
	pop rax
	ret


; Divide the array at dest into blocks of length N and sort them in ascending order
; Incomplete block at the end will be ignored
; edi: N
; edx: length
; esi: dest
; eax: offset
; r10: block start address 
sort_array:
	push rax
	push r10
	
	mov eax, 0
	mov r10d, ecx
	
sort_array_loop:
	; offset += N
	add eax, edi
	; if offset > length, end loop
	cmp eax, edx
	jg end_sort_array
	
	; sort block
	call sort_block	
	
	; dest += N*4
	shl edi, 2
	add r10d, edi
	shr edi, 2
	
	jmp sort_array_loop

end_sort_array:
	pop r10
	pop rax
	ret


; Sort single block using the selection sort algorithm
; edi: N
; r10d: block start address
sort_block:
	push rax
	push rbx
	push rsi
	push r8
	push r9

	mov eax, 0		; outer loop counter
	mov r8d, r10d		; outer loop address
	
sort_outer_loop:
	cmp eax, edi
	je end_outer_loop
	
	mov ebx, eax	; inner loop counter
	mov r9d, r8d	; address of current minimum 
	mov esi, [r8d]	; value of hold current minimum
	
sort_inner_loop:
	inc ebx
	; if end is reached, then minimum is found
	cmp ebx, edi
	je end_inner_loop
	
	; check if minimum needs to be updated
	cmp esi, [r10d + 4*ebx]
	jle sort_inner_loop
	
	; set new minimum:
	mov r9d, r10d
	shl ebx,2
	add r9d, ebx
	shr ebx,2
	mov esi, [r9d]
	
	jmp sort_inner_loop
	
end_inner_loop:
	call swap_int
	inc eax
	add r8d, 4
	
	jmp sort_outer_loop
	
end_outer_loop:
	pop r9
	pop r8
	pop rsi
	pop rbx
	pop rax
	ret


; swap two integers stored at r8d and r9d
swap_int:
	push rax
	push rbx
	
	mov eax, [r8d]		; save first value
	mov ebx, [r9d]		; save second value
	mov [r8d], ebx		; write second value
	mov [r9d], eax		; write first value
	
	pop rbx
	pop rax
	ret
	
; Find medians and write them to dest
; eax: number of blocks
; ebx: current address
; edx: counter
; esi: temp value for median
find_medians:
	push rax
	push rbx
	push rdx
	push rsi
	
	; #blocks = length / N (rounded off)
	mov eax, edx
	mov edx, 0
	div edi
	
	mov edx, 0
	
	; find first median:
	; dest + 4 * (N-1)/2 = dest + 2N - 2
	mov ebx, edi
	shl ebx, 1
	sub ebx, 2
	add ebx, ecx
	
median_loop:
	cmp edx, eax
	; all blocks traversed
	je end_median_loop
	
	
	; write medians sequentially, beginning at dest
	mov esi, [ebx]
	mov [ecx + 4*edx], esi
	
	; move to next median (add 4*N)
	shl edi, 2
	add ebx, edi
	shr edi, 2
	inc edx
	jmp median_loop

end_median_loop:
	pop rsi
	pop rdx
	pop rbx
	pop rax
	ret


; handle error: block length is even or not positive
error_blockLength:
	push rdx
	push rcx
	push rbx
	push rax

	mov edx, 50
	mov ecx, msg_blockLength
	mov ebx, 1
	mov eax, 4
	int 0x80
	
	pop rax
	pop rbx
	pop rcx
	pop rdx
	ret	


; handle error: signal length is negative
error_signalLength:
	push rdx
	push rcx
	push rbx
	push rax
	
	mov edx, 45
	mov ecx, msg_signalLength
	mov ebx, 1
	mov eax, 4
	int 0x80
	
	pop rax
	pop rbx
	pop rcx
	pop rdx
	ret


