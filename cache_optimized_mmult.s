#CS2323 Lab Exam
.data
.dword 8,8,8,8,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
.text
lui x3,0x10000        #starting address for .data section
ld x10,0(x3)          #number of rows of A passed as first argument, say m
ld x11,8(x3)          #number of columns of A passed as second argument, say n
ld x12,16(x3)         #number of rows of B passed as third argument, should be equal to n
ld x13,24(x3)         #number of columns of B passed as fourth argument, say p
addi x14,x3,32        #base address of A passed as fifth argument
mul x9,x10,x11
slli x9,x9,3
add x15,x14,x9        #base address of B passed as sixth argument
lui x16,0x10004       #address to write values to, passed as seventh argument

beq x11,x12,No_Error     #return error if [(number of rows of B) != n]
sd x0,0(x16)
sd x0,8(x16)
beq x0,x0,Terminate
    
No_Error:
    jal x1,mmult
    
Terminate:
    beq x0,x0,Terminate

mmult:
    sd x10,0(x16)                   #number of rows of C = m
    sd x13,8(x16)                   #number of columns of C = p
    addi x17,x16,16                 #base address of C stored in x17
    add x5,x0,x0                    #row index for A, say i
    While1:
        beq x5,x10,Exit1            #exit loop if i == m
        add x7,x0,x0                #helper index for result calculation, say k
        
        While2:
            beq x7,x12,Exit2        #exit loop if k == n
            add x6,x0,x0            #column index for B, say j
            
            While3:
                beq x6,x13,Exit3    #exit loop if j == p
                mul x29,x5,x11
                add x29,x29,x7      
                slli x29,x29,3      
                add x29,x14,x29     #address of A[i][k]
                ld x30,0(x29)       #value of A[i][k]
                add x29,x30,x0      #storing it in x29 for better readability
                
                mul x30,x7,x13
                add x30,x30,x6
                slli x30,x30,3      
                add x30,x15,x30     #address of B[k][j]
                ld x31,0(x30)       #value of B[k][j]
                add x30,x31,x0      #storing it in x30 for better readability
                
                mul x31,x29,x30     #value of A[i][k]*B[k][j]
                
                mul x29,x5,x13
                add x29,x29,x6
                slli x29,x29,3
                add x29,x17,x29    #address of C[i][j]
                
                ld x28,0(x29)
                add x28,x28,x31
                sd x28,0(x29)      #store the sum at calculated address
                
                addi x6,x6,1
                beq x0,x0,While3
                
            Exit3:
                addi x7,x7,1
                beq x0,x0,While2
        
        Exit2:
            addi x5,x5,1
            beq x0,x0,While1
                
    Exit1:
        jalr x0,x1(0)