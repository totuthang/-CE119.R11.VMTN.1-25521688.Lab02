.data
    hist:  .word 6, 4, 0, 2                  # Mảng kết quả bộ T1 
    chuoi: .asciiz "([{([{([{([])}])}])}])"   # Chuỗi cá nhân P 

.text
.globl main
main:
    la   $a0, chuoi
    jal  check_brackets
    move $s0, $v0            # Lưu kết quả $v0 vào $s0
  
    la   $a0, hist           # $a0 = địa chỉ mảng hist
    li   $a1, 4              # $a1 = số nhóm (4)
    jal  draw_hist

    j    thoat_chuong_trinh

check_brackets:
    move $t9, $sp            # Lưu $sp ban đầu vào $t9
    move $t0, $a0            # $t0: con trỏ duyệt chuỗi
    li   $t1, 0              # $t1: vị trí ký tự (tính từ 1)

loop_kitu:
    lbu  $t2, 0($t0)         # Đọc ký tự hiện tại
    addi $t1, $t1, 1         # Tăng vị trí
    beq  $t2, $zero, het_chuoi

    # Kiểm tra ngoặc mở
    beq  $t2, '(', day_ngoac
    beq  $t2, '[', day_ngoac
    beq  $t2, '{', day_ngoac

    li   $t4, '('
    beq  $t2, ')', dong_ngoac
    li   $t4, '['
    beq  $t2, ']', dong_ngoac
    li   $t4, '{'
    beq  $t2, '}', dong_ngoac

    # Ký tự thường thì bỏ qua
    addi $t0, $t0, 1
    j    loop_kitu

day_ngoac:
    addi $sp, $sp, -4        # Push ngoặc mở lên ngăn xếp
    sw   $t2, 0($sp)
    addi $t0, $t0, 1
    j    loop_kitu

dong_ngoac:                
    beq  $sp, $t9, loi_rong  # Ngăn xếp rỗng mà gặp ngoặc đóng 
    lw   $t5, 0($sp)         # Pop ngoặc mở ở đỉnh ra $t5
    addi $sp, $sp, 4
    bne  $t5, $t4, loi_loai  # Khác loại ngoặc -
    addi $t0, $t0, 1
    j    loop_kitu

het_chuoi:
    bne  $sp, $t9, loi_du    # Hết chuỗi nhưng ngăn xếp chưa rỗng -
    li   $v0, 0              
    li   $v1, 0
    j    thoat

loi_loai:
    move $v0, $t1
    li   $v1, 1
    j    thoat

loi_rong:
    move $v0, $t1
    li   $v1, 2
    j    thoat

loi_du:
    move $v0, $t1            
    li   $v1, 3

thoat:
    move $sp, $t9            
    jr   $ra

draw_hist:
    move $t0, $a0            # Lưu địa chỉ mảng hist vào $t0
    move $t2, $a1            # $t2 = số nhóm (4)
    li   $t1, 0              # $t1 = chỉ số nhóm i 

loop_nhom:
    beq  $t1, $t2, ket_thuc  

    li   $v0, 11
    li   $a0, 'g'
    syscall

    li   $v0, 1
    move $a0, $t1
    syscall

    li   $v0, 11
    li   $a0, ':'
    syscall
    li   $a0, ' '
    syscall

    lw   $t3, 0($t0)         # $t3 = hist[i]

loop_cot:
    blez $t3, xuong_dong    
    li   $v0, 11
    li   $a0, '|'
    syscall
    addi $t3, $t3, -1
    j    loop_cot

xuong_dong:
    li   $v0, 11
    li   $a0, '\n'
    syscall

    addi $t0, $t0, 4         
    addi $t1, $t1, 1        
    j    loop_nhom

ket_thuc:
    jr   $ra

thoat_chuong_trinh:
    li   $v0, 10
    syscall