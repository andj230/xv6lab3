
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	4a813103          	ld	sp,1192(sp) # 8000a4a8 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdae07>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	dbc78793          	addi	a5,a5,-580 # 80000e3c <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800000a2:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	7119                	addi	sp,sp,-128
    800000d2:	fc86                	sd	ra,120(sp)
    800000d4:	f8a2                	sd	s0,112(sp)
    800000d6:	f4a6                	sd	s1,104(sp)
    800000d8:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800000da:	06c05a63          	blez	a2,8000014e <consolewrite+0x7e>
    800000de:	f0ca                	sd	s2,96(sp)
    800000e0:	ecce                	sd	s3,88(sp)
    800000e2:	e8d2                	sd	s4,80(sp)
    800000e4:	e4d6                	sd	s5,72(sp)
    800000e6:	e0da                	sd	s6,64(sp)
    800000e8:	fc5e                	sd	s7,56(sp)
    800000ea:	f862                	sd	s8,48(sp)
    800000ec:	f466                	sd	s9,40(sp)
    800000ee:	8aaa                	mv	s5,a0
    800000f0:	8b2e                	mv	s6,a1
    800000f2:	8a32                	mv	s4,a2
  int i = 0;
    800000f4:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800000f6:	02000c13          	li	s8,32
    800000fa:	02000c93          	li	s9,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800000fe:	5bfd                	li	s7,-1
    80000100:	a035                	j	8000012c <consolewrite+0x5c>
    if(nn > n - i)
    80000102:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80000106:	86ce                	mv	a3,s3
    80000108:	01648633          	add	a2,s1,s6
    8000010c:	85d6                	mv	a1,s5
    8000010e:	f8040513          	addi	a0,s0,-128
    80000112:	24c020ef          	jal	8000235e <either_copyin>
    80000116:	03750e63          	beq	a0,s7,80000152 <consolewrite+0x82>
      break;
    uartwrite(buf, nn);
    8000011a:	85ce                	mv	a1,s3
    8000011c:	f8040513          	addi	a0,s0,-128
    80000120:	778000ef          	jal	80000898 <uartwrite>
    i += nn;
    80000124:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80000128:	0144da63          	bge	s1,s4,8000013c <consolewrite+0x6c>
    if(nn > n - i)
    8000012c:	409a093b          	subw	s2,s4,s1
    80000130:	0009079b          	sext.w	a5,s2
    80000134:	fcfc57e3          	bge	s8,a5,80000102 <consolewrite+0x32>
    80000138:	8966                	mv	s2,s9
    8000013a:	b7e1                	j	80000102 <consolewrite+0x32>
    8000013c:	7906                	ld	s2,96(sp)
    8000013e:	69e6                	ld	s3,88(sp)
    80000140:	6a46                	ld	s4,80(sp)
    80000142:	6aa6                	ld	s5,72(sp)
    80000144:	6b06                	ld	s6,64(sp)
    80000146:	7be2                	ld	s7,56(sp)
    80000148:	7c42                	ld	s8,48(sp)
    8000014a:	7ca2                	ld	s9,40(sp)
    8000014c:	a819                	j	80000162 <consolewrite+0x92>
  int i = 0;
    8000014e:	4481                	li	s1,0
    80000150:	a809                	j	80000162 <consolewrite+0x92>
    80000152:	7906                	ld	s2,96(sp)
    80000154:	69e6                	ld	s3,88(sp)
    80000156:	6a46                	ld	s4,80(sp)
    80000158:	6aa6                	ld	s5,72(sp)
    8000015a:	6b06                	ld	s6,64(sp)
    8000015c:	7be2                	ld	s7,56(sp)
    8000015e:	7c42                	ld	s8,48(sp)
    80000160:	7ca2                	ld	s9,40(sp)
  }

  return i;
}
    80000162:	8526                	mv	a0,s1
    80000164:	70e6                	ld	ra,120(sp)
    80000166:	7446                	ld	s0,112(sp)
    80000168:	74a6                	ld	s1,104(sp)
    8000016a:	6109                	addi	sp,sp,128
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	addi	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	addi	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00012517          	auipc	a0,0x12
    80000190:	36450513          	addi	a0,a0,868 # 800124f0 <cons>
    80000194:	23b000ef          	jal	80000bce <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000198:	00012497          	auipc	s1,0x12
    8000019c:	35848493          	addi	s1,s1,856 # 800124f0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a0:	00012917          	auipc	s2,0x12
    800001a4:	3e890913          	addi	s2,s2,1000 # 80012588 <cons+0x98>
  while(n > 0){
    800001a8:	0b305d63          	blez	s3,80000262 <consoleread+0xf4>
    while(cons.r == cons.w){
    800001ac:	0984a783          	lw	a5,152(s1)
    800001b0:	09c4a703          	lw	a4,156(s1)
    800001b4:	0af71263          	bne	a4,a5,80000258 <consoleread+0xea>
      if(killed(myproc())){
    800001b8:	716010ef          	jal	800018ce <myproc>
    800001bc:	034020ef          	jal	800021f0 <killed>
    800001c0:	e12d                	bnez	a0,80000222 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    800001c2:	85a6                	mv	a1,s1
    800001c4:	854a                	mv	a0,s2
    800001c6:	5f3010ef          	jal	80001fb8 <sleep>
    while(cons.r == cons.w){
    800001ca:	0984a783          	lw	a5,152(s1)
    800001ce:	09c4a703          	lw	a4,156(s1)
    800001d2:	fef703e3          	beq	a4,a5,800001b8 <consoleread+0x4a>
    800001d6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001d8:	00012717          	auipc	a4,0x12
    800001dc:	31870713          	addi	a4,a4,792 # 800124f0 <cons>
    800001e0:	0017869b          	addiw	a3,a5,1
    800001e4:	08d72c23          	sw	a3,152(a4)
    800001e8:	07f7f693          	andi	a3,a5,127
    800001ec:	9736                	add	a4,a4,a3
    800001ee:	01874703          	lbu	a4,24(a4)
    800001f2:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001f6:	4691                	li	a3,4
    800001f8:	04db8663          	beq	s7,a3,80000244 <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001fc:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000200:	4685                	li	a3,1
    80000202:	faf40613          	addi	a2,s0,-81
    80000206:	85d2                	mv	a1,s4
    80000208:	8556                	mv	a0,s5
    8000020a:	10a020ef          	jal	80002314 <either_copyout>
    8000020e:	57fd                	li	a5,-1
    80000210:	04f50863          	beq	a0,a5,80000260 <consoleread+0xf2>
      break;

    dst++;
    80000214:	0a05                	addi	s4,s4,1
    --n;
    80000216:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80000218:	47a9                	li	a5,10
    8000021a:	04fb8d63          	beq	s7,a5,80000274 <consoleread+0x106>
    8000021e:	6be2                	ld	s7,24(sp)
    80000220:	b761                	j	800001a8 <consoleread+0x3a>
        release(&cons.lock);
    80000222:	00012517          	auipc	a0,0x12
    80000226:	2ce50513          	addi	a0,a0,718 # 800124f0 <cons>
    8000022a:	23d000ef          	jal	80000c66 <release>
        return -1;
    8000022e:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000230:	60e6                	ld	ra,88(sp)
    80000232:	6446                	ld	s0,80(sp)
    80000234:	64a6                	ld	s1,72(sp)
    80000236:	6906                	ld	s2,64(sp)
    80000238:	79e2                	ld	s3,56(sp)
    8000023a:	7a42                	ld	s4,48(sp)
    8000023c:	7aa2                	ld	s5,40(sp)
    8000023e:	7b02                	ld	s6,32(sp)
    80000240:	6125                	addi	sp,sp,96
    80000242:	8082                	ret
      if(n < target){
    80000244:	0009871b          	sext.w	a4,s3
    80000248:	01677a63          	bgeu	a4,s6,8000025c <consoleread+0xee>
        cons.r--;
    8000024c:	00012717          	auipc	a4,0x12
    80000250:	32f72e23          	sw	a5,828(a4) # 80012588 <cons+0x98>
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	a031                	j	80000262 <consoleread+0xf4>
    80000258:	ec5e                	sd	s7,24(sp)
    8000025a:	bfbd                	j	800001d8 <consoleread+0x6a>
    8000025c:	6be2                	ld	s7,24(sp)
    8000025e:	a011                	j	80000262 <consoleread+0xf4>
    80000260:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80000262:	00012517          	auipc	a0,0x12
    80000266:	28e50513          	addi	a0,a0,654 # 800124f0 <cons>
    8000026a:	1fd000ef          	jal	80000c66 <release>
  return target - n;
    8000026e:	413b053b          	subw	a0,s6,s3
    80000272:	bf7d                	j	80000230 <consoleread+0xc2>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	b7f5                	j	80000262 <consoleread+0xf4>

0000000080000278 <consputc>:
{
    80000278:	1141                	addi	sp,sp,-16
    8000027a:	e406                	sd	ra,8(sp)
    8000027c:	e022                	sd	s0,0(sp)
    8000027e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000280:	10000793          	li	a5,256
    80000284:	00f50863          	beq	a0,a5,80000294 <consputc+0x1c>
    uartputc_sync(c);
    80000288:	6a4000ef          	jal	8000092c <uartputc_sync>
}
    8000028c:	60a2                	ld	ra,8(sp)
    8000028e:	6402                	ld	s0,0(sp)
    80000290:	0141                	addi	sp,sp,16
    80000292:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80000294:	4521                	li	a0,8
    80000296:	696000ef          	jal	8000092c <uartputc_sync>
    8000029a:	02000513          	li	a0,32
    8000029e:	68e000ef          	jal	8000092c <uartputc_sync>
    800002a2:	4521                	li	a0,8
    800002a4:	688000ef          	jal	8000092c <uartputc_sync>
    800002a8:	b7d5                	j	8000028c <consputc+0x14>

00000000800002aa <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002aa:	1101                	addi	sp,sp,-32
    800002ac:	ec06                	sd	ra,24(sp)
    800002ae:	e822                	sd	s0,16(sp)
    800002b0:	e426                	sd	s1,8(sp)
    800002b2:	1000                	addi	s0,sp,32
    800002b4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002b6:	00012517          	auipc	a0,0x12
    800002ba:	23a50513          	addi	a0,a0,570 # 800124f0 <cons>
    800002be:	111000ef          	jal	80000bce <acquire>

  switch(c){
    800002c2:	47d5                	li	a5,21
    800002c4:	08f48f63          	beq	s1,a5,80000362 <consoleintr+0xb8>
    800002c8:	0297c563          	blt	a5,s1,800002f2 <consoleintr+0x48>
    800002cc:	47a1                	li	a5,8
    800002ce:	0ef48463          	beq	s1,a5,800003b6 <consoleintr+0x10c>
    800002d2:	47c1                	li	a5,16
    800002d4:	10f49563          	bne	s1,a5,800003de <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002d8:	0d0020ef          	jal	800023a8 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002dc:	00012517          	auipc	a0,0x12
    800002e0:	21450513          	addi	a0,a0,532 # 800124f0 <cons>
    800002e4:	183000ef          	jal	80000c66 <release>
}
    800002e8:	60e2                	ld	ra,24(sp)
    800002ea:	6442                	ld	s0,16(sp)
    800002ec:	64a2                	ld	s1,8(sp)
    800002ee:	6105                	addi	sp,sp,32
    800002f0:	8082                	ret
  switch(c){
    800002f2:	07f00793          	li	a5,127
    800002f6:	0cf48063          	beq	s1,a5,800003b6 <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002fa:	00012717          	auipc	a4,0x12
    800002fe:	1f670713          	addi	a4,a4,502 # 800124f0 <cons>
    80000302:	0a072783          	lw	a5,160(a4)
    80000306:	09872703          	lw	a4,152(a4)
    8000030a:	9f99                	subw	a5,a5,a4
    8000030c:	07f00713          	li	a4,127
    80000310:	fcf766e3          	bltu	a4,a5,800002dc <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000314:	47b5                	li	a5,13
    80000316:	0cf48763          	beq	s1,a5,800003e4 <consoleintr+0x13a>
      consputc(c);
    8000031a:	8526                	mv	a0,s1
    8000031c:	f5dff0ef          	jal	80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000320:	00012797          	auipc	a5,0x12
    80000324:	1d078793          	addi	a5,a5,464 # 800124f0 <cons>
    80000328:	0a07a683          	lw	a3,160(a5)
    8000032c:	0016871b          	addiw	a4,a3,1
    80000330:	0007061b          	sext.w	a2,a4
    80000334:	0ae7a023          	sw	a4,160(a5)
    80000338:	07f6f693          	andi	a3,a3,127
    8000033c:	97b6                	add	a5,a5,a3
    8000033e:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000342:	47a9                	li	a5,10
    80000344:	0cf48563          	beq	s1,a5,8000040e <consoleintr+0x164>
    80000348:	4791                	li	a5,4
    8000034a:	0cf48263          	beq	s1,a5,8000040e <consoleintr+0x164>
    8000034e:	00012797          	auipc	a5,0x12
    80000352:	23a7a783          	lw	a5,570(a5) # 80012588 <cons+0x98>
    80000356:	9f1d                	subw	a4,a4,a5
    80000358:	08000793          	li	a5,128
    8000035c:	f8f710e3          	bne	a4,a5,800002dc <consoleintr+0x32>
    80000360:	a07d                	j	8000040e <consoleintr+0x164>
    80000362:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000364:	00012717          	auipc	a4,0x12
    80000368:	18c70713          	addi	a4,a4,396 # 800124f0 <cons>
    8000036c:	0a072783          	lw	a5,160(a4)
    80000370:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000374:	00012497          	auipc	s1,0x12
    80000378:	17c48493          	addi	s1,s1,380 # 800124f0 <cons>
    while(cons.e != cons.w &&
    8000037c:	4929                	li	s2,10
    8000037e:	02f70863          	beq	a4,a5,800003ae <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000382:	37fd                	addiw	a5,a5,-1
    80000384:	07f7f713          	andi	a4,a5,127
    80000388:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000038a:	01874703          	lbu	a4,24(a4)
    8000038e:	03270263          	beq	a4,s2,800003b2 <consoleintr+0x108>
      cons.e--;
    80000392:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000396:	10000513          	li	a0,256
    8000039a:	edfff0ef          	jal	80000278 <consputc>
    while(cons.e != cons.w &&
    8000039e:	0a04a783          	lw	a5,160(s1)
    800003a2:	09c4a703          	lw	a4,156(s1)
    800003a6:	fcf71ee3          	bne	a4,a5,80000382 <consoleintr+0xd8>
    800003aa:	6902                	ld	s2,0(sp)
    800003ac:	bf05                	j	800002dc <consoleintr+0x32>
    800003ae:	6902                	ld	s2,0(sp)
    800003b0:	b735                	j	800002dc <consoleintr+0x32>
    800003b2:	6902                	ld	s2,0(sp)
    800003b4:	b725                	j	800002dc <consoleintr+0x32>
    if(cons.e != cons.w){
    800003b6:	00012717          	auipc	a4,0x12
    800003ba:	13a70713          	addi	a4,a4,314 # 800124f0 <cons>
    800003be:	0a072783          	lw	a5,160(a4)
    800003c2:	09c72703          	lw	a4,156(a4)
    800003c6:	f0f70be3          	beq	a4,a5,800002dc <consoleintr+0x32>
      cons.e--;
    800003ca:	37fd                	addiw	a5,a5,-1
    800003cc:	00012717          	auipc	a4,0x12
    800003d0:	1cf72223          	sw	a5,452(a4) # 80012590 <cons+0xa0>
      consputc(BACKSPACE);
    800003d4:	10000513          	li	a0,256
    800003d8:	ea1ff0ef          	jal	80000278 <consputc>
    800003dc:	b701                	j	800002dc <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003de:	ee048fe3          	beqz	s1,800002dc <consoleintr+0x32>
    800003e2:	bf21                	j	800002fa <consoleintr+0x50>
      consputc(c);
    800003e4:	4529                	li	a0,10
    800003e6:	e93ff0ef          	jal	80000278 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003ea:	00012797          	auipc	a5,0x12
    800003ee:	10678793          	addi	a5,a5,262 # 800124f0 <cons>
    800003f2:	0a07a703          	lw	a4,160(a5)
    800003f6:	0017069b          	addiw	a3,a4,1
    800003fa:	0006861b          	sext.w	a2,a3
    800003fe:	0ad7a023          	sw	a3,160(a5)
    80000402:	07f77713          	andi	a4,a4,127
    80000406:	97ba                	add	a5,a5,a4
    80000408:	4729                	li	a4,10
    8000040a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000040e:	00012797          	auipc	a5,0x12
    80000412:	16c7af23          	sw	a2,382(a5) # 8001258c <cons+0x9c>
        wakeup(&cons.r);
    80000416:	00012517          	auipc	a0,0x12
    8000041a:	17250513          	addi	a0,a0,370 # 80012588 <cons+0x98>
    8000041e:	3e7010ef          	jal	80002004 <wakeup>
    80000422:	bd6d                	j	800002dc <consoleintr+0x32>

0000000080000424 <consoleinit>:

void
consoleinit(void)
{
    80000424:	1141                	addi	sp,sp,-16
    80000426:	e406                	sd	ra,8(sp)
    80000428:	e022                	sd	s0,0(sp)
    8000042a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000042c:	00007597          	auipc	a1,0x7
    80000430:	bd458593          	addi	a1,a1,-1068 # 80007000 <etext>
    80000434:	00012517          	auipc	a0,0x12
    80000438:	0bc50513          	addi	a0,a0,188 # 800124f0 <cons>
    8000043c:	712000ef          	jal	80000b4e <initlock>

  uartinit();
    80000440:	400000ef          	jal	80000840 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000444:	00022797          	auipc	a5,0x22
    80000448:	41c78793          	addi	a5,a5,1052 # 80022860 <devsw>
    8000044c:	00000717          	auipc	a4,0x0
    80000450:	d2270713          	addi	a4,a4,-734 # 8000016e <consoleread>
    80000454:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000456:	00000717          	auipc	a4,0x0
    8000045a:	c7a70713          	addi	a4,a4,-902 # 800000d0 <consolewrite>
    8000045e:	ef98                	sd	a4,24(a5)
}
    80000460:	60a2                	ld	ra,8(sp)
    80000462:	6402                	ld	s0,0(sp)
    80000464:	0141                	addi	sp,sp,16
    80000466:	8082                	ret

0000000080000468 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000468:	7139                	addi	sp,sp,-64
    8000046a:	fc06                	sd	ra,56(sp)
    8000046c:	f822                	sd	s0,48(sp)
    8000046e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000470:	c219                	beqz	a2,80000476 <printint+0xe>
    80000472:	08054063          	bltz	a0,800004f2 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80000476:	4881                	li	a7,0
    80000478:	fc840693          	addi	a3,s0,-56

  i = 0;
    8000047c:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    8000047e:	00007617          	auipc	a2,0x7
    80000482:	3e260613          	addi	a2,a2,994 # 80007860 <digits>
    80000486:	883e                	mv	a6,a5
    80000488:	2785                	addiw	a5,a5,1
    8000048a:	02b57733          	remu	a4,a0,a1
    8000048e:	9732                	add	a4,a4,a2
    80000490:	00074703          	lbu	a4,0(a4)
    80000494:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000498:	872a                	mv	a4,a0
    8000049a:	02b55533          	divu	a0,a0,a1
    8000049e:	0685                	addi	a3,a3,1
    800004a0:	feb773e3          	bgeu	a4,a1,80000486 <printint+0x1e>

  if(sign)
    800004a4:	00088a63          	beqz	a7,800004b8 <printint+0x50>
    buf[i++] = '-';
    800004a8:	1781                	addi	a5,a5,-32
    800004aa:	97a2                	add	a5,a5,s0
    800004ac:	02d00713          	li	a4,45
    800004b0:	fee78423          	sb	a4,-24(a5)
    800004b4:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800004b8:	02f05963          	blez	a5,800004ea <printint+0x82>
    800004bc:	f426                	sd	s1,40(sp)
    800004be:	f04a                	sd	s2,32(sp)
    800004c0:	fc840713          	addi	a4,s0,-56
    800004c4:	00f704b3          	add	s1,a4,a5
    800004c8:	fff70913          	addi	s2,a4,-1
    800004cc:	993e                	add	s2,s2,a5
    800004ce:	37fd                	addiw	a5,a5,-1
    800004d0:	1782                	slli	a5,a5,0x20
    800004d2:	9381                	srli	a5,a5,0x20
    800004d4:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004d8:	fff4c503          	lbu	a0,-1(s1)
    800004dc:	d9dff0ef          	jal	80000278 <consputc>
  while(--i >= 0)
    800004e0:	14fd                	addi	s1,s1,-1
    800004e2:	ff249be3          	bne	s1,s2,800004d8 <printint+0x70>
    800004e6:	74a2                	ld	s1,40(sp)
    800004e8:	7902                	ld	s2,32(sp)
}
    800004ea:	70e2                	ld	ra,56(sp)
    800004ec:	7442                	ld	s0,48(sp)
    800004ee:	6121                	addi	sp,sp,64
    800004f0:	8082                	ret
    x = -xx;
    800004f2:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f6:	4885                	li	a7,1
    x = -xx;
    800004f8:	b741                	j	80000478 <printint+0x10>

00000000800004fa <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004fa:	7131                	addi	sp,sp,-192
    800004fc:	fc86                	sd	ra,120(sp)
    800004fe:	f8a2                	sd	s0,112(sp)
    80000500:	e8d2                	sd	s4,80(sp)
    80000502:	0100                	addi	s0,sp,128
    80000504:	8a2a                	mv	s4,a0
    80000506:	e40c                	sd	a1,8(s0)
    80000508:	e810                	sd	a2,16(s0)
    8000050a:	ec14                	sd	a3,24(s0)
    8000050c:	f018                	sd	a4,32(s0)
    8000050e:	f41c                	sd	a5,40(s0)
    80000510:	03043823          	sd	a6,48(s0)
    80000514:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    80000518:	0000a797          	auipc	a5,0xa
    8000051c:	fac7a783          	lw	a5,-84(a5) # 8000a4c4 <panicking>
    80000520:	c3a1                	beqz	a5,80000560 <printf+0x66>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000522:	00840793          	addi	a5,s0,8
    80000526:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000052a:	000a4503          	lbu	a0,0(s4)
    8000052e:	28050763          	beqz	a0,800007bc <printf+0x2c2>
    80000532:	f4a6                	sd	s1,104(sp)
    80000534:	f0ca                	sd	s2,96(sp)
    80000536:	ecce                	sd	s3,88(sp)
    80000538:	e4d6                	sd	s5,72(sp)
    8000053a:	e0da                	sd	s6,64(sp)
    8000053c:	f862                	sd	s8,48(sp)
    8000053e:	f466                	sd	s9,40(sp)
    80000540:	f06a                	sd	s10,32(sp)
    80000542:	ec6e                	sd	s11,24(sp)
    80000544:	4981                	li	s3,0
    if(cx != '%'){
    80000546:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000054a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000054e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000552:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000556:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000055a:	07000d93          	li	s11,112
    8000055e:	a01d                	j	80000584 <printf+0x8a>
    acquire(&pr.lock);
    80000560:	00012517          	auipc	a0,0x12
    80000564:	03850513          	addi	a0,a0,56 # 80012598 <pr>
    80000568:	666000ef          	jal	80000bce <acquire>
    8000056c:	bf5d                	j	80000522 <printf+0x28>
      consputc(cx);
    8000056e:	d0bff0ef          	jal	80000278 <consputc>
      continue;
    80000572:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000574:	0014899b          	addiw	s3,s1,1
    80000578:	013a07b3          	add	a5,s4,s3
    8000057c:	0007c503          	lbu	a0,0(a5)
    80000580:	20050b63          	beqz	a0,80000796 <printf+0x29c>
    if(cx != '%'){
    80000584:	ff5515e3          	bne	a0,s5,8000056e <printf+0x74>
    i++;
    80000588:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    8000058c:	009a07b3          	add	a5,s4,s1
    80000590:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    80000594:	20090b63          	beqz	s2,800007aa <printf+0x2b0>
    80000598:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    8000059c:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    8000059e:	c789                	beqz	a5,800005a8 <printf+0xae>
    800005a0:	009a0733          	add	a4,s4,s1
    800005a4:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800005a8:	03690963          	beq	s2,s6,800005da <printf+0xe0>
    } else if(c0 == 'l' && c1 == 'd'){
    800005ac:	05890363          	beq	s2,s8,800005f2 <printf+0xf8>
    } else if(c0 == 'u'){
    800005b0:	0d990663          	beq	s2,s9,8000067c <printf+0x182>
    } else if(c0 == 'x'){
    800005b4:	11a90d63          	beq	s2,s10,800006ce <printf+0x1d4>
    } else if(c0 == 'p'){
    800005b8:	15b90663          	beq	s2,s11,80000704 <printf+0x20a>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 'c'){
    800005bc:	06300793          	li	a5,99
    800005c0:	18f90563          	beq	s2,a5,8000074a <printf+0x250>
      consputc(va_arg(ap, uint));
    } else if(c0 == 's'){
    800005c4:	07300793          	li	a5,115
    800005c8:	18f90b63          	beq	s2,a5,8000075e <printf+0x264>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005cc:	03591b63          	bne	s2,s5,80000602 <printf+0x108>
      consputc('%');
    800005d0:	02500513          	li	a0,37
    800005d4:	ca5ff0ef          	jal	80000278 <consputc>
    800005d8:	bf71                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, int), 10, 1);
    800005da:	f8843783          	ld	a5,-120(s0)
    800005de:	00878713          	addi	a4,a5,8
    800005e2:	f8e43423          	sd	a4,-120(s0)
    800005e6:	4605                	li	a2,1
    800005e8:	45a9                	li	a1,10
    800005ea:	4388                	lw	a0,0(a5)
    800005ec:	e7dff0ef          	jal	80000468 <printint>
    800005f0:	b751                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'd'){
    800005f2:	01678f63          	beq	a5,s6,80000610 <printf+0x116>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005f6:	03878b63          	beq	a5,s8,8000062c <printf+0x132>
    } else if(c0 == 'l' && c1 == 'u'){
    800005fa:	09978e63          	beq	a5,s9,80000696 <printf+0x19c>
    } else if(c0 == 'l' && c1 == 'x'){
    800005fe:	0fa78563          	beq	a5,s10,800006e8 <printf+0x1ee>
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000602:	8556                	mv	a0,s5
    80000604:	c75ff0ef          	jal	80000278 <consputc>
      consputc(c0);
    80000608:	854a                	mv	a0,s2
    8000060a:	c6fff0ef          	jal	80000278 <consputc>
    8000060e:	b79d                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000610:	f8843783          	ld	a5,-120(s0)
    80000614:	00878713          	addi	a4,a5,8
    80000618:	f8e43423          	sd	a4,-120(s0)
    8000061c:	4605                	li	a2,1
    8000061e:	45a9                	li	a1,10
    80000620:	6388                	ld	a0,0(a5)
    80000622:	e47ff0ef          	jal	80000468 <printint>
      i += 1;
    80000626:	0029849b          	addiw	s1,s3,2
    8000062a:	b7a9                	j	80000574 <printf+0x7a>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000062c:	06400793          	li	a5,100
    80000630:	02f68863          	beq	a3,a5,80000660 <printf+0x166>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000634:	07500793          	li	a5,117
    80000638:	06f68d63          	beq	a3,a5,800006b2 <printf+0x1b8>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000063c:	07800793          	li	a5,120
    80000640:	fcf691e3          	bne	a3,a5,80000602 <printf+0x108>
      printint(va_arg(ap, uint64), 16, 0);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4601                	li	a2,0
    80000652:	45c1                	li	a1,16
    80000654:	6388                	ld	a0,0(a5)
    80000656:	e13ff0ef          	jal	80000468 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bf19                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 1);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4605                	li	a2,1
    8000066e:	45a9                	li	a1,10
    80000670:	6388                	ld	a0,0(a5)
    80000672:	df7ff0ef          	jal	80000468 <printint>
      i += 2;
    80000676:	0039849b          	addiw	s1,s3,3
    8000067a:	bded                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 10, 0);
    8000067c:	f8843783          	ld	a5,-120(s0)
    80000680:	00878713          	addi	a4,a5,8
    80000684:	f8e43423          	sd	a4,-120(s0)
    80000688:	4601                	li	a2,0
    8000068a:	45a9                	li	a1,10
    8000068c:	0007e503          	lwu	a0,0(a5)
    80000690:	dd9ff0ef          	jal	80000468 <printint>
    80000694:	b5c5                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    80000696:	f8843783          	ld	a5,-120(s0)
    8000069a:	00878713          	addi	a4,a5,8
    8000069e:	f8e43423          	sd	a4,-120(s0)
    800006a2:	4601                	li	a2,0
    800006a4:	45a9                	li	a1,10
    800006a6:	6388                	ld	a0,0(a5)
    800006a8:	dc1ff0ef          	jal	80000468 <printint>
      i += 1;
    800006ac:	0029849b          	addiw	s1,s3,2
    800006b0:	b5d1                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 10, 0);
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	4601                	li	a2,0
    800006c0:	45a9                	li	a1,10
    800006c2:	6388                	ld	a0,0(a5)
    800006c4:	da5ff0ef          	jal	80000468 <printint>
      i += 2;
    800006c8:	0039849b          	addiw	s1,s3,3
    800006cc:	b565                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint32), 16, 0);
    800006ce:	f8843783          	ld	a5,-120(s0)
    800006d2:	00878713          	addi	a4,a5,8
    800006d6:	f8e43423          	sd	a4,-120(s0)
    800006da:	4601                	li	a2,0
    800006dc:	45c1                	li	a1,16
    800006de:	0007e503          	lwu	a0,0(a5)
    800006e2:	d87ff0ef          	jal	80000468 <printint>
    800006e6:	b579                	j	80000574 <printf+0x7a>
      printint(va_arg(ap, uint64), 16, 0);
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	4601                	li	a2,0
    800006f6:	45c1                	li	a1,16
    800006f8:	6388                	ld	a0,0(a5)
    800006fa:	d6fff0ef          	jal	80000468 <printint>
      i += 1;
    800006fe:	0029849b          	addiw	s1,s3,2
    80000702:	bd8d                	j	80000574 <printf+0x7a>
    80000704:	fc5e                	sd	s7,56(sp)
      printptr(va_arg(ap, uint64));
    80000706:	f8843783          	ld	a5,-120(s0)
    8000070a:	00878713          	addi	a4,a5,8
    8000070e:	f8e43423          	sd	a4,-120(s0)
    80000712:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80000716:	03000513          	li	a0,48
    8000071a:	b5fff0ef          	jal	80000278 <consputc>
  consputc('x');
    8000071e:	07800513          	li	a0,120
    80000722:	b57ff0ef          	jal	80000278 <consputc>
    80000726:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000728:	00007b97          	auipc	s7,0x7
    8000072c:	138b8b93          	addi	s7,s7,312 # 80007860 <digits>
    80000730:	03c9d793          	srli	a5,s3,0x3c
    80000734:	97de                	add	a5,a5,s7
    80000736:	0007c503          	lbu	a0,0(a5)
    8000073a:	b3fff0ef          	jal	80000278 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000073e:	0992                	slli	s3,s3,0x4
    80000740:	397d                	addiw	s2,s2,-1
    80000742:	fe0917e3          	bnez	s2,80000730 <printf+0x236>
    80000746:	7be2                	ld	s7,56(sp)
    80000748:	b535                	j	80000574 <printf+0x7a>
      consputc(va_arg(ap, uint));
    8000074a:	f8843783          	ld	a5,-120(s0)
    8000074e:	00878713          	addi	a4,a5,8
    80000752:	f8e43423          	sd	a4,-120(s0)
    80000756:	4388                	lw	a0,0(a5)
    80000758:	b21ff0ef          	jal	80000278 <consputc>
    8000075c:	bd21                	j	80000574 <printf+0x7a>
      if((s = va_arg(ap, char*)) == 0)
    8000075e:	f8843783          	ld	a5,-120(s0)
    80000762:	00878713          	addi	a4,a5,8
    80000766:	f8e43423          	sd	a4,-120(s0)
    8000076a:	0007b903          	ld	s2,0(a5)
    8000076e:	00090d63          	beqz	s2,80000788 <printf+0x28e>
      for(; *s; s++)
    80000772:	00094503          	lbu	a0,0(s2)
    80000776:	de050fe3          	beqz	a0,80000574 <printf+0x7a>
        consputc(*s);
    8000077a:	affff0ef          	jal	80000278 <consputc>
      for(; *s; s++)
    8000077e:	0905                	addi	s2,s2,1
    80000780:	00094503          	lbu	a0,0(s2)
    80000784:	f97d                	bnez	a0,8000077a <printf+0x280>
    80000786:	b3fd                	j	80000574 <printf+0x7a>
        s = "(null)";
    80000788:	00007917          	auipc	s2,0x7
    8000078c:	88090913          	addi	s2,s2,-1920 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000790:	02800513          	li	a0,40
    80000794:	b7dd                	j	8000077a <printf+0x280>
    80000796:	74a6                	ld	s1,104(sp)
    80000798:	7906                	ld	s2,96(sp)
    8000079a:	69e6                	ld	s3,88(sp)
    8000079c:	6aa6                	ld	s5,72(sp)
    8000079e:	6b06                	ld	s6,64(sp)
    800007a0:	7c42                	ld	s8,48(sp)
    800007a2:	7ca2                	ld	s9,40(sp)
    800007a4:	7d02                	ld	s10,32(sp)
    800007a6:	6de2                	ld	s11,24(sp)
    800007a8:	a811                	j	800007bc <printf+0x2c2>
    800007aa:	74a6                	ld	s1,104(sp)
    800007ac:	7906                	ld	s2,96(sp)
    800007ae:	69e6                	ld	s3,88(sp)
    800007b0:	6aa6                	ld	s5,72(sp)
    800007b2:	6b06                	ld	s6,64(sp)
    800007b4:	7c42                	ld	s8,48(sp)
    800007b6:	7ca2                	ld	s9,40(sp)
    800007b8:	7d02                	ld	s10,32(sp)
    800007ba:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800007bc:	0000a797          	auipc	a5,0xa
    800007c0:	d087a783          	lw	a5,-760(a5) # 8000a4c4 <panicking>
    800007c4:	c799                	beqz	a5,800007d2 <printf+0x2d8>
    release(&pr.lock);

  return 0;
}
    800007c6:	4501                	li	a0,0
    800007c8:	70e6                	ld	ra,120(sp)
    800007ca:	7446                	ld	s0,112(sp)
    800007cc:	6a46                	ld	s4,80(sp)
    800007ce:	6129                	addi	sp,sp,192
    800007d0:	8082                	ret
    release(&pr.lock);
    800007d2:	00012517          	auipc	a0,0x12
    800007d6:	dc650513          	addi	a0,a0,-570 # 80012598 <pr>
    800007da:	48c000ef          	jal	80000c66 <release>
  return 0;
    800007de:	b7e5                	j	800007c6 <printf+0x2cc>

00000000800007e0 <panic>:

void
panic(char *s)
{
    800007e0:	1101                	addi	sp,sp,-32
    800007e2:	ec06                	sd	ra,24(sp)
    800007e4:	e822                	sd	s0,16(sp)
    800007e6:	e426                	sd	s1,8(sp)
    800007e8:	e04a                	sd	s2,0(sp)
    800007ea:	1000                	addi	s0,sp,32
    800007ec:	84aa                	mv	s1,a0
  panicking = 1;
    800007ee:	4905                	li	s2,1
    800007f0:	0000a797          	auipc	a5,0xa
    800007f4:	cd27aa23          	sw	s2,-812(a5) # 8000a4c4 <panicking>
  printf("panic: ");
    800007f8:	00007517          	auipc	a0,0x7
    800007fc:	82050513          	addi	a0,a0,-2016 # 80007018 <etext+0x18>
    80000800:	cfbff0ef          	jal	800004fa <printf>
  printf("%s\n", s);
    80000804:	85a6                	mv	a1,s1
    80000806:	00007517          	auipc	a0,0x7
    8000080a:	81a50513          	addi	a0,a0,-2022 # 80007020 <etext+0x20>
    8000080e:	cedff0ef          	jal	800004fa <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000812:	0000a797          	auipc	a5,0xa
    80000816:	cb27a723          	sw	s2,-850(a5) # 8000a4c0 <panicked>
  for(;;)
    8000081a:	a001                	j	8000081a <panic+0x3a>

000000008000081c <printfinit>:
    ;
}

void
printfinit(void)
{
    8000081c:	1141                	addi	sp,sp,-16
    8000081e:	e406                	sd	ra,8(sp)
    80000820:	e022                	sd	s0,0(sp)
    80000822:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000824:	00007597          	auipc	a1,0x7
    80000828:	80458593          	addi	a1,a1,-2044 # 80007028 <etext+0x28>
    8000082c:	00012517          	auipc	a0,0x12
    80000830:	d6c50513          	addi	a0,a0,-660 # 80012598 <pr>
    80000834:	31a000ef          	jal	80000b4e <initlock>
}
    80000838:	60a2                	ld	ra,8(sp)
    8000083a:	6402                	ld	s0,0(sp)
    8000083c:	0141                	addi	sp,sp,16
    8000083e:	8082                	ret

0000000080000840 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80000840:	1141                	addi	sp,sp,-16
    80000842:	e406                	sd	ra,8(sp)
    80000844:	e022                	sd	s0,0(sp)
    80000846:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000848:	100007b7          	lui	a5,0x10000
    8000084c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000850:	10000737          	lui	a4,0x10000
    80000854:	f8000693          	li	a3,-128
    80000858:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000085c:	468d                	li	a3,3
    8000085e:	10000637          	lui	a2,0x10000
    80000862:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000866:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000086a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	461d                	li	a2,7
    80000874:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000878:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    8000087c:	00006597          	auipc	a1,0x6
    80000880:	7b458593          	addi	a1,a1,1972 # 80007030 <etext+0x30>
    80000884:	00012517          	auipc	a0,0x12
    80000888:	d2c50513          	addi	a0,a0,-724 # 800125b0 <tx_lock>
    8000088c:	2c2000ef          	jal	80000b4e <initlock>
}
    80000890:	60a2                	ld	ra,8(sp)
    80000892:	6402                	ld	s0,0(sp)
    80000894:	0141                	addi	sp,sp,16
    80000896:	8082                	ret

0000000080000898 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80000898:	715d                	addi	sp,sp,-80
    8000089a:	e486                	sd	ra,72(sp)
    8000089c:	e0a2                	sd	s0,64(sp)
    8000089e:	fc26                	sd	s1,56(sp)
    800008a0:	ec56                	sd	s5,24(sp)
    800008a2:	0880                	addi	s0,sp,80
    800008a4:	8aaa                	mv	s5,a0
    800008a6:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800008a8:	00012517          	auipc	a0,0x12
    800008ac:	d0850513          	addi	a0,a0,-760 # 800125b0 <tx_lock>
    800008b0:	31e000ef          	jal	80000bce <acquire>

  int i = 0;
  while(i < n){ 
    800008b4:	06905063          	blez	s1,80000914 <uartwrite+0x7c>
    800008b8:	f84a                	sd	s2,48(sp)
    800008ba:	f44e                	sd	s3,40(sp)
    800008bc:	f052                	sd	s4,32(sp)
    800008be:	e85a                	sd	s6,16(sp)
    800008c0:	e45e                	sd	s7,8(sp)
    800008c2:	8a56                	mv	s4,s5
    800008c4:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800008c6:	0000a497          	auipc	s1,0xa
    800008ca:	c0648493          	addi	s1,s1,-1018 # 8000a4cc <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800008ce:	00012997          	auipc	s3,0x12
    800008d2:	ce298993          	addi	s3,s3,-798 # 800125b0 <tx_lock>
    800008d6:	0000a917          	auipc	s2,0xa
    800008da:	bf290913          	addi	s2,s2,-1038 # 8000a4c8 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800008de:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800008e2:	4b05                	li	s6,1
    800008e4:	a005                	j	80000904 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800008e6:	85ce                	mv	a1,s3
    800008e8:	854a                	mv	a0,s2
    800008ea:	6ce010ef          	jal	80001fb8 <sleep>
    while(tx_busy != 0){
    800008ee:	409c                	lw	a5,0(s1)
    800008f0:	fbfd                	bnez	a5,800008e6 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800008f2:	000a4783          	lbu	a5,0(s4)
    800008f6:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800008fa:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800008fe:	0a05                	addi	s4,s4,1
    80000900:	015a0563          	beq	s4,s5,8000090a <uartwrite+0x72>
    while(tx_busy != 0){
    80000904:	409c                	lw	a5,0(s1)
    80000906:	f3e5                	bnez	a5,800008e6 <uartwrite+0x4e>
    80000908:	b7ed                	j	800008f2 <uartwrite+0x5a>
    8000090a:	7942                	ld	s2,48(sp)
    8000090c:	79a2                	ld	s3,40(sp)
    8000090e:	7a02                	ld	s4,32(sp)
    80000910:	6b42                	ld	s6,16(sp)
    80000912:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80000914:	00012517          	auipc	a0,0x12
    80000918:	c9c50513          	addi	a0,a0,-868 # 800125b0 <tx_lock>
    8000091c:	34a000ef          	jal	80000c66 <release>
}
    80000920:	60a6                	ld	ra,72(sp)
    80000922:	6406                	ld	s0,64(sp)
    80000924:	74e2                	ld	s1,56(sp)
    80000926:	6ae2                	ld	s5,24(sp)
    80000928:	6161                	addi	sp,sp,80
    8000092a:	8082                	ret

000000008000092c <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000092c:	1101                	addi	sp,sp,-32
    8000092e:	ec06                	sd	ra,24(sp)
    80000930:	e822                	sd	s0,16(sp)
    80000932:	e426                	sd	s1,8(sp)
    80000934:	1000                	addi	s0,sp,32
    80000936:	84aa                	mv	s1,a0
  if(panicking == 0)
    80000938:	0000a797          	auipc	a5,0xa
    8000093c:	b8c7a783          	lw	a5,-1140(a5) # 8000a4c4 <panicking>
    80000940:	cf95                	beqz	a5,8000097c <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80000942:	0000a797          	auipc	a5,0xa
    80000946:	b7e7a783          	lw	a5,-1154(a5) # 8000a4c0 <panicked>
    8000094a:	ef85                	bnez	a5,80000982 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000094c:	10000737          	lui	a4,0x10000
    80000950:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000952:	00074783          	lbu	a5,0(a4)
    80000956:	0207f793          	andi	a5,a5,32
    8000095a:	dfe5                	beqz	a5,80000952 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    8000095c:	0ff4f513          	zext.b	a0,s1
    80000960:	100007b7          	lui	a5,0x10000
    80000964:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80000968:	0000a797          	auipc	a5,0xa
    8000096c:	b5c7a783          	lw	a5,-1188(a5) # 8000a4c4 <panicking>
    80000970:	cb91                	beqz	a5,80000984 <uartputc_sync+0x58>
    pop_off();
}
    80000972:	60e2                	ld	ra,24(sp)
    80000974:	6442                	ld	s0,16(sp)
    80000976:	64a2                	ld	s1,8(sp)
    80000978:	6105                	addi	sp,sp,32
    8000097a:	8082                	ret
    push_off();
    8000097c:	212000ef          	jal	80000b8e <push_off>
    80000980:	b7c9                	j	80000942 <uartputc_sync+0x16>
    for(;;)
    80000982:	a001                	j	80000982 <uartputc_sync+0x56>
    pop_off();
    80000984:	28e000ef          	jal	80000c12 <pop_off>
}
    80000988:	b7ed                	j	80000972 <uartputc_sync+0x46>

000000008000098a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000098a:	1141                	addi	sp,sp,-16
    8000098c:	e422                	sd	s0,8(sp)
    8000098e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80000990:	100007b7          	lui	a5,0x10000
    80000994:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000996:	0007c783          	lbu	a5,0(a5)
    8000099a:	8b85                	andi	a5,a5,1
    8000099c:	cb81                	beqz	a5,800009ac <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    8000099e:	100007b7          	lui	a5,0x10000
    800009a2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009a6:	6422                	ld	s0,8(sp)
    800009a8:	0141                	addi	sp,sp,16
    800009aa:	8082                	ret
    return -1;
    800009ac:	557d                	li	a0,-1
    800009ae:	bfe5                	j	800009a6 <uartgetc+0x1c>

00000000800009b0 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009b0:	1101                	addi	sp,sp,-32
    800009b2:	ec06                	sd	ra,24(sp)
    800009b4:	e822                	sd	s0,16(sp)
    800009b6:	e426                	sd	s1,8(sp)
    800009b8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ba:	100007b7          	lui	a5,0x10000
    800009be:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    800009c0:	0007c783          	lbu	a5,0(a5)

  acquire(&tx_lock);
    800009c4:	00012517          	auipc	a0,0x12
    800009c8:	bec50513          	addi	a0,a0,-1044 # 800125b0 <tx_lock>
    800009cc:	202000ef          	jal	80000bce <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800009d0:	100007b7          	lui	a5,0x10000
    800009d4:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009d6:	0007c783          	lbu	a5,0(a5)
    800009da:	0207f793          	andi	a5,a5,32
    800009de:	eb89                	bnez	a5,800009f0 <uartintr+0x40>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800009e0:	00012517          	auipc	a0,0x12
    800009e4:	bd050513          	addi	a0,a0,-1072 # 800125b0 <tx_lock>
    800009e8:	27e000ef          	jal	80000c66 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009ec:	54fd                	li	s1,-1
    800009ee:	a831                	j	80000a0a <uartintr+0x5a>
    tx_busy = 0;
    800009f0:	0000a797          	auipc	a5,0xa
    800009f4:	ac07ae23          	sw	zero,-1316(a5) # 8000a4cc <tx_busy>
    wakeup(&tx_chan);
    800009f8:	0000a517          	auipc	a0,0xa
    800009fc:	ad050513          	addi	a0,a0,-1328 # 8000a4c8 <tx_chan>
    80000a00:	604010ef          	jal	80002004 <wakeup>
    80000a04:	bff1                	j	800009e0 <uartintr+0x30>
      break;
    consoleintr(c);
    80000a06:	8a5ff0ef          	jal	800002aa <consoleintr>
    int c = uartgetc();
    80000a0a:	f81ff0ef          	jal	8000098a <uartgetc>
    if(c == -1)
    80000a0e:	fe951ce3          	bne	a0,s1,80000a06 <uartintr+0x56>
  }
}
    80000a12:	60e2                	ld	ra,24(sp)
    80000a14:	6442                	ld	s0,16(sp)
    80000a16:	64a2                	ld	s1,8(sp)
    80000a18:	6105                	addi	sp,sp,32
    80000a1a:	8082                	ret

0000000080000a1c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a1c:	1101                	addi	sp,sp,-32
    80000a1e:	ec06                	sd	ra,24(sp)
    80000a20:	e822                	sd	s0,16(sp)
    80000a22:	e426                	sd	s1,8(sp)
    80000a24:	e04a                	sd	s2,0(sp)
    80000a26:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a28:	03451793          	slli	a5,a0,0x34
    80000a2c:	e7a9                	bnez	a5,80000a76 <kfree+0x5a>
    80000a2e:	84aa                	mv	s1,a0
    80000a30:	00023797          	auipc	a5,0x23
    80000a34:	fc878793          	addi	a5,a5,-56 # 800239f8 <end>
    80000a38:	02f56f63          	bltu	a0,a5,80000a76 <kfree+0x5a>
    80000a3c:	47c5                	li	a5,17
    80000a3e:	07ee                	slli	a5,a5,0x1b
    80000a40:	02f57b63          	bgeu	a0,a5,80000a76 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a44:	6605                	lui	a2,0x1
    80000a46:	4585                	li	a1,1
    80000a48:	25a000ef          	jal	80000ca2 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a4c:	00012917          	auipc	s2,0x12
    80000a50:	b7c90913          	addi	s2,s2,-1156 # 800125c8 <kmem>
    80000a54:	854a                	mv	a0,s2
    80000a56:	178000ef          	jal	80000bce <acquire>
  r->next = kmem.freelist;
    80000a5a:	01893783          	ld	a5,24(s2)
    80000a5e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a60:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a64:	854a                	mv	a0,s2
    80000a66:	200000ef          	jal	80000c66 <release>
}
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6902                	ld	s2,0(sp)
    80000a72:	6105                	addi	sp,sp,32
    80000a74:	8082                	ret
    panic("kfree");
    80000a76:	00006517          	auipc	a0,0x6
    80000a7a:	5c250513          	addi	a0,a0,1474 # 80007038 <etext+0x38>
    80000a7e:	d63ff0ef          	jal	800007e0 <panic>

0000000080000a82 <freerange>:
{
    80000a82:	7179                	addi	sp,sp,-48
    80000a84:	f406                	sd	ra,40(sp)
    80000a86:	f022                	sd	s0,32(sp)
    80000a88:	ec26                	sd	s1,24(sp)
    80000a8a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000a8c:	6785                	lui	a5,0x1
    80000a8e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000a92:	00e504b3          	add	s1,a0,a4
    80000a96:	777d                	lui	a4,0xfffff
    80000a98:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000a9a:	94be                	add	s1,s1,a5
    80000a9c:	0295e263          	bltu	a1,s1,80000ac0 <freerange+0x3e>
    80000aa0:	e84a                	sd	s2,16(sp)
    80000aa2:	e44e                	sd	s3,8(sp)
    80000aa4:	e052                	sd	s4,0(sp)
    80000aa6:	892e                	mv	s2,a1
    kfree(p);
    80000aa8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000aaa:	6985                	lui	s3,0x1
    kfree(p);
    80000aac:	01448533          	add	a0,s1,s4
    80000ab0:	f6dff0ef          	jal	80000a1c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab4:	94ce                	add	s1,s1,s3
    80000ab6:	fe997be3          	bgeu	s2,s1,80000aac <freerange+0x2a>
    80000aba:	6942                	ld	s2,16(sp)
    80000abc:	69a2                	ld	s3,8(sp)
    80000abe:	6a02                	ld	s4,0(sp)
}
    80000ac0:	70a2                	ld	ra,40(sp)
    80000ac2:	7402                	ld	s0,32(sp)
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6145                	addi	sp,sp,48
    80000ac8:	8082                	ret

0000000080000aca <kinit>:
{
    80000aca:	1141                	addi	sp,sp,-16
    80000acc:	e406                	sd	ra,8(sp)
    80000ace:	e022                	sd	s0,0(sp)
    80000ad0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000ad2:	00006597          	auipc	a1,0x6
    80000ad6:	56e58593          	addi	a1,a1,1390 # 80007040 <etext+0x40>
    80000ada:	00012517          	auipc	a0,0x12
    80000ade:	aee50513          	addi	a0,a0,-1298 # 800125c8 <kmem>
    80000ae2:	06c000ef          	jal	80000b4e <initlock>
  freerange(end, (void*)PHYSTOP);
    80000ae6:	45c5                	li	a1,17
    80000ae8:	05ee                	slli	a1,a1,0x1b
    80000aea:	00023517          	auipc	a0,0x23
    80000aee:	f0e50513          	addi	a0,a0,-242 # 800239f8 <end>
    80000af2:	f91ff0ef          	jal	80000a82 <freerange>
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret

0000000080000afe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000afe:	1101                	addi	sp,sp,-32
    80000b00:	ec06                	sd	ra,24(sp)
    80000b02:	e822                	sd	s0,16(sp)
    80000b04:	e426                	sd	s1,8(sp)
    80000b06:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b08:	00012497          	auipc	s1,0x12
    80000b0c:	ac048493          	addi	s1,s1,-1344 # 800125c8 <kmem>
    80000b10:	8526                	mv	a0,s1
    80000b12:	0bc000ef          	jal	80000bce <acquire>
  r = kmem.freelist;
    80000b16:	6c84                	ld	s1,24(s1)
  if(r)
    80000b18:	c485                	beqz	s1,80000b40 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b1a:	609c                	ld	a5,0(s1)
    80000b1c:	00012517          	auipc	a0,0x12
    80000b20:	aac50513          	addi	a0,a0,-1364 # 800125c8 <kmem>
    80000b24:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b26:	140000ef          	jal	80000c66 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b2a:	6605                	lui	a2,0x1
    80000b2c:	4595                	li	a1,5
    80000b2e:	8526                	mv	a0,s1
    80000b30:	172000ef          	jal	80000ca2 <memset>
  return (void*)r;
}
    80000b34:	8526                	mv	a0,s1
    80000b36:	60e2                	ld	ra,24(sp)
    80000b38:	6442                	ld	s0,16(sp)
    80000b3a:	64a2                	ld	s1,8(sp)
    80000b3c:	6105                	addi	sp,sp,32
    80000b3e:	8082                	ret
  release(&kmem.lock);
    80000b40:	00012517          	auipc	a0,0x12
    80000b44:	a8850513          	addi	a0,a0,-1400 # 800125c8 <kmem>
    80000b48:	11e000ef          	jal	80000c66 <release>
  if(r)
    80000b4c:	b7e5                	j	80000b34 <kalloc+0x36>

0000000080000b4e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b4e:	1141                	addi	sp,sp,-16
    80000b50:	e422                	sd	s0,8(sp)
    80000b52:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b54:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b56:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b5a:	00053823          	sd	zero,16(a0)
}
    80000b5e:	6422                	ld	s0,8(sp)
    80000b60:	0141                	addi	sp,sp,16
    80000b62:	8082                	ret

0000000080000b64 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b64:	411c                	lw	a5,0(a0)
    80000b66:	e399                	bnez	a5,80000b6c <holding+0x8>
    80000b68:	4501                	li	a0,0
  return r;
}
    80000b6a:	8082                	ret
{
    80000b6c:	1101                	addi	sp,sp,-32
    80000b6e:	ec06                	sd	ra,24(sp)
    80000b70:	e822                	sd	s0,16(sp)
    80000b72:	e426                	sd	s1,8(sp)
    80000b74:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b76:	6904                	ld	s1,16(a0)
    80000b78:	53b000ef          	jal	800018b2 <mycpu>
    80000b7c:	40a48533          	sub	a0,s1,a0
    80000b80:	00153513          	seqz	a0,a0
}
    80000b84:	60e2                	ld	ra,24(sp)
    80000b86:	6442                	ld	s0,16(sp)
    80000b88:	64a2                	ld	s1,8(sp)
    80000b8a:	6105                	addi	sp,sp,32
    80000b8c:	8082                	ret

0000000080000b8e <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000b8e:	1101                	addi	sp,sp,-32
    80000b90:	ec06                	sd	ra,24(sp)
    80000b92:	e822                	sd	s0,16(sp)
    80000b94:	e426                	sd	s1,8(sp)
    80000b96:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b98:	100024f3          	csrr	s1,sstatus
    80000b9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000ba0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ba2:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80000ba6:	50d000ef          	jal	800018b2 <mycpu>
    80000baa:	5d3c                	lw	a5,120(a0)
    80000bac:	cb99                	beqz	a5,80000bc2 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bae:	505000ef          	jal	800018b2 <mycpu>
    80000bb2:	5d3c                	lw	a5,120(a0)
    80000bb4:	2785                	addiw	a5,a5,1
    80000bb6:	dd3c                	sw	a5,120(a0)
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret
    mycpu()->intena = old;
    80000bc2:	4f1000ef          	jal	800018b2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bc6:	8085                	srli	s1,s1,0x1
    80000bc8:	8885                	andi	s1,s1,1
    80000bca:	dd64                	sw	s1,124(a0)
    80000bcc:	b7cd                	j	80000bae <push_off+0x20>

0000000080000bce <acquire>:
{
    80000bce:	1101                	addi	sp,sp,-32
    80000bd0:	ec06                	sd	ra,24(sp)
    80000bd2:	e822                	sd	s0,16(sp)
    80000bd4:	e426                	sd	s1,8(sp)
    80000bd6:	1000                	addi	s0,sp,32
    80000bd8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000bda:	fb5ff0ef          	jal	80000b8e <push_off>
  if(holding(lk))
    80000bde:	8526                	mv	a0,s1
    80000be0:	f85ff0ef          	jal	80000b64 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be4:	4705                	li	a4,1
  if(holding(lk))
    80000be6:	e105                	bnez	a0,80000c06 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000be8:	87ba                	mv	a5,a4
    80000bea:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000bee:	2781                	sext.w	a5,a5
    80000bf0:	ffe5                	bnez	a5,80000be8 <acquire+0x1a>
  __sync_synchronize();
    80000bf2:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000bf6:	4bd000ef          	jal	800018b2 <mycpu>
    80000bfa:	e888                	sd	a0,16(s1)
}
    80000bfc:	60e2                	ld	ra,24(sp)
    80000bfe:	6442                	ld	s0,16(sp)
    80000c00:	64a2                	ld	s1,8(sp)
    80000c02:	6105                	addi	sp,sp,32
    80000c04:	8082                	ret
    panic("acquire");
    80000c06:	00006517          	auipc	a0,0x6
    80000c0a:	44250513          	addi	a0,a0,1090 # 80007048 <etext+0x48>
    80000c0e:	bd3ff0ef          	jal	800007e0 <panic>

0000000080000c12 <pop_off>:

void
pop_off(void)
{
    80000c12:	1141                	addi	sp,sp,-16
    80000c14:	e406                	sd	ra,8(sp)
    80000c16:	e022                	sd	s0,0(sp)
    80000c18:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c1a:	499000ef          	jal	800018b2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c1e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c22:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c24:	e78d                	bnez	a5,80000c4e <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c26:	5d3c                	lw	a5,120(a0)
    80000c28:	02f05963          	blez	a5,80000c5a <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c2c:	37fd                	addiw	a5,a5,-1
    80000c2e:	0007871b          	sext.w	a4,a5
    80000c32:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c34:	eb09                	bnez	a4,80000c46 <pop_off+0x34>
    80000c36:	5d7c                	lw	a5,124(a0)
    80000c38:	c799                	beqz	a5,80000c46 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c3a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c3e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c42:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c46:	60a2                	ld	ra,8(sp)
    80000c48:	6402                	ld	s0,0(sp)
    80000c4a:	0141                	addi	sp,sp,16
    80000c4c:	8082                	ret
    panic("pop_off - interruptible");
    80000c4e:	00006517          	auipc	a0,0x6
    80000c52:	40250513          	addi	a0,a0,1026 # 80007050 <etext+0x50>
    80000c56:	b8bff0ef          	jal	800007e0 <panic>
    panic("pop_off");
    80000c5a:	00006517          	auipc	a0,0x6
    80000c5e:	40e50513          	addi	a0,a0,1038 # 80007068 <etext+0x68>
    80000c62:	b7fff0ef          	jal	800007e0 <panic>

0000000080000c66 <release>:
{
    80000c66:	1101                	addi	sp,sp,-32
    80000c68:	ec06                	sd	ra,24(sp)
    80000c6a:	e822                	sd	s0,16(sp)
    80000c6c:	e426                	sd	s1,8(sp)
    80000c6e:	1000                	addi	s0,sp,32
    80000c70:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c72:	ef3ff0ef          	jal	80000b64 <holding>
    80000c76:	c105                	beqz	a0,80000c96 <release+0x30>
  lk->cpu = 0;
    80000c78:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000c7c:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000c80:	0310000f          	fence	rw,w
    80000c84:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c88:	f8bff0ef          	jal	80000c12 <pop_off>
}
    80000c8c:	60e2                	ld	ra,24(sp)
    80000c8e:	6442                	ld	s0,16(sp)
    80000c90:	64a2                	ld	s1,8(sp)
    80000c92:	6105                	addi	sp,sp,32
    80000c94:	8082                	ret
    panic("release");
    80000c96:	00006517          	auipc	a0,0x6
    80000c9a:	3da50513          	addi	a0,a0,986 # 80007070 <etext+0x70>
    80000c9e:	b43ff0ef          	jal	800007e0 <panic>

0000000080000ca2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000ca2:	1141                	addi	sp,sp,-16
    80000ca4:	e422                	sd	s0,8(sp)
    80000ca6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000ca8:	ca19                	beqz	a2,80000cbe <memset+0x1c>
    80000caa:	87aa                	mv	a5,a0
    80000cac:	1602                	slli	a2,a2,0x20
    80000cae:	9201                	srli	a2,a2,0x20
    80000cb0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cb4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cb8:	0785                	addi	a5,a5,1
    80000cba:	fee79de3          	bne	a5,a4,80000cb4 <memset+0x12>
  }
  return dst;
}
    80000cbe:	6422                	ld	s0,8(sp)
    80000cc0:	0141                	addi	sp,sp,16
    80000cc2:	8082                	ret

0000000080000cc4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cc4:	1141                	addi	sp,sp,-16
    80000cc6:	e422                	sd	s0,8(sp)
    80000cc8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cca:	ca05                	beqz	a2,80000cfa <memcmp+0x36>
    80000ccc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cd0:	1682                	slli	a3,a3,0x20
    80000cd2:	9281                	srli	a3,a3,0x20
    80000cd4:	0685                	addi	a3,a3,1
    80000cd6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cd8:	00054783          	lbu	a5,0(a0)
    80000cdc:	0005c703          	lbu	a4,0(a1)
    80000ce0:	00e79863          	bne	a5,a4,80000cf0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000ce4:	0505                	addi	a0,a0,1
    80000ce6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000ce8:	fed518e3          	bne	a0,a3,80000cd8 <memcmp+0x14>
  }

  return 0;
    80000cec:	4501                	li	a0,0
    80000cee:	a019                	j	80000cf4 <memcmp+0x30>
      return *s1 - *s2;
    80000cf0:	40e7853b          	subw	a0,a5,a4
}
    80000cf4:	6422                	ld	s0,8(sp)
    80000cf6:	0141                	addi	sp,sp,16
    80000cf8:	8082                	ret
  return 0;
    80000cfa:	4501                	li	a0,0
    80000cfc:	bfe5                	j	80000cf4 <memcmp+0x30>

0000000080000cfe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000cfe:	1141                	addi	sp,sp,-16
    80000d00:	e422                	sd	s0,8(sp)
    80000d02:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d04:	c205                	beqz	a2,80000d24 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d06:	02a5e263          	bltu	a1,a0,80000d2a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d0a:	1602                	slli	a2,a2,0x20
    80000d0c:	9201                	srli	a2,a2,0x20
    80000d0e:	00c587b3          	add	a5,a1,a2
{
    80000d12:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d14:	0585                	addi	a1,a1,1
    80000d16:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdb609>
    80000d18:	fff5c683          	lbu	a3,-1(a1)
    80000d1c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d20:	feb79ae3          	bne	a5,a1,80000d14 <memmove+0x16>

  return dst;
}
    80000d24:	6422                	ld	s0,8(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
  if(s < d && s + n > d){
    80000d2a:	02061693          	slli	a3,a2,0x20
    80000d2e:	9281                	srli	a3,a3,0x20
    80000d30:	00d58733          	add	a4,a1,a3
    80000d34:	fce57be3          	bgeu	a0,a4,80000d0a <memmove+0xc>
    d += n;
    80000d38:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d3a:	fff6079b          	addiw	a5,a2,-1
    80000d3e:	1782                	slli	a5,a5,0x20
    80000d40:	9381                	srli	a5,a5,0x20
    80000d42:	fff7c793          	not	a5,a5
    80000d46:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d48:	177d                	addi	a4,a4,-1
    80000d4a:	16fd                	addi	a3,a3,-1
    80000d4c:	00074603          	lbu	a2,0(a4)
    80000d50:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d54:	fef71ae3          	bne	a4,a5,80000d48 <memmove+0x4a>
    80000d58:	b7f1                	j	80000d24 <memmove+0x26>

0000000080000d5a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d5a:	1141                	addi	sp,sp,-16
    80000d5c:	e406                	sd	ra,8(sp)
    80000d5e:	e022                	sd	s0,0(sp)
    80000d60:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d62:	f9dff0ef          	jal	80000cfe <memmove>
}
    80000d66:	60a2                	ld	ra,8(sp)
    80000d68:	6402                	ld	s0,0(sp)
    80000d6a:	0141                	addi	sp,sp,16
    80000d6c:	8082                	ret

0000000080000d6e <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d6e:	1141                	addi	sp,sp,-16
    80000d70:	e422                	sd	s0,8(sp)
    80000d72:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d74:	ce11                	beqz	a2,80000d90 <strncmp+0x22>
    80000d76:	00054783          	lbu	a5,0(a0)
    80000d7a:	cf89                	beqz	a5,80000d94 <strncmp+0x26>
    80000d7c:	0005c703          	lbu	a4,0(a1)
    80000d80:	00f71a63          	bne	a4,a5,80000d94 <strncmp+0x26>
    n--, p++, q++;
    80000d84:	367d                	addiw	a2,a2,-1
    80000d86:	0505                	addi	a0,a0,1
    80000d88:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000d8a:	f675                	bnez	a2,80000d76 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000d8c:	4501                	li	a0,0
    80000d8e:	a801                	j	80000d9e <strncmp+0x30>
    80000d90:	4501                	li	a0,0
    80000d92:	a031                	j	80000d9e <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000d94:	00054503          	lbu	a0,0(a0)
    80000d98:	0005c783          	lbu	a5,0(a1)
    80000d9c:	9d1d                	subw	a0,a0,a5
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000daa:	87aa                	mv	a5,a0
    80000dac:	86b2                	mv	a3,a2
    80000dae:	367d                	addiw	a2,a2,-1
    80000db0:	02d05563          	blez	a3,80000dda <strncpy+0x36>
    80000db4:	0785                	addi	a5,a5,1
    80000db6:	0005c703          	lbu	a4,0(a1)
    80000dba:	fee78fa3          	sb	a4,-1(a5)
    80000dbe:	0585                	addi	a1,a1,1
    80000dc0:	f775                	bnez	a4,80000dac <strncpy+0x8>
    ;
  while(n-- > 0)
    80000dc2:	873e                	mv	a4,a5
    80000dc4:	9fb5                	addw	a5,a5,a3
    80000dc6:	37fd                	addiw	a5,a5,-1
    80000dc8:	00c05963          	blez	a2,80000dda <strncpy+0x36>
    *s++ = 0;
    80000dcc:	0705                	addi	a4,a4,1
    80000dce:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000dd2:	40e786bb          	subw	a3,a5,a4
    80000dd6:	fed04be3          	bgtz	a3,80000dcc <strncpy+0x28>
  return os;
}
    80000dda:	6422                	ld	s0,8(sp)
    80000ddc:	0141                	addi	sp,sp,16
    80000dde:	8082                	ret

0000000080000de0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000de0:	1141                	addi	sp,sp,-16
    80000de2:	e422                	sd	s0,8(sp)
    80000de4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000de6:	02c05363          	blez	a2,80000e0c <safestrcpy+0x2c>
    80000dea:	fff6069b          	addiw	a3,a2,-1
    80000dee:	1682                	slli	a3,a3,0x20
    80000df0:	9281                	srli	a3,a3,0x20
    80000df2:	96ae                	add	a3,a3,a1
    80000df4:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000df6:	00d58963          	beq	a1,a3,80000e08 <safestrcpy+0x28>
    80000dfa:	0585                	addi	a1,a1,1
    80000dfc:	0785                	addi	a5,a5,1
    80000dfe:	fff5c703          	lbu	a4,-1(a1)
    80000e02:	fee78fa3          	sb	a4,-1(a5)
    80000e06:	fb65                	bnez	a4,80000df6 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e08:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e0c:	6422                	ld	s0,8(sp)
    80000e0e:	0141                	addi	sp,sp,16
    80000e10:	8082                	ret

0000000080000e12 <strlen>:

int
strlen(const char *s)
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e18:	00054783          	lbu	a5,0(a0)
    80000e1c:	cf91                	beqz	a5,80000e38 <strlen+0x26>
    80000e1e:	0505                	addi	a0,a0,1
    80000e20:	87aa                	mv	a5,a0
    80000e22:	86be                	mv	a3,a5
    80000e24:	0785                	addi	a5,a5,1
    80000e26:	fff7c703          	lbu	a4,-1(a5)
    80000e2a:	ff65                	bnez	a4,80000e22 <strlen+0x10>
    80000e2c:	40a6853b          	subw	a0,a3,a0
    80000e30:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e38:	4501                	li	a0,0
    80000e3a:	bfe5                	j	80000e32 <strlen+0x20>

0000000080000e3c <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e406                	sd	ra,8(sp)
    80000e40:	e022                	sd	s0,0(sp)
    80000e42:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e44:	25f000ef          	jal	800018a2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e48:	00009717          	auipc	a4,0x9
    80000e4c:	68870713          	addi	a4,a4,1672 # 8000a4d0 <started>
  if(cpuid() == 0){
    80000e50:	c51d                	beqz	a0,80000e7e <main+0x42>
    while(started == 0)
    80000e52:	431c                	lw	a5,0(a4)
    80000e54:	2781                	sext.w	a5,a5
    80000e56:	dff5                	beqz	a5,80000e52 <main+0x16>
      ;
    __sync_synchronize();
    80000e58:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e5c:	247000ef          	jal	800018a2 <cpuid>
    80000e60:	85aa                	mv	a1,a0
    80000e62:	00006517          	auipc	a0,0x6
    80000e66:	22e50513          	addi	a0,a0,558 # 80007090 <etext+0x90>
    80000e6a:	e90ff0ef          	jal	800004fa <printf>
    kvminithart();    // turn on paging
    80000e6e:	080000ef          	jal	80000eee <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e72:	668010ef          	jal	800024da <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e76:	702040ef          	jal	80005578 <plicinithart>
  }

  scheduler();        
    80000e7a:	7a7000ef          	jal	80001e20 <scheduler>
    consoleinit();
    80000e7e:	da6ff0ef          	jal	80000424 <consoleinit>
    printfinit();
    80000e82:	99bff0ef          	jal	8000081c <printfinit>
    printf("\n");
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	37a50513          	addi	a0,a0,890 # 80007200 <etext+0x200>
    80000e8e:	e6cff0ef          	jal	800004fa <printf>
    printf("xv6 kernel is booting\n");
    80000e92:	00006517          	auipc	a0,0x6
    80000e96:	1e650513          	addi	a0,a0,486 # 80007078 <etext+0x78>
    80000e9a:	e60ff0ef          	jal	800004fa <printf>
    printf("\n");
    80000e9e:	00006517          	auipc	a0,0x6
    80000ea2:	36250513          	addi	a0,a0,866 # 80007200 <etext+0x200>
    80000ea6:	e54ff0ef          	jal	800004fa <printf>
    kinit();         // physical page allocator
    80000eaa:	c21ff0ef          	jal	80000aca <kinit>
    kvminit();       // create kernel page table
    80000eae:	2ca000ef          	jal	80001178 <kvminit>
    kvminithart();   // turn on paging
    80000eb2:	03c000ef          	jal	80000eee <kvminithart>
    procinit();      // process table
    80000eb6:	137000ef          	jal	800017ec <procinit>
    trapinit();      // trap vectors
    80000eba:	5fc010ef          	jal	800024b6 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ebe:	61c010ef          	jal	800024da <trapinithart>
    plicinit();      // set up interrupt controller
    80000ec2:	69c040ef          	jal	8000555e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000ec6:	6b2040ef          	jal	80005578 <plicinithart>
    binit();         // buffer cache
    80000eca:	583010ef          	jal	80002c4c <binit>
    iinit();         // inode table
    80000ece:	308020ef          	jal	800031d6 <iinit>
    fileinit();      // file table
    80000ed2:	1fa030ef          	jal	800040cc <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000ed6:	792040ef          	jal	80005668 <virtio_disk_init>
    userinit();      // first user process
    80000eda:	59f000ef          	jal	80001c78 <userinit>
    __sync_synchronize();
    80000ede:	0330000f          	fence	rw,rw
    started = 1;
    80000ee2:	4785                	li	a5,1
    80000ee4:	00009717          	auipc	a4,0x9
    80000ee8:	5ef72623          	sw	a5,1516(a4) # 8000a4d0 <started>
    80000eec:	b779                	j	80000e7a <main+0x3e>

0000000080000eee <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000eee:	1141                	addi	sp,sp,-16
    80000ef0:	e422                	sd	s0,8(sp)
    80000ef2:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000ef4:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000ef8:	00009797          	auipc	a5,0x9
    80000efc:	5e07b783          	ld	a5,1504(a5) # 8000a4d8 <kernel_pagetable>
    80000f00:	83b1                	srli	a5,a5,0xc
    80000f02:	577d                	li	a4,-1
    80000f04:	177e                	slli	a4,a4,0x3f
    80000f06:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f08:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f0c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f10:	6422                	ld	s0,8(sp)
    80000f12:	0141                	addi	sp,sp,16
    80000f14:	8082                	ret

0000000080000f16 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f16:	7139                	addi	sp,sp,-64
    80000f18:	fc06                	sd	ra,56(sp)
    80000f1a:	f822                	sd	s0,48(sp)
    80000f1c:	f426                	sd	s1,40(sp)
    80000f1e:	f04a                	sd	s2,32(sp)
    80000f20:	ec4e                	sd	s3,24(sp)
    80000f22:	e852                	sd	s4,16(sp)
    80000f24:	e456                	sd	s5,8(sp)
    80000f26:	e05a                	sd	s6,0(sp)
    80000f28:	0080                	addi	s0,sp,64
    80000f2a:	84aa                	mv	s1,a0
    80000f2c:	89ae                	mv	s3,a1
    80000f2e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f30:	57fd                	li	a5,-1
    80000f32:	83e9                	srli	a5,a5,0x1a
    80000f34:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f36:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f38:	02b7fc63          	bgeu	a5,a1,80000f70 <walk+0x5a>
    panic("walk");
    80000f3c:	00006517          	auipc	a0,0x6
    80000f40:	16c50513          	addi	a0,a0,364 # 800070a8 <etext+0xa8>
    80000f44:	89dff0ef          	jal	800007e0 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f48:	060a8263          	beqz	s5,80000fac <walk+0x96>
    80000f4c:	bb3ff0ef          	jal	80000afe <kalloc>
    80000f50:	84aa                	mv	s1,a0
    80000f52:	c139                	beqz	a0,80000f98 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f54:	6605                	lui	a2,0x1
    80000f56:	4581                	li	a1,0
    80000f58:	d4bff0ef          	jal	80000ca2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f5c:	00c4d793          	srli	a5,s1,0xc
    80000f60:	07aa                	slli	a5,a5,0xa
    80000f62:	0017e793          	ori	a5,a5,1
    80000f66:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f6a:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdb5ff>
    80000f6c:	036a0063          	beq	s4,s6,80000f8c <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f70:	0149d933          	srl	s2,s3,s4
    80000f74:	1ff97913          	andi	s2,s2,511
    80000f78:	090e                	slli	s2,s2,0x3
    80000f7a:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000f7c:	00093483          	ld	s1,0(s2)
    80000f80:	0014f793          	andi	a5,s1,1
    80000f84:	d3f1                	beqz	a5,80000f48 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f86:	80a9                	srli	s1,s1,0xa
    80000f88:	04b2                	slli	s1,s1,0xc
    80000f8a:	b7c5                	j	80000f6a <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000f8c:	00c9d513          	srli	a0,s3,0xc
    80000f90:	1ff57513          	andi	a0,a0,511
    80000f94:	050e                	slli	a0,a0,0x3
    80000f96:	9526                	add	a0,a0,s1
}
    80000f98:	70e2                	ld	ra,56(sp)
    80000f9a:	7442                	ld	s0,48(sp)
    80000f9c:	74a2                	ld	s1,40(sp)
    80000f9e:	7902                	ld	s2,32(sp)
    80000fa0:	69e2                	ld	s3,24(sp)
    80000fa2:	6a42                	ld	s4,16(sp)
    80000fa4:	6aa2                	ld	s5,8(sp)
    80000fa6:	6b02                	ld	s6,0(sp)
    80000fa8:	6121                	addi	sp,sp,64
    80000faa:	8082                	ret
        return 0;
    80000fac:	4501                	li	a0,0
    80000fae:	b7ed                	j	80000f98 <walk+0x82>

0000000080000fb0 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fb0:	57fd                	li	a5,-1
    80000fb2:	83e9                	srli	a5,a5,0x1a
    80000fb4:	00b7f463          	bgeu	a5,a1,80000fbc <walkaddr+0xc>
    return 0;
    80000fb8:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fba:	8082                	ret
{
    80000fbc:	1141                	addi	sp,sp,-16
    80000fbe:	e406                	sd	ra,8(sp)
    80000fc0:	e022                	sd	s0,0(sp)
    80000fc2:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fc4:	4601                	li	a2,0
    80000fc6:	f51ff0ef          	jal	80000f16 <walk>
  if(pte == 0)
    80000fca:	c105                	beqz	a0,80000fea <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000fcc:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000fce:	0117f693          	andi	a3,a5,17
    80000fd2:	4745                	li	a4,17
    return 0;
    80000fd4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000fd6:	00e68663          	beq	a3,a4,80000fe2 <walkaddr+0x32>
}
    80000fda:	60a2                	ld	ra,8(sp)
    80000fdc:	6402                	ld	s0,0(sp)
    80000fde:	0141                	addi	sp,sp,16
    80000fe0:	8082                	ret
  pa = PTE2PA(*pte);
    80000fe2:	83a9                	srli	a5,a5,0xa
    80000fe4:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000fe8:	bfcd                	j	80000fda <walkaddr+0x2a>
    return 0;
    80000fea:	4501                	li	a0,0
    80000fec:	b7fd                	j	80000fda <walkaddr+0x2a>

0000000080000fee <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000fee:	715d                	addi	sp,sp,-80
    80000ff0:	e486                	sd	ra,72(sp)
    80000ff2:	e0a2                	sd	s0,64(sp)
    80000ff4:	fc26                	sd	s1,56(sp)
    80000ff6:	f84a                	sd	s2,48(sp)
    80000ff8:	f44e                	sd	s3,40(sp)
    80000ffa:	f052                	sd	s4,32(sp)
    80000ffc:	ec56                	sd	s5,24(sp)
    80000ffe:	e85a                	sd	s6,16(sp)
    80001000:	e45e                	sd	s7,8(sp)
    80001002:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001004:	03459793          	slli	a5,a1,0x34
    80001008:	e7a9                	bnez	a5,80001052 <mappages+0x64>
    8000100a:	8aaa                	mv	s5,a0
    8000100c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000100e:	03461793          	slli	a5,a2,0x34
    80001012:	e7b1                	bnez	a5,8000105e <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001014:	ca39                	beqz	a2,8000106a <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001016:	77fd                	lui	a5,0xfffff
    80001018:	963e                	add	a2,a2,a5
    8000101a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000101e:	892e                	mv	s2,a1
    80001020:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001024:	6b85                	lui	s7,0x1
    80001026:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000102a:	4605                	li	a2,1
    8000102c:	85ca                	mv	a1,s2
    8000102e:	8556                	mv	a0,s5
    80001030:	ee7ff0ef          	jal	80000f16 <walk>
    80001034:	c539                	beqz	a0,80001082 <mappages+0x94>
    if(*pte & PTE_V)
    80001036:	611c                	ld	a5,0(a0)
    80001038:	8b85                	andi	a5,a5,1
    8000103a:	ef95                	bnez	a5,80001076 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000103c:	80b1                	srli	s1,s1,0xc
    8000103e:	04aa                	slli	s1,s1,0xa
    80001040:	0164e4b3          	or	s1,s1,s6
    80001044:	0014e493          	ori	s1,s1,1
    80001048:	e104                	sd	s1,0(a0)
    if(a == last)
    8000104a:	05390863          	beq	s2,s3,8000109a <mappages+0xac>
    a += PGSIZE;
    8000104e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001050:	bfd9                	j	80001026 <mappages+0x38>
    panic("mappages: va not aligned");
    80001052:	00006517          	auipc	a0,0x6
    80001056:	05e50513          	addi	a0,a0,94 # 800070b0 <etext+0xb0>
    8000105a:	f86ff0ef          	jal	800007e0 <panic>
    panic("mappages: size not aligned");
    8000105e:	00006517          	auipc	a0,0x6
    80001062:	07250513          	addi	a0,a0,114 # 800070d0 <etext+0xd0>
    80001066:	f7aff0ef          	jal	800007e0 <panic>
    panic("mappages: size");
    8000106a:	00006517          	auipc	a0,0x6
    8000106e:	08650513          	addi	a0,a0,134 # 800070f0 <etext+0xf0>
    80001072:	f6eff0ef          	jal	800007e0 <panic>
      panic("mappages: remap");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	08a50513          	addi	a0,a0,138 # 80007100 <etext+0x100>
    8000107e:	f62ff0ef          	jal	800007e0 <panic>
      return -1;
    80001082:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001084:	60a6                	ld	ra,72(sp)
    80001086:	6406                	ld	s0,64(sp)
    80001088:	74e2                	ld	s1,56(sp)
    8000108a:	7942                	ld	s2,48(sp)
    8000108c:	79a2                	ld	s3,40(sp)
    8000108e:	7a02                	ld	s4,32(sp)
    80001090:	6ae2                	ld	s5,24(sp)
    80001092:	6b42                	ld	s6,16(sp)
    80001094:	6ba2                	ld	s7,8(sp)
    80001096:	6161                	addi	sp,sp,80
    80001098:	8082                	ret
  return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7e5                	j	80001084 <mappages+0x96>

000000008000109e <kvmmap>:
{
    8000109e:	1141                	addi	sp,sp,-16
    800010a0:	e406                	sd	ra,8(sp)
    800010a2:	e022                	sd	s0,0(sp)
    800010a4:	0800                	addi	s0,sp,16
    800010a6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010a8:	86b2                	mv	a3,a2
    800010aa:	863e                	mv	a2,a5
    800010ac:	f43ff0ef          	jal	80000fee <mappages>
    800010b0:	e509                	bnez	a0,800010ba <kvmmap+0x1c>
}
    800010b2:	60a2                	ld	ra,8(sp)
    800010b4:	6402                	ld	s0,0(sp)
    800010b6:	0141                	addi	sp,sp,16
    800010b8:	8082                	ret
    panic("kvmmap");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	05650513          	addi	a0,a0,86 # 80007110 <etext+0x110>
    800010c2:	f1eff0ef          	jal	800007e0 <panic>

00000000800010c6 <kvmmake>:
{
    800010c6:	1101                	addi	sp,sp,-32
    800010c8:	ec06                	sd	ra,24(sp)
    800010ca:	e822                	sd	s0,16(sp)
    800010cc:	e426                	sd	s1,8(sp)
    800010ce:	e04a                	sd	s2,0(sp)
    800010d0:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800010d2:	a2dff0ef          	jal	80000afe <kalloc>
    800010d6:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010d8:	6605                	lui	a2,0x1
    800010da:	4581                	li	a1,0
    800010dc:	bc7ff0ef          	jal	80000ca2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800010e0:	4719                	li	a4,6
    800010e2:	6685                	lui	a3,0x1
    800010e4:	10000637          	lui	a2,0x10000
    800010e8:	100005b7          	lui	a1,0x10000
    800010ec:	8526                	mv	a0,s1
    800010ee:	fb1ff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800010f2:	4719                	li	a4,6
    800010f4:	6685                	lui	a3,0x1
    800010f6:	10001637          	lui	a2,0x10001
    800010fa:	100015b7          	lui	a1,0x10001
    800010fe:	8526                	mv	a0,s1
    80001100:	f9fff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	040006b7          	lui	a3,0x4000
    8000110a:	0c000637          	lui	a2,0xc000
    8000110e:	0c0005b7          	lui	a1,0xc000
    80001112:	8526                	mv	a0,s1
    80001114:	f8bff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001118:	00006917          	auipc	s2,0x6
    8000111c:	ee890913          	addi	s2,s2,-280 # 80007000 <etext>
    80001120:	4729                	li	a4,10
    80001122:	80006697          	auipc	a3,0x80006
    80001126:	ede68693          	addi	a3,a3,-290 # 7000 <_entry-0x7fff9000>
    8000112a:	4605                	li	a2,1
    8000112c:	067e                	slli	a2,a2,0x1f
    8000112e:	85b2                	mv	a1,a2
    80001130:	8526                	mv	a0,s1
    80001132:	f6dff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001136:	46c5                	li	a3,17
    80001138:	06ee                	slli	a3,a3,0x1b
    8000113a:	4719                	li	a4,6
    8000113c:	412686b3          	sub	a3,a3,s2
    80001140:	864a                	mv	a2,s2
    80001142:	85ca                	mv	a1,s2
    80001144:	8526                	mv	a0,s1
    80001146:	f59ff0ef          	jal	8000109e <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000114a:	4729                	li	a4,10
    8000114c:	6685                	lui	a3,0x1
    8000114e:	00005617          	auipc	a2,0x5
    80001152:	eb260613          	addi	a2,a2,-334 # 80006000 <_trampoline>
    80001156:	040005b7          	lui	a1,0x4000
    8000115a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000115c:	05b2                	slli	a1,a1,0xc
    8000115e:	8526                	mv	a0,s1
    80001160:	f3fff0ef          	jal	8000109e <kvmmap>
  proc_mapstacks(kpgtbl);
    80001164:	8526                	mv	a0,s1
    80001166:	5ee000ef          	jal	80001754 <proc_mapstacks>
}
    8000116a:	8526                	mv	a0,s1
    8000116c:	60e2                	ld	ra,24(sp)
    8000116e:	6442                	ld	s0,16(sp)
    80001170:	64a2                	ld	s1,8(sp)
    80001172:	6902                	ld	s2,0(sp)
    80001174:	6105                	addi	sp,sp,32
    80001176:	8082                	ret

0000000080001178 <kvminit>:
{
    80001178:	1141                	addi	sp,sp,-16
    8000117a:	e406                	sd	ra,8(sp)
    8000117c:	e022                	sd	s0,0(sp)
    8000117e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80001180:	f47ff0ef          	jal	800010c6 <kvmmake>
    80001184:	00009797          	auipc	a5,0x9
    80001188:	34a7ba23          	sd	a0,852(a5) # 8000a4d8 <kernel_pagetable>
}
    8000118c:	60a2                	ld	ra,8(sp)
    8000118e:	6402                	ld	s0,0(sp)
    80001190:	0141                	addi	sp,sp,16
    80001192:	8082                	ret

0000000080001194 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001194:	1101                	addi	sp,sp,-32
    80001196:	ec06                	sd	ra,24(sp)
    80001198:	e822                	sd	s0,16(sp)
    8000119a:	e426                	sd	s1,8(sp)
    8000119c:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    8000119e:	961ff0ef          	jal	80000afe <kalloc>
    800011a2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800011a4:	c509                	beqz	a0,800011ae <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011a6:	6605                	lui	a2,0x1
    800011a8:	4581                	li	a1,0
    800011aa:	af9ff0ef          	jal	80000ca2 <memset>
  return pagetable;
}
    800011ae:	8526                	mv	a0,s1
    800011b0:	60e2                	ld	ra,24(sp)
    800011b2:	6442                	ld	s0,16(sp)
    800011b4:	64a2                	ld	s1,8(sp)
    800011b6:	6105                	addi	sp,sp,32
    800011b8:	8082                	ret

00000000800011ba <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ba:	7139                	addi	sp,sp,-64
    800011bc:	fc06                	sd	ra,56(sp)
    800011be:	f822                	sd	s0,48(sp)
    800011c0:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011c2:	03459793          	slli	a5,a1,0x34
    800011c6:	e38d                	bnez	a5,800011e8 <uvmunmap+0x2e>
    800011c8:	f04a                	sd	s2,32(sp)
    800011ca:	ec4e                	sd	s3,24(sp)
    800011cc:	e852                	sd	s4,16(sp)
    800011ce:	e456                	sd	s5,8(sp)
    800011d0:	e05a                	sd	s6,0(sp)
    800011d2:	8a2a                	mv	s4,a0
    800011d4:	892e                	mv	s2,a1
    800011d6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011d8:	0632                	slli	a2,a2,0xc
    800011da:	00b609b3          	add	s3,a2,a1
    800011de:	6b05                	lui	s6,0x1
    800011e0:	0535f963          	bgeu	a1,s3,80001232 <uvmunmap+0x78>
    800011e4:	f426                	sd	s1,40(sp)
    800011e6:	a015                	j	8000120a <uvmunmap+0x50>
    800011e8:	f426                	sd	s1,40(sp)
    800011ea:	f04a                	sd	s2,32(sp)
    800011ec:	ec4e                	sd	s3,24(sp)
    800011ee:	e852                	sd	s4,16(sp)
    800011f0:	e456                	sd	s5,8(sp)
    800011f2:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800011f4:	00006517          	auipc	a0,0x6
    800011f8:	f2450513          	addi	a0,a0,-220 # 80007118 <etext+0x118>
    800011fc:	de4ff0ef          	jal	800007e0 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001200:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001204:	995a                	add	s2,s2,s6
    80001206:	03397563          	bgeu	s2,s3,80001230 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000120a:	4601                	li	a2,0
    8000120c:	85ca                	mv	a1,s2
    8000120e:	8552                	mv	a0,s4
    80001210:	d07ff0ef          	jal	80000f16 <walk>
    80001214:	84aa                	mv	s1,a0
    80001216:	d57d                	beqz	a0,80001204 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80001218:	611c                	ld	a5,0(a0)
    8000121a:	0017f713          	andi	a4,a5,1
    8000121e:	d37d                	beqz	a4,80001204 <uvmunmap+0x4a>
    if(do_free){
    80001220:	fe0a80e3          	beqz	s5,80001200 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001224:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80001226:	00c79513          	slli	a0,a5,0xc
    8000122a:	ff2ff0ef          	jal	80000a1c <kfree>
    8000122e:	bfc9                	j	80001200 <uvmunmap+0x46>
    80001230:	74a2                	ld	s1,40(sp)
    80001232:	7902                	ld	s2,32(sp)
    80001234:	69e2                	ld	s3,24(sp)
    80001236:	6a42                	ld	s4,16(sp)
    80001238:	6aa2                	ld	s5,8(sp)
    8000123a:	6b02                	ld	s6,0(sp)
  }
}
    8000123c:	70e2                	ld	ra,56(sp)
    8000123e:	7442                	ld	s0,48(sp)
    80001240:	6121                	addi	sp,sp,64
    80001242:	8082                	ret

0000000080001244 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001244:	1101                	addi	sp,sp,-32
    80001246:	ec06                	sd	ra,24(sp)
    80001248:	e822                	sd	s0,16(sp)
    8000124a:	e426                	sd	s1,8(sp)
    8000124c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000124e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001250:	00b67d63          	bgeu	a2,a1,8000126a <uvmdealloc+0x26>
    80001254:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001256:	6785                	lui	a5,0x1
    80001258:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000125a:	00f60733          	add	a4,a2,a5
    8000125e:	76fd                	lui	a3,0xfffff
    80001260:	8f75                	and	a4,a4,a3
    80001262:	97ae                	add	a5,a5,a1
    80001264:	8ff5                	and	a5,a5,a3
    80001266:	00f76863          	bltu	a4,a5,80001276 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000126a:	8526                	mv	a0,s1
    8000126c:	60e2                	ld	ra,24(sp)
    8000126e:	6442                	ld	s0,16(sp)
    80001270:	64a2                	ld	s1,8(sp)
    80001272:	6105                	addi	sp,sp,32
    80001274:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001276:	8f99                	sub	a5,a5,a4
    80001278:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000127a:	4685                	li	a3,1
    8000127c:	0007861b          	sext.w	a2,a5
    80001280:	85ba                	mv	a1,a4
    80001282:	f39ff0ef          	jal	800011ba <uvmunmap>
    80001286:	b7d5                	j	8000126a <uvmdealloc+0x26>

0000000080001288 <uvmalloc>:
  if(newsz < oldsz)
    80001288:	08b66f63          	bltu	a2,a1,80001326 <uvmalloc+0x9e>
{
    8000128c:	7139                	addi	sp,sp,-64
    8000128e:	fc06                	sd	ra,56(sp)
    80001290:	f822                	sd	s0,48(sp)
    80001292:	ec4e                	sd	s3,24(sp)
    80001294:	e852                	sd	s4,16(sp)
    80001296:	e456                	sd	s5,8(sp)
    80001298:	0080                	addi	s0,sp,64
    8000129a:	8aaa                	mv	s5,a0
    8000129c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000129e:	6785                	lui	a5,0x1
    800012a0:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012a2:	95be                	add	a1,a1,a5
    800012a4:	77fd                	lui	a5,0xfffff
    800012a6:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012aa:	08c9f063          	bgeu	s3,a2,8000132a <uvmalloc+0xa2>
    800012ae:	f426                	sd	s1,40(sp)
    800012b0:	f04a                	sd	s2,32(sp)
    800012b2:	e05a                	sd	s6,0(sp)
    800012b4:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012b6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012ba:	845ff0ef          	jal	80000afe <kalloc>
    800012be:	84aa                	mv	s1,a0
    if(mem == 0){
    800012c0:	c515                	beqz	a0,800012ec <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800012c2:	6605                	lui	a2,0x1
    800012c4:	4581                	li	a1,0
    800012c6:	9ddff0ef          	jal	80000ca2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800012ca:	875a                	mv	a4,s6
    800012cc:	86a6                	mv	a3,s1
    800012ce:	6605                	lui	a2,0x1
    800012d0:	85ca                	mv	a1,s2
    800012d2:	8556                	mv	a0,s5
    800012d4:	d1bff0ef          	jal	80000fee <mappages>
    800012d8:	e915                	bnez	a0,8000130c <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800012da:	6785                	lui	a5,0x1
    800012dc:	993e                	add	s2,s2,a5
    800012de:	fd496ee3          	bltu	s2,s4,800012ba <uvmalloc+0x32>
  return newsz;
    800012e2:	8552                	mv	a0,s4
    800012e4:	74a2                	ld	s1,40(sp)
    800012e6:	7902                	ld	s2,32(sp)
    800012e8:	6b02                	ld	s6,0(sp)
    800012ea:	a811                	j	800012fe <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800012ec:	864e                	mv	a2,s3
    800012ee:	85ca                	mv	a1,s2
    800012f0:	8556                	mv	a0,s5
    800012f2:	f53ff0ef          	jal	80001244 <uvmdealloc>
      return 0;
    800012f6:	4501                	li	a0,0
    800012f8:	74a2                	ld	s1,40(sp)
    800012fa:	7902                	ld	s2,32(sp)
    800012fc:	6b02                	ld	s6,0(sp)
}
    800012fe:	70e2                	ld	ra,56(sp)
    80001300:	7442                	ld	s0,48(sp)
    80001302:	69e2                	ld	s3,24(sp)
    80001304:	6a42                	ld	s4,16(sp)
    80001306:	6aa2                	ld	s5,8(sp)
    80001308:	6121                	addi	sp,sp,64
    8000130a:	8082                	ret
      kfree(mem);
    8000130c:	8526                	mv	a0,s1
    8000130e:	f0eff0ef          	jal	80000a1c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001312:	864e                	mv	a2,s3
    80001314:	85ca                	mv	a1,s2
    80001316:	8556                	mv	a0,s5
    80001318:	f2dff0ef          	jal	80001244 <uvmdealloc>
      return 0;
    8000131c:	4501                	li	a0,0
    8000131e:	74a2                	ld	s1,40(sp)
    80001320:	7902                	ld	s2,32(sp)
    80001322:	6b02                	ld	s6,0(sp)
    80001324:	bfe9                	j	800012fe <uvmalloc+0x76>
    return oldsz;
    80001326:	852e                	mv	a0,a1
}
    80001328:	8082                	ret
  return newsz;
    8000132a:	8532                	mv	a0,a2
    8000132c:	bfc9                	j	800012fe <uvmalloc+0x76>

000000008000132e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000132e:	7179                	addi	sp,sp,-48
    80001330:	f406                	sd	ra,40(sp)
    80001332:	f022                	sd	s0,32(sp)
    80001334:	ec26                	sd	s1,24(sp)
    80001336:	e84a                	sd	s2,16(sp)
    80001338:	e44e                	sd	s3,8(sp)
    8000133a:	e052                	sd	s4,0(sp)
    8000133c:	1800                	addi	s0,sp,48
    8000133e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001340:	84aa                	mv	s1,a0
    80001342:	6905                	lui	s2,0x1
    80001344:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001346:	4985                	li	s3,1
    80001348:	a819                	j	8000135e <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000134a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000134c:	00c79513          	slli	a0,a5,0xc
    80001350:	fdfff0ef          	jal	8000132e <freewalk>
      pagetable[i] = 0;
    80001354:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001358:	04a1                	addi	s1,s1,8
    8000135a:	01248f63          	beq	s1,s2,80001378 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000135e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001360:	00f7f713          	andi	a4,a5,15
    80001364:	ff3703e3          	beq	a4,s3,8000134a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001368:	8b85                	andi	a5,a5,1
    8000136a:	d7fd                	beqz	a5,80001358 <freewalk+0x2a>
      panic("freewalk: leaf");
    8000136c:	00006517          	auipc	a0,0x6
    80001370:	dc450513          	addi	a0,a0,-572 # 80007130 <etext+0x130>
    80001374:	c6cff0ef          	jal	800007e0 <panic>
    }
  }
  kfree((void*)pagetable);
    80001378:	8552                	mv	a0,s4
    8000137a:	ea2ff0ef          	jal	80000a1c <kfree>
}
    8000137e:	70a2                	ld	ra,40(sp)
    80001380:	7402                	ld	s0,32(sp)
    80001382:	64e2                	ld	s1,24(sp)
    80001384:	6942                	ld	s2,16(sp)
    80001386:	69a2                	ld	s3,8(sp)
    80001388:	6a02                	ld	s4,0(sp)
    8000138a:	6145                	addi	sp,sp,48
    8000138c:	8082                	ret

000000008000138e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000138e:	1101                	addi	sp,sp,-32
    80001390:	ec06                	sd	ra,24(sp)
    80001392:	e822                	sd	s0,16(sp)
    80001394:	e426                	sd	s1,8(sp)
    80001396:	1000                	addi	s0,sp,32
    80001398:	84aa                	mv	s1,a0
  if(sz > 0)
    8000139a:	e989                	bnez	a1,800013ac <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000139c:	8526                	mv	a0,s1
    8000139e:	f91ff0ef          	jal	8000132e <freewalk>
}
    800013a2:	60e2                	ld	ra,24(sp)
    800013a4:	6442                	ld	s0,16(sp)
    800013a6:	64a2                	ld	s1,8(sp)
    800013a8:	6105                	addi	sp,sp,32
    800013aa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800013ac:	6785                	lui	a5,0x1
    800013ae:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013b0:	95be                	add	a1,a1,a5
    800013b2:	4685                	li	a3,1
    800013b4:	00c5d613          	srli	a2,a1,0xc
    800013b8:	4581                	li	a1,0
    800013ba:	e01ff0ef          	jal	800011ba <uvmunmap>
    800013be:	bff9                	j	8000139c <uvmfree+0xe>

00000000800013c0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800013c0:	ce49                	beqz	a2,8000145a <uvmcopy+0x9a>
{
    800013c2:	715d                	addi	sp,sp,-80
    800013c4:	e486                	sd	ra,72(sp)
    800013c6:	e0a2                	sd	s0,64(sp)
    800013c8:	fc26                	sd	s1,56(sp)
    800013ca:	f84a                	sd	s2,48(sp)
    800013cc:	f44e                	sd	s3,40(sp)
    800013ce:	f052                	sd	s4,32(sp)
    800013d0:	ec56                	sd	s5,24(sp)
    800013d2:	e85a                	sd	s6,16(sp)
    800013d4:	e45e                	sd	s7,8(sp)
    800013d6:	0880                	addi	s0,sp,80
    800013d8:	8aaa                	mv	s5,a0
    800013da:	8b2e                	mv	s6,a1
    800013dc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800013de:	4481                	li	s1,0
    800013e0:	a029                	j	800013ea <uvmcopy+0x2a>
    800013e2:	6785                	lui	a5,0x1
    800013e4:	94be                	add	s1,s1,a5
    800013e6:	0544fe63          	bgeu	s1,s4,80001442 <uvmcopy+0x82>
    if((pte = walk(old, i, 0)) == 0)
    800013ea:	4601                	li	a2,0
    800013ec:	85a6                	mv	a1,s1
    800013ee:	8556                	mv	a0,s5
    800013f0:	b27ff0ef          	jal	80000f16 <walk>
    800013f4:	d57d                	beqz	a0,800013e2 <uvmcopy+0x22>
      continue;   // page table entry hasn't been allocated
    if((*pte & PTE_V) == 0)
    800013f6:	6118                	ld	a4,0(a0)
    800013f8:	00177793          	andi	a5,a4,1
    800013fc:	d3fd                	beqz	a5,800013e2 <uvmcopy+0x22>
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    800013fe:	00a75593          	srli	a1,a4,0xa
    80001402:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001406:	3ff77913          	andi	s2,a4,1023
    if((mem = kalloc()) == 0)
    8000140a:	ef4ff0ef          	jal	80000afe <kalloc>
    8000140e:	89aa                	mv	s3,a0
    80001410:	c105                	beqz	a0,80001430 <uvmcopy+0x70>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001412:	6605                	lui	a2,0x1
    80001414:	85de                	mv	a1,s7
    80001416:	8e9ff0ef          	jal	80000cfe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000141a:	874a                	mv	a4,s2
    8000141c:	86ce                	mv	a3,s3
    8000141e:	6605                	lui	a2,0x1
    80001420:	85a6                	mv	a1,s1
    80001422:	855a                	mv	a0,s6
    80001424:	bcbff0ef          	jal	80000fee <mappages>
    80001428:	dd4d                	beqz	a0,800013e2 <uvmcopy+0x22>
      kfree(mem);
    8000142a:	854e                	mv	a0,s3
    8000142c:	df0ff0ef          	jal	80000a1c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001430:	4685                	li	a3,1
    80001432:	00c4d613          	srli	a2,s1,0xc
    80001436:	4581                	li	a1,0
    80001438:	855a                	mv	a0,s6
    8000143a:	d81ff0ef          	jal	800011ba <uvmunmap>
  return -1;
    8000143e:	557d                	li	a0,-1
    80001440:	a011                	j	80001444 <uvmcopy+0x84>
  return 0;
    80001442:	4501                	li	a0,0
}
    80001444:	60a6                	ld	ra,72(sp)
    80001446:	6406                	ld	s0,64(sp)
    80001448:	74e2                	ld	s1,56(sp)
    8000144a:	7942                	ld	s2,48(sp)
    8000144c:	79a2                	ld	s3,40(sp)
    8000144e:	7a02                	ld	s4,32(sp)
    80001450:	6ae2                	ld	s5,24(sp)
    80001452:	6b42                	ld	s6,16(sp)
    80001454:	6ba2                	ld	s7,8(sp)
    80001456:	6161                	addi	sp,sp,80
    80001458:	8082                	ret
  return 0;
    8000145a:	4501                	li	a0,0
}
    8000145c:	8082                	ret

000000008000145e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000145e:	1141                	addi	sp,sp,-16
    80001460:	e406                	sd	ra,8(sp)
    80001462:	e022                	sd	s0,0(sp)
    80001464:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001466:	4601                	li	a2,0
    80001468:	aafff0ef          	jal	80000f16 <walk>
  if(pte == 0)
    8000146c:	c901                	beqz	a0,8000147c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000146e:	611c                	ld	a5,0(a0)
    80001470:	9bbd                	andi	a5,a5,-17
    80001472:	e11c                	sd	a5,0(a0)
}
    80001474:	60a2                	ld	ra,8(sp)
    80001476:	6402                	ld	s0,0(sp)
    80001478:	0141                	addi	sp,sp,16
    8000147a:	8082                	ret
    panic("uvmclear");
    8000147c:	00006517          	auipc	a0,0x6
    80001480:	cc450513          	addi	a0,a0,-828 # 80007140 <etext+0x140>
    80001484:	b5cff0ef          	jal	800007e0 <panic>

0000000080001488 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001488:	c6dd                	beqz	a3,80001536 <copyinstr+0xae>
{
    8000148a:	715d                	addi	sp,sp,-80
    8000148c:	e486                	sd	ra,72(sp)
    8000148e:	e0a2                	sd	s0,64(sp)
    80001490:	fc26                	sd	s1,56(sp)
    80001492:	f84a                	sd	s2,48(sp)
    80001494:	f44e                	sd	s3,40(sp)
    80001496:	f052                	sd	s4,32(sp)
    80001498:	ec56                	sd	s5,24(sp)
    8000149a:	e85a                	sd	s6,16(sp)
    8000149c:	e45e                	sd	s7,8(sp)
    8000149e:	0880                	addi	s0,sp,80
    800014a0:	8a2a                	mv	s4,a0
    800014a2:	8b2e                	mv	s6,a1
    800014a4:	8bb2                	mv	s7,a2
    800014a6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800014a8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014aa:	6985                	lui	s3,0x1
    800014ac:	a825                	j	800014e4 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800014ae:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800014b2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800014b4:	37fd                	addiw	a5,a5,-1
    800014b6:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800014ba:	60a6                	ld	ra,72(sp)
    800014bc:	6406                	ld	s0,64(sp)
    800014be:	74e2                	ld	s1,56(sp)
    800014c0:	7942                	ld	s2,48(sp)
    800014c2:	79a2                	ld	s3,40(sp)
    800014c4:	7a02                	ld	s4,32(sp)
    800014c6:	6ae2                	ld	s5,24(sp)
    800014c8:	6b42                	ld	s6,16(sp)
    800014ca:	6ba2                	ld	s7,8(sp)
    800014cc:	6161                	addi	sp,sp,80
    800014ce:	8082                	ret
    800014d0:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800014d4:	9742                	add	a4,a4,a6
      --max;
    800014d6:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800014da:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800014de:	04e58463          	beq	a1,a4,80001526 <copyinstr+0x9e>
{
    800014e2:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800014e4:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800014e8:	85a6                	mv	a1,s1
    800014ea:	8552                	mv	a0,s4
    800014ec:	ac5ff0ef          	jal	80000fb0 <walkaddr>
    if(pa0 == 0)
    800014f0:	cd0d                	beqz	a0,8000152a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800014f2:	417486b3          	sub	a3,s1,s7
    800014f6:	96ce                	add	a3,a3,s3
    if(n > max)
    800014f8:	00d97363          	bgeu	s2,a3,800014fe <copyinstr+0x76>
    800014fc:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800014fe:	955e                	add	a0,a0,s7
    80001500:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001502:	c695                	beqz	a3,8000152e <copyinstr+0xa6>
    80001504:	87da                	mv	a5,s6
    80001506:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001508:	41650633          	sub	a2,a0,s6
    while(n > 0){
    8000150c:	96da                	add	a3,a3,s6
    8000150e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001510:	00f60733          	add	a4,a2,a5
    80001514:	00074703          	lbu	a4,0(a4)
    80001518:	db59                	beqz	a4,800014ae <copyinstr+0x26>
        *dst = *p;
    8000151a:	00e78023          	sb	a4,0(a5)
      dst++;
    8000151e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001520:	fed797e3          	bne	a5,a3,8000150e <copyinstr+0x86>
    80001524:	b775                	j	800014d0 <copyinstr+0x48>
    80001526:	4781                	li	a5,0
    80001528:	b771                	j	800014b4 <copyinstr+0x2c>
      return -1;
    8000152a:	557d                	li	a0,-1
    8000152c:	b779                	j	800014ba <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000152e:	6b85                	lui	s7,0x1
    80001530:	9ba6                	add	s7,s7,s1
    80001532:	87da                	mv	a5,s6
    80001534:	b77d                	j	800014e2 <copyinstr+0x5a>
  int got_null = 0;
    80001536:	4781                	li	a5,0
  if(got_null){
    80001538:	37fd                	addiw	a5,a5,-1
    8000153a:	0007851b          	sext.w	a0,a5
}
    8000153e:	8082                	ret

0000000080001540 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001540:	1141                	addi	sp,sp,-16
    80001542:	e406                	sd	ra,8(sp)
    80001544:	e022                	sd	s0,0(sp)
    80001546:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80001548:	4601                	li	a2,0
    8000154a:	9cdff0ef          	jal	80000f16 <walk>
  if (pte == 0) {
    8000154e:	c519                	beqz	a0,8000155c <ismapped+0x1c>
    return 0;
  }
  if (*pte & PTE_V){
    80001550:	6108                	ld	a0,0(a0)
    80001552:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001554:	60a2                	ld	ra,8(sp)
    80001556:	6402                	ld	s0,0(sp)
    80001558:	0141                	addi	sp,sp,16
    8000155a:	8082                	ret
    return 0;
    8000155c:	4501                	li	a0,0
    8000155e:	bfdd                	j	80001554 <ismapped+0x14>

0000000080001560 <vmfault>:
{
    80001560:	7179                	addi	sp,sp,-48
    80001562:	f406                	sd	ra,40(sp)
    80001564:	f022                	sd	s0,32(sp)
    80001566:	ec26                	sd	s1,24(sp)
    80001568:	e44e                	sd	s3,8(sp)
    8000156a:	1800                	addi	s0,sp,48
    8000156c:	89aa                	mv	s3,a0
    8000156e:	84ae                	mv	s1,a1
  struct proc *p = myproc();
    80001570:	35e000ef          	jal	800018ce <myproc>
  if (va >= p->sz)
    80001574:	693c                	ld	a5,80(a0)
    80001576:	00f4ea63          	bltu	s1,a5,8000158a <vmfault+0x2a>
    return 0;
    8000157a:	4981                	li	s3,0
}
    8000157c:	854e                	mv	a0,s3
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	69a2                	ld	s3,8(sp)
    80001586:	6145                	addi	sp,sp,48
    80001588:	8082                	ret
    8000158a:	e84a                	sd	s2,16(sp)
    8000158c:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    8000158e:	77fd                	lui	a5,0xfffff
    80001590:	8cfd                	and	s1,s1,a5
  if(ismapped(pagetable, va)) {
    80001592:	85a6                	mv	a1,s1
    80001594:	854e                	mv	a0,s3
    80001596:	fabff0ef          	jal	80001540 <ismapped>
    return 0;
    8000159a:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    8000159c:	c119                	beqz	a0,800015a2 <vmfault+0x42>
    8000159e:	6942                	ld	s2,16(sp)
    800015a0:	bff1                	j	8000157c <vmfault+0x1c>
    800015a2:	e052                	sd	s4,0(sp)
  mem = (uint64) kalloc();
    800015a4:	d5aff0ef          	jal	80000afe <kalloc>
    800015a8:	8a2a                	mv	s4,a0
  if(mem == 0)
    800015aa:	c90d                	beqz	a0,800015dc <vmfault+0x7c>
  mem = (uint64) kalloc();
    800015ac:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    800015ae:	6605                	lui	a2,0x1
    800015b0:	4581                	li	a1,0
    800015b2:	ef0ff0ef          	jal	80000ca2 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    800015b6:	4759                	li	a4,22
    800015b8:	86d2                	mv	a3,s4
    800015ba:	6605                	lui	a2,0x1
    800015bc:	85a6                	mv	a1,s1
    800015be:	05893503          	ld	a0,88(s2)
    800015c2:	a2dff0ef          	jal	80000fee <mappages>
    800015c6:	e501                	bnez	a0,800015ce <vmfault+0x6e>
    800015c8:	6942                	ld	s2,16(sp)
    800015ca:	6a02                	ld	s4,0(sp)
    800015cc:	bf45                	j	8000157c <vmfault+0x1c>
    kfree((void *)mem);
    800015ce:	8552                	mv	a0,s4
    800015d0:	c4cff0ef          	jal	80000a1c <kfree>
    return 0;
    800015d4:	4981                	li	s3,0
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	6a02                	ld	s4,0(sp)
    800015da:	b74d                	j	8000157c <vmfault+0x1c>
    800015dc:	6942                	ld	s2,16(sp)
    800015de:	6a02                	ld	s4,0(sp)
    800015e0:	bf71                	j	8000157c <vmfault+0x1c>

00000000800015e2 <copyout>:
  while(len > 0){
    800015e2:	c2cd                	beqz	a3,80001684 <copyout+0xa2>
{
    800015e4:	711d                	addi	sp,sp,-96
    800015e6:	ec86                	sd	ra,88(sp)
    800015e8:	e8a2                	sd	s0,80(sp)
    800015ea:	e4a6                	sd	s1,72(sp)
    800015ec:	f852                	sd	s4,48(sp)
    800015ee:	f05a                	sd	s6,32(sp)
    800015f0:	ec5e                	sd	s7,24(sp)
    800015f2:	e862                	sd	s8,16(sp)
    800015f4:	1080                	addi	s0,sp,96
    800015f6:	8c2a                	mv	s8,a0
    800015f8:	8b2e                	mv	s6,a1
    800015fa:	8bb2                	mv	s7,a2
    800015fc:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    800015fe:	74fd                	lui	s1,0xfffff
    80001600:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001602:	57fd                	li	a5,-1
    80001604:	83e9                	srli	a5,a5,0x1a
    80001606:	0897e163          	bltu	a5,s1,80001688 <copyout+0xa6>
    8000160a:	e0ca                	sd	s2,64(sp)
    8000160c:	fc4e                	sd	s3,56(sp)
    8000160e:	f456                	sd	s5,40(sp)
    80001610:	e466                	sd	s9,8(sp)
    80001612:	e06a                	sd	s10,0(sp)
    80001614:	6d05                	lui	s10,0x1
    80001616:	8cbe                	mv	s9,a5
    80001618:	a015                	j	8000163c <copyout+0x5a>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000161a:	409b0533          	sub	a0,s6,s1
    8000161e:	0009861b          	sext.w	a2,s3
    80001622:	85de                	mv	a1,s7
    80001624:	954a                	add	a0,a0,s2
    80001626:	ed8ff0ef          	jal	80000cfe <memmove>
    len -= n;
    8000162a:	413a0a33          	sub	s4,s4,s3
    src += n;
    8000162e:	9bce                	add	s7,s7,s3
  while(len > 0){
    80001630:	040a0363          	beqz	s4,80001676 <copyout+0x94>
    if(va0 >= MAXVA)
    80001634:	055cec63          	bltu	s9,s5,8000168c <copyout+0xaa>
    80001638:	84d6                	mv	s1,s5
    8000163a:	8b56                	mv	s6,s5
    pa0 = walkaddr(pagetable, va0);
    8000163c:	85a6                	mv	a1,s1
    8000163e:	8562                	mv	a0,s8
    80001640:	971ff0ef          	jal	80000fb0 <walkaddr>
    80001644:	892a                	mv	s2,a0
    if(pa0 == 0) {
    80001646:	e901                	bnez	a0,80001656 <copyout+0x74>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001648:	4601                	li	a2,0
    8000164a:	85a6                	mv	a1,s1
    8000164c:	8562                	mv	a0,s8
    8000164e:	f13ff0ef          	jal	80001560 <vmfault>
    80001652:	892a                	mv	s2,a0
    80001654:	c139                	beqz	a0,8000169a <copyout+0xb8>
    pte = walk(pagetable, va0, 0);
    80001656:	4601                	li	a2,0
    80001658:	85a6                	mv	a1,s1
    8000165a:	8562                	mv	a0,s8
    8000165c:	8bbff0ef          	jal	80000f16 <walk>
    if((*pte & PTE_W) == 0)
    80001660:	611c                	ld	a5,0(a0)
    80001662:	8b91                	andi	a5,a5,4
    80001664:	c3b1                	beqz	a5,800016a8 <copyout+0xc6>
    n = PGSIZE - (dstva - va0);
    80001666:	01a48ab3          	add	s5,s1,s10
    8000166a:	416a89b3          	sub	s3,s5,s6
    if(n > len)
    8000166e:	fb3a76e3          	bgeu	s4,s3,8000161a <copyout+0x38>
    80001672:	89d2                	mv	s3,s4
    80001674:	b75d                	j	8000161a <copyout+0x38>
  return 0;
    80001676:	4501                	li	a0,0
    80001678:	6906                	ld	s2,64(sp)
    8000167a:	79e2                	ld	s3,56(sp)
    8000167c:	7aa2                	ld	s5,40(sp)
    8000167e:	6ca2                	ld	s9,8(sp)
    80001680:	6d02                	ld	s10,0(sp)
    80001682:	a80d                	j	800016b4 <copyout+0xd2>
    80001684:	4501                	li	a0,0
}
    80001686:	8082                	ret
      return -1;
    80001688:	557d                	li	a0,-1
    8000168a:	a02d                	j	800016b4 <copyout+0xd2>
    8000168c:	557d                	li	a0,-1
    8000168e:	6906                	ld	s2,64(sp)
    80001690:	79e2                	ld	s3,56(sp)
    80001692:	7aa2                	ld	s5,40(sp)
    80001694:	6ca2                	ld	s9,8(sp)
    80001696:	6d02                	ld	s10,0(sp)
    80001698:	a831                	j	800016b4 <copyout+0xd2>
        return -1;
    8000169a:	557d                	li	a0,-1
    8000169c:	6906                	ld	s2,64(sp)
    8000169e:	79e2                	ld	s3,56(sp)
    800016a0:	7aa2                	ld	s5,40(sp)
    800016a2:	6ca2                	ld	s9,8(sp)
    800016a4:	6d02                	ld	s10,0(sp)
    800016a6:	a039                	j	800016b4 <copyout+0xd2>
      return -1;
    800016a8:	557d                	li	a0,-1
    800016aa:	6906                	ld	s2,64(sp)
    800016ac:	79e2                	ld	s3,56(sp)
    800016ae:	7aa2                	ld	s5,40(sp)
    800016b0:	6ca2                	ld	s9,8(sp)
    800016b2:	6d02                	ld	s10,0(sp)
}
    800016b4:	60e6                	ld	ra,88(sp)
    800016b6:	6446                	ld	s0,80(sp)
    800016b8:	64a6                	ld	s1,72(sp)
    800016ba:	7a42                	ld	s4,48(sp)
    800016bc:	7b02                	ld	s6,32(sp)
    800016be:	6be2                	ld	s7,24(sp)
    800016c0:	6c42                	ld	s8,16(sp)
    800016c2:	6125                	addi	sp,sp,96
    800016c4:	8082                	ret

00000000800016c6 <copyin>:
  while(len > 0){
    800016c6:	c6c9                	beqz	a3,80001750 <copyin+0x8a>
{
    800016c8:	715d                	addi	sp,sp,-80
    800016ca:	e486                	sd	ra,72(sp)
    800016cc:	e0a2                	sd	s0,64(sp)
    800016ce:	fc26                	sd	s1,56(sp)
    800016d0:	f84a                	sd	s2,48(sp)
    800016d2:	f44e                	sd	s3,40(sp)
    800016d4:	f052                	sd	s4,32(sp)
    800016d6:	ec56                	sd	s5,24(sp)
    800016d8:	e85a                	sd	s6,16(sp)
    800016da:	e45e                	sd	s7,8(sp)
    800016dc:	e062                	sd	s8,0(sp)
    800016de:	0880                	addi	s0,sp,80
    800016e0:	8baa                	mv	s7,a0
    800016e2:	8aae                	mv	s5,a1
    800016e4:	8932                	mv	s2,a2
    800016e6:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    800016e8:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    800016ea:	6b05                	lui	s6,0x1
    800016ec:	a035                	j	80001718 <copyin+0x52>
    800016ee:	412984b3          	sub	s1,s3,s2
    800016f2:	94da                	add	s1,s1,s6
    if(n > len)
    800016f4:	009a7363          	bgeu	s4,s1,800016fa <copyin+0x34>
    800016f8:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016fa:	413905b3          	sub	a1,s2,s3
    800016fe:	0004861b          	sext.w	a2,s1
    80001702:	95aa                	add	a1,a1,a0
    80001704:	8556                	mv	a0,s5
    80001706:	df8ff0ef          	jal	80000cfe <memmove>
    len -= n;
    8000170a:	409a0a33          	sub	s4,s4,s1
    dst += n;
    8000170e:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001710:	01698933          	add	s2,s3,s6
  while(len > 0){
    80001714:	020a0163          	beqz	s4,80001736 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001718:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    8000171c:	85ce                	mv	a1,s3
    8000171e:	855e                	mv	a0,s7
    80001720:	891ff0ef          	jal	80000fb0 <walkaddr>
    if(pa0 == 0) {
    80001724:	f569                	bnez	a0,800016ee <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001726:	4601                	li	a2,0
    80001728:	85ce                	mv	a1,s3
    8000172a:	855e                	mv	a0,s7
    8000172c:	e35ff0ef          	jal	80001560 <vmfault>
    80001730:	fd5d                	bnez	a0,800016ee <copyin+0x28>
        return -1;
    80001732:	557d                	li	a0,-1
    80001734:	a011                	j	80001738 <copyin+0x72>
  return 0;
    80001736:	4501                	li	a0,0
}
    80001738:	60a6                	ld	ra,72(sp)
    8000173a:	6406                	ld	s0,64(sp)
    8000173c:	74e2                	ld	s1,56(sp)
    8000173e:	7942                	ld	s2,48(sp)
    80001740:	79a2                	ld	s3,40(sp)
    80001742:	7a02                	ld	s4,32(sp)
    80001744:	6ae2                	ld	s5,24(sp)
    80001746:	6b42                	ld	s6,16(sp)
    80001748:	6ba2                	ld	s7,8(sp)
    8000174a:	6c02                	ld	s8,0(sp)
    8000174c:	6161                	addi	sp,sp,80
    8000174e:	8082                	ret
  return 0;
    80001750:	4501                	li	a0,0
}
    80001752:	8082                	ret

0000000080001754 <proc_mapstacks>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl) {
    80001754:	7139                	addi	sp,sp,-64
    80001756:	fc06                	sd	ra,56(sp)
    80001758:	f822                	sd	s0,48(sp)
    8000175a:	f426                	sd	s1,40(sp)
    8000175c:	f04a                	sd	s2,32(sp)
    8000175e:	ec4e                	sd	s3,24(sp)
    80001760:	e852                	sd	s4,16(sp)
    80001762:	e456                	sd	s5,8(sp)
    80001764:	e05a                	sd	s6,0(sp)
    80001766:	0080                	addi	s0,sp,64
    80001768:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000176a:	00011497          	auipc	s1,0x11
    8000176e:	2ae48493          	addi	s1,s1,686 # 80012a18 <proc>
    char *pa = kalloc();
    if (pa == 0) panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001772:	8b26                	mv	s6,s1
    80001774:	ff4df937          	lui	s2,0xff4df
    80001778:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bafc5>
    8000177c:	0936                	slli	s2,s2,0xd
    8000177e:	6f590913          	addi	s2,s2,1781
    80001782:	0936                	slli	s2,s2,0xd
    80001784:	bd390913          	addi	s2,s2,-1069
    80001788:	0932                	slli	s2,s2,0xc
    8000178a:	7a790913          	addi	s2,s2,1959
    8000178e:	040009b7          	lui	s3,0x4000
    80001792:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001794:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001796:	00017a97          	auipc	s5,0x17
    8000179a:	e82a8a93          	addi	s5,s5,-382 # 80018618 <tickslock>
    char *pa = kalloc();
    8000179e:	b60ff0ef          	jal	80000afe <kalloc>
    800017a2:	862a                	mv	a2,a0
    if (pa == 0) panic("kalloc");
    800017a4:	cd15                	beqz	a0,800017e0 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int)(p - proc));
    800017a6:	416485b3          	sub	a1,s1,s6
    800017aa:	8591                	srai	a1,a1,0x4
    800017ac:	032585b3          	mul	a1,a1,s2
    800017b0:	2585                	addiw	a1,a1,1
    800017b2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017b6:	4719                	li	a4,6
    800017b8:	6685                	lui	a3,0x1
    800017ba:	40b985b3          	sub	a1,s3,a1
    800017be:	8552                	mv	a0,s4
    800017c0:	8dfff0ef          	jal	8000109e <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017c4:	17048493          	addi	s1,s1,368
    800017c8:	fd549be3          	bne	s1,s5,8000179e <proc_mapstacks+0x4a>
  }
}
    800017cc:	70e2                	ld	ra,56(sp)
    800017ce:	7442                	ld	s0,48(sp)
    800017d0:	74a2                	ld	s1,40(sp)
    800017d2:	7902                	ld	s2,32(sp)
    800017d4:	69e2                	ld	s3,24(sp)
    800017d6:	6a42                	ld	s4,16(sp)
    800017d8:	6aa2                	ld	s5,8(sp)
    800017da:	6b02                	ld	s6,0(sp)
    800017dc:	6121                	addi	sp,sp,64
    800017de:	8082                	ret
    if (pa == 0) panic("kalloc");
    800017e0:	00006517          	auipc	a0,0x6
    800017e4:	97050513          	addi	a0,a0,-1680 # 80007150 <etext+0x150>
    800017e8:	ff9fe0ef          	jal	800007e0 <panic>

00000000800017ec <procinit>:

// initialize the proc table.
void procinit(void) {
    800017ec:	7139                	addi	sp,sp,-64
    800017ee:	fc06                	sd	ra,56(sp)
    800017f0:	f822                	sd	s0,48(sp)
    800017f2:	f426                	sd	s1,40(sp)
    800017f4:	f04a                	sd	s2,32(sp)
    800017f6:	ec4e                	sd	s3,24(sp)
    800017f8:	e852                	sd	s4,16(sp)
    800017fa:	e456                	sd	s5,8(sp)
    800017fc:	e05a                	sd	s6,0(sp)
    800017fe:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001800:	00006597          	auipc	a1,0x6
    80001804:	95858593          	addi	a1,a1,-1704 # 80007158 <etext+0x158>
    80001808:	00011517          	auipc	a0,0x11
    8000180c:	de050513          	addi	a0,a0,-544 # 800125e8 <pid_lock>
    80001810:	b3eff0ef          	jal	80000b4e <initlock>
  initlock(&wait_lock, "wait_lock");
    80001814:	00006597          	auipc	a1,0x6
    80001818:	94c58593          	addi	a1,a1,-1716 # 80007160 <etext+0x160>
    8000181c:	00011517          	auipc	a0,0x11
    80001820:	de450513          	addi	a0,a0,-540 # 80012600 <wait_lock>
    80001824:	b2aff0ef          	jal	80000b4e <initlock>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001828:	00011497          	auipc	s1,0x11
    8000182c:	1f048493          	addi	s1,s1,496 # 80012a18 <proc>
    initlock(&p->lock, "proc");
    80001830:	00006b17          	auipc	s6,0x6
    80001834:	940b0b13          	addi	s6,s6,-1728 # 80007170 <etext+0x170>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001838:	8aa6                	mv	s5,s1
    8000183a:	ff4df937          	lui	s2,0xff4df
    8000183e:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bafc5>
    80001842:	0936                	slli	s2,s2,0xd
    80001844:	6f590913          	addi	s2,s2,1781
    80001848:	0936                	slli	s2,s2,0xd
    8000184a:	bd390913          	addi	s2,s2,-1069
    8000184e:	0932                	slli	s2,s2,0xc
    80001850:	7a790913          	addi	s2,s2,1959
    80001854:	040009b7          	lui	s3,0x4000
    80001858:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000185a:	09b2                	slli	s3,s3,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000185c:	00017a17          	auipc	s4,0x17
    80001860:	dbca0a13          	addi	s4,s4,-580 # 80018618 <tickslock>
    initlock(&p->lock, "proc");
    80001864:	85da                	mv	a1,s6
    80001866:	8526                	mv	a0,s1
    80001868:	ae6ff0ef          	jal	80000b4e <initlock>
    p->state = UNUSED;
    8000186c:	0204a023          	sw	zero,32(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001870:	415487b3          	sub	a5,s1,s5
    80001874:	8791                	srai	a5,a5,0x4
    80001876:	032787b3          	mul	a5,a5,s2
    8000187a:	2785                	addiw	a5,a5,1 # fffffffffffff001 <end+0xffffffff7ffdb609>
    8000187c:	00d7979b          	slliw	a5,a5,0xd
    80001880:	40f987b3          	sub	a5,s3,a5
    80001884:	e4bc                	sd	a5,72(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001886:	17048493          	addi	s1,s1,368
    8000188a:	fd449de3          	bne	s1,s4,80001864 <procinit+0x78>
  }
}
    8000188e:	70e2                	ld	ra,56(sp)
    80001890:	7442                	ld	s0,48(sp)
    80001892:	74a2                	ld	s1,40(sp)
    80001894:	7902                	ld	s2,32(sp)
    80001896:	69e2                	ld	s3,24(sp)
    80001898:	6a42                	ld	s4,16(sp)
    8000189a:	6aa2                	ld	s5,8(sp)
    8000189c:	6b02                	ld	s6,0(sp)
    8000189e:	6121                	addi	sp,sp,64
    800018a0:	8082                	ret

00000000800018a2 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
    800018a2:	1141                	addi	sp,sp,-16
    800018a4:	e422                	sd	s0,8(sp)
    800018a6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018a8:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018aa:	2501                	sext.w	a0,a0
    800018ac:	6422                	ld	s0,8(sp)
    800018ae:	0141                	addi	sp,sp,16
    800018b0:	8082                	ret

00000000800018b2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *mycpu(void) {
    800018b2:	1141                	addi	sp,sp,-16
    800018b4:	e422                	sd	s0,8(sp)
    800018b6:	0800                	addi	s0,sp,16
    800018b8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ba:	2781                	sext.w	a5,a5
    800018bc:	079e                	slli	a5,a5,0x7
  return c;
}
    800018be:	00011517          	auipc	a0,0x11
    800018c2:	d5a50513          	addi	a0,a0,-678 # 80012618 <cpus>
    800018c6:	953e                	add	a0,a0,a5
    800018c8:	6422                	ld	s0,8(sp)
    800018ca:	0141                	addi	sp,sp,16
    800018cc:	8082                	ret

00000000800018ce <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *myproc(void) {
    800018ce:	1101                	addi	sp,sp,-32
    800018d0:	ec06                	sd	ra,24(sp)
    800018d2:	e822                	sd	s0,16(sp)
    800018d4:	e426                	sd	s1,8(sp)
    800018d6:	1000                	addi	s0,sp,32
  push_off();
    800018d8:	ab6ff0ef          	jal	80000b8e <push_off>
    800018dc:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018de:	2781                	sext.w	a5,a5
    800018e0:	079e                	slli	a5,a5,0x7
    800018e2:	00011717          	auipc	a4,0x11
    800018e6:	d0670713          	addi	a4,a4,-762 # 800125e8 <pid_lock>
    800018ea:	97ba                	add	a5,a5,a4
    800018ec:	7b84                	ld	s1,48(a5)
  pop_off();
    800018ee:	b24ff0ef          	jal	80000c12 <pop_off>
  return p;
}
    800018f2:	8526                	mv	a0,s1
    800018f4:	60e2                	ld	ra,24(sp)
    800018f6:	6442                	ld	s0,16(sp)
    800018f8:	64a2                	ld	s1,8(sp)
    800018fa:	6105                	addi	sp,sp,32
    800018fc:	8082                	ret

00000000800018fe <forkret>:
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void) {
    800018fe:	7179                	addi	sp,sp,-48
    80001900:	f406                	sd	ra,40(sp)
    80001902:	f022                	sd	s0,32(sp)
    80001904:	ec26                	sd	s1,24(sp)
    80001906:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001908:	fc7ff0ef          	jal	800018ce <myproc>
    8000190c:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000190e:	b58ff0ef          	jal	80000c66 <release>

  if (first) {
    80001912:	00009797          	auipc	a5,0x9
    80001916:	b7e7a783          	lw	a5,-1154(a5) # 8000a490 <first.1>
    8000191a:	cf8d                	beqz	a5,80001954 <forkret+0x56>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000191c:	4505                	li	a0,1
    8000191e:	575010ef          	jal	80003692 <fsinit>

    first = 0;
    80001922:	00009797          	auipc	a5,0x9
    80001926:	b607a723          	sw	zero,-1170(a5) # 8000a490 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000192a:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    8000192e:	00006517          	auipc	a0,0x6
    80001932:	84a50513          	addi	a0,a0,-1974 # 80007178 <etext+0x178>
    80001936:	fca43823          	sd	a0,-48(s0)
    8000193a:	fc043c23          	sd	zero,-40(s0)
    8000193e:	fd040593          	addi	a1,s0,-48
    80001942:	651020ef          	jal	80004792 <kexec>
    80001946:	70bc                	ld	a5,96(s1)
    80001948:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000194a:	70bc                	ld	a5,96(s1)
    8000194c:	7bb8                	ld	a4,112(a5)
    8000194e:	57fd                	li	a5,-1
    80001950:	02f70d63          	beq	a4,a5,8000198a <forkret+0x8c>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001954:	39f000ef          	jal	800024f2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001958:	6ca8                	ld	a0,88(s1)
    8000195a:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000195c:	04000737          	lui	a4,0x4000
    80001960:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001962:	0732                	slli	a4,a4,0xc
    80001964:	00004797          	auipc	a5,0x4
    80001968:	73878793          	addi	a5,a5,1848 # 8000609c <userret>
    8000196c:	00004697          	auipc	a3,0x4
    80001970:	69468693          	addi	a3,a3,1684 # 80006000 <_trampoline>
    80001974:	8f95                	sub	a5,a5,a3
    80001976:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001978:	577d                	li	a4,-1
    8000197a:	177e                	slli	a4,a4,0x3f
    8000197c:	8d59                	or	a0,a0,a4
    8000197e:	9782                	jalr	a5
}
    80001980:	70a2                	ld	ra,40(sp)
    80001982:	7402                	ld	s0,32(sp)
    80001984:	64e2                	ld	s1,24(sp)
    80001986:	6145                	addi	sp,sp,48
    80001988:	8082                	ret
      panic("exec");
    8000198a:	00005517          	auipc	a0,0x5
    8000198e:	7f650513          	addi	a0,a0,2038 # 80007180 <etext+0x180>
    80001992:	e4ffe0ef          	jal	800007e0 <panic>

0000000080001996 <getprocbyid>:
struct proc *getprocbyid(int pid) {
    80001996:	1141                	addi	sp,sp,-16
    80001998:	e422                	sd	s0,8(sp)
    8000199a:	0800                	addi	s0,sp,16
    8000199c:	872a                	mv	a4,a0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000199e:	00011517          	auipc	a0,0x11
    800019a2:	07a50513          	addi	a0,a0,122 # 80012a18 <proc>
    800019a6:	00017697          	auipc	a3,0x17
    800019aa:	c7268693          	addi	a3,a3,-910 # 80018618 <tickslock>
    if (p->pid == pid) {
    800019ae:	5d1c                	lw	a5,56(a0)
    800019b0:	00e78763          	beq	a5,a4,800019be <getprocbyid+0x28>
  for (p = proc; p < &proc[NPROC]; p++) {
    800019b4:	17050513          	addi	a0,a0,368
    800019b8:	fed51be3          	bne	a0,a3,800019ae <getprocbyid+0x18>
  return 0;
    800019bc:	4501                	li	a0,0
}
    800019be:	6422                	ld	s0,8(sp)
    800019c0:	0141                	addi	sp,sp,16
    800019c2:	8082                	ret

00000000800019c4 <allocpid>:
int allocpid() {
    800019c4:	1101                	addi	sp,sp,-32
    800019c6:	ec06                	sd	ra,24(sp)
    800019c8:	e822                	sd	s0,16(sp)
    800019ca:	e426                	sd	s1,8(sp)
    800019cc:	e04a                	sd	s2,0(sp)
    800019ce:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019d0:	00011917          	auipc	s2,0x11
    800019d4:	c1890913          	addi	s2,s2,-1000 # 800125e8 <pid_lock>
    800019d8:	854a                	mv	a0,s2
    800019da:	9f4ff0ef          	jal	80000bce <acquire>
  pid = nextpid;
    800019de:	00009797          	auipc	a5,0x9
    800019e2:	ab678793          	addi	a5,a5,-1354 # 8000a494 <nextpid>
    800019e6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019e8:	0014871b          	addiw	a4,s1,1
    800019ec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019ee:	854a                	mv	a0,s2
    800019f0:	a76ff0ef          	jal	80000c66 <release>
}
    800019f4:	8526                	mv	a0,s1
    800019f6:	60e2                	ld	ra,24(sp)
    800019f8:	6442                	ld	s0,16(sp)
    800019fa:	64a2                	ld	s1,8(sp)
    800019fc:	6902                	ld	s2,0(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret

0000000080001a02 <cps>:
{
    80001a02:	715d                	addi	sp,sp,-80
    80001a04:	e486                	sd	ra,72(sp)
    80001a06:	e0a2                	sd	s0,64(sp)
    80001a08:	fc26                	sd	s1,56(sp)
    80001a0a:	f84a                	sd	s2,48(sp)
    80001a0c:	f44e                	sd	s3,40(sp)
    80001a0e:	f052                	sd	s4,32(sp)
    80001a10:	ec56                	sd	s5,24(sp)
    80001a12:	e85a                	sd	s6,16(sp)
    80001a14:	e45e                	sd	s7,8(sp)
    80001a16:	e062                	sd	s8,0(sp)
    80001a18:	0880                	addi	s0,sp,80
	printf("name \t pid \t state \t priority \n");
    80001a1a:	00005517          	auipc	a0,0x5
    80001a1e:	76e50513          	addi	a0,a0,1902 # 80007188 <etext+0x188>
    80001a22:	ad9fe0ef          	jal	800004fa <printf>
	for(p = proc; p < &proc[NPROC]; p++){
    80001a26:	00011497          	auipc	s1,0x11
    80001a2a:	15248493          	addi	s1,s1,338 # 80012b78 <proc+0x160>
    80001a2e:	00017997          	auipc	s3,0x17
    80001a32:	d4a98993          	addi	s3,s3,-694 # 80018778 <bcache+0x148>
		if(p->state == SLEEPING)
    80001a36:	4909                	li	s2,2
		else if(p->state == RUNNING)
    80001a38:	4a11                	li	s4,4
		else if(p->state == RUNNABLE)
    80001a3a:	4a8d                	li	s5,3
			printf("%s \t %d \t RUNNABLE \t %d \n", p->name, p->pid, p->nice);	
    80001a3c:	00005c17          	auipc	s8,0x5
    80001a40:	7acc0c13          	addi	s8,s8,1964 # 800071e8 <etext+0x1e8>
			printf("%s \t %d \t RUNNING \t %d \n", p->name, p->pid, p->nice);
    80001a44:	00005b97          	auipc	s7,0x5
    80001a48:	784b8b93          	addi	s7,s7,1924 # 800071c8 <etext+0x1c8>
			printf("%s \t %d \t SLEEEPING \t %d \n", p->name, p->pid, p->nice);
    80001a4c:	00005b17          	auipc	s6,0x5
    80001a50:	75cb0b13          	addi	s6,s6,1884 # 800071a8 <etext+0x1a8>
    80001a54:	a821                	j	80001a6c <cps+0x6a>
    80001a56:	ebc4a683          	lw	a3,-324(s1)
    80001a5a:	ed84a603          	lw	a2,-296(s1)
    80001a5e:	855a                	mv	a0,s6
    80001a60:	a9bfe0ef          	jal	800004fa <printf>
	for(p = proc; p < &proc[NPROC]; p++){
    80001a64:	17048493          	addi	s1,s1,368
    80001a68:	03348b63          	beq	s1,s3,80001a9e <cps+0x9c>
		if(p->state == SLEEPING)
    80001a6c:	85a6                	mv	a1,s1
    80001a6e:	ec04a783          	lw	a5,-320(s1)
    80001a72:	ff2782e3          	beq	a5,s2,80001a56 <cps+0x54>
		else if(p->state == RUNNING)
    80001a76:	01478c63          	beq	a5,s4,80001a8e <cps+0x8c>
		else if(p->state == RUNNABLE)
    80001a7a:	ff5795e3          	bne	a5,s5,80001a64 <cps+0x62>
			printf("%s \t %d \t RUNNABLE \t %d \n", p->name, p->pid, p->nice);	
    80001a7e:	ebc4a683          	lw	a3,-324(s1)
    80001a82:	ed84a603          	lw	a2,-296(s1)
    80001a86:	8562                	mv	a0,s8
    80001a88:	a73fe0ef          	jal	800004fa <printf>
    80001a8c:	bfe1                	j	80001a64 <cps+0x62>
			printf("%s \t %d \t RUNNING \t %d \n", p->name, p->pid, p->nice);
    80001a8e:	ebc4a683          	lw	a3,-324(s1)
    80001a92:	ed84a603          	lw	a2,-296(s1)
    80001a96:	855e                	mv	a0,s7
    80001a98:	a63fe0ef          	jal	800004fa <printf>
    80001a9c:	b7e1                	j	80001a64 <cps+0x62>
}
    80001a9e:	4559                	li	a0,22
    80001aa0:	60a6                	ld	ra,72(sp)
    80001aa2:	6406                	ld	s0,64(sp)
    80001aa4:	74e2                	ld	s1,56(sp)
    80001aa6:	7942                	ld	s2,48(sp)
    80001aa8:	79a2                	ld	s3,40(sp)
    80001aaa:	7a02                	ld	s4,32(sp)
    80001aac:	6ae2                	ld	s5,24(sp)
    80001aae:	6b42                	ld	s6,16(sp)
    80001ab0:	6ba2                	ld	s7,8(sp)
    80001ab2:	6c02                	ld	s8,0(sp)
    80001ab4:	6161                	addi	sp,sp,80
    80001ab6:	8082                	ret

0000000080001ab8 <proc_pagetable>:
pagetable_t proc_pagetable(struct proc *p) {
    80001ab8:	1101                	addi	sp,sp,-32
    80001aba:	ec06                	sd	ra,24(sp)
    80001abc:	e822                	sd	s0,16(sp)
    80001abe:	e426                	sd	s1,8(sp)
    80001ac0:	e04a                	sd	s2,0(sp)
    80001ac2:	1000                	addi	s0,sp,32
    80001ac4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ac6:	eceff0ef          	jal	80001194 <uvmcreate>
    80001aca:	84aa                	mv	s1,a0
  if (pagetable == 0) return 0;
    80001acc:	cd05                	beqz	a0,80001b04 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    80001ace:	4729                	li	a4,10
    80001ad0:	00004697          	auipc	a3,0x4
    80001ad4:	53068693          	addi	a3,a3,1328 # 80006000 <_trampoline>
    80001ad8:	6605                	lui	a2,0x1
    80001ada:	040005b7          	lui	a1,0x4000
    80001ade:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ae0:	05b2                	slli	a1,a1,0xc
    80001ae2:	d0cff0ef          	jal	80000fee <mappages>
    80001ae6:	02054663          	bltz	a0,80001b12 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001aea:	4719                	li	a4,6
    80001aec:	06093683          	ld	a3,96(s2)
    80001af0:	6605                	lui	a2,0x1
    80001af2:	020005b7          	lui	a1,0x2000
    80001af6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001af8:	05b6                	slli	a1,a1,0xd
    80001afa:	8526                	mv	a0,s1
    80001afc:	cf2ff0ef          	jal	80000fee <mappages>
    80001b00:	00054f63          	bltz	a0,80001b1e <proc_pagetable+0x66>
}
    80001b04:	8526                	mv	a0,s1
    80001b06:	60e2                	ld	ra,24(sp)
    80001b08:	6442                	ld	s0,16(sp)
    80001b0a:	64a2                	ld	s1,8(sp)
    80001b0c:	6902                	ld	s2,0(sp)
    80001b0e:	6105                	addi	sp,sp,32
    80001b10:	8082                	ret
    uvmfree(pagetable, 0);
    80001b12:	4581                	li	a1,0
    80001b14:	8526                	mv	a0,s1
    80001b16:	879ff0ef          	jal	8000138e <uvmfree>
    return 0;
    80001b1a:	4481                	li	s1,0
    80001b1c:	b7e5                	j	80001b04 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b1e:	4681                	li	a3,0
    80001b20:	4605                	li	a2,1
    80001b22:	040005b7          	lui	a1,0x4000
    80001b26:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b28:	05b2                	slli	a1,a1,0xc
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	e8eff0ef          	jal	800011ba <uvmunmap>
    uvmfree(pagetable, 0);
    80001b30:	4581                	li	a1,0
    80001b32:	8526                	mv	a0,s1
    80001b34:	85bff0ef          	jal	8000138e <uvmfree>
    return 0;
    80001b38:	4481                	li	s1,0
    80001b3a:	b7e9                	j	80001b04 <proc_pagetable+0x4c>

0000000080001b3c <proc_freepagetable>:
void proc_freepagetable(pagetable_t pagetable, uint64 sz) {
    80001b3c:	1101                	addi	sp,sp,-32
    80001b3e:	ec06                	sd	ra,24(sp)
    80001b40:	e822                	sd	s0,16(sp)
    80001b42:	e426                	sd	s1,8(sp)
    80001b44:	e04a                	sd	s2,0(sp)
    80001b46:	1000                	addi	s0,sp,32
    80001b48:	84aa                	mv	s1,a0
    80001b4a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b4c:	4681                	li	a3,0
    80001b4e:	4605                	li	a2,1
    80001b50:	040005b7          	lui	a1,0x4000
    80001b54:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b56:	05b2                	slli	a1,a1,0xc
    80001b58:	e62ff0ef          	jal	800011ba <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b5c:	4681                	li	a3,0
    80001b5e:	4605                	li	a2,1
    80001b60:	020005b7          	lui	a1,0x2000
    80001b64:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001b66:	05b6                	slli	a1,a1,0xd
    80001b68:	8526                	mv	a0,s1
    80001b6a:	e50ff0ef          	jal	800011ba <uvmunmap>
  uvmfree(pagetable, sz);
    80001b6e:	85ca                	mv	a1,s2
    80001b70:	8526                	mv	a0,s1
    80001b72:	81dff0ef          	jal	8000138e <uvmfree>
}
    80001b76:	60e2                	ld	ra,24(sp)
    80001b78:	6442                	ld	s0,16(sp)
    80001b7a:	64a2                	ld	s1,8(sp)
    80001b7c:	6902                	ld	s2,0(sp)
    80001b7e:	6105                	addi	sp,sp,32
    80001b80:	8082                	ret

0000000080001b82 <freeproc>:
static void freeproc(struct proc *p) {
    80001b82:	1101                	addi	sp,sp,-32
    80001b84:	ec06                	sd	ra,24(sp)
    80001b86:	e822                	sd	s0,16(sp)
    80001b88:	e426                	sd	s1,8(sp)
    80001b8a:	1000                	addi	s0,sp,32
    80001b8c:	84aa                	mv	s1,a0
  if (p->trapframe) kfree((void *)p->trapframe);
    80001b8e:	7128                	ld	a0,96(a0)
    80001b90:	c119                	beqz	a0,80001b96 <freeproc+0x14>
    80001b92:	e8bfe0ef          	jal	80000a1c <kfree>
  p->trapframe = 0;
    80001b96:	0604b023          	sd	zero,96(s1)
  if (p->pagetable) proc_freepagetable(p->pagetable, p->sz);
    80001b9a:	6ca8                	ld	a0,88(s1)
    80001b9c:	c501                	beqz	a0,80001ba4 <freeproc+0x22>
    80001b9e:	68ac                	ld	a1,80(s1)
    80001ba0:	f9dff0ef          	jal	80001b3c <proc_freepagetable>
  p->pagetable = 0;
    80001ba4:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001ba8:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001bac:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001bb0:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001bb4:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001bb8:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001bbc:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001bc0:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001bc4:	0204a023          	sw	zero,32(s1)
}
    80001bc8:	60e2                	ld	ra,24(sp)
    80001bca:	6442                	ld	s0,16(sp)
    80001bcc:	64a2                	ld	s1,8(sp)
    80001bce:	6105                	addi	sp,sp,32
    80001bd0:	8082                	ret

0000000080001bd2 <allocproc>:
static struct proc *allocproc(void) {
    80001bd2:	1101                	addi	sp,sp,-32
    80001bd4:	ec06                	sd	ra,24(sp)
    80001bd6:	e822                	sd	s0,16(sp)
    80001bd8:	e426                	sd	s1,8(sp)
    80001bda:	e04a                	sd	s2,0(sp)
    80001bdc:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bde:	00011497          	auipc	s1,0x11
    80001be2:	e3a48493          	addi	s1,s1,-454 # 80012a18 <proc>
    80001be6:	00017917          	auipc	s2,0x17
    80001bea:	a3290913          	addi	s2,s2,-1486 # 80018618 <tickslock>
    acquire(&p->lock);
    80001bee:	8526                	mv	a0,s1
    80001bf0:	fdffe0ef          	jal	80000bce <acquire>
    if (p->state == UNUSED) {
    80001bf4:	509c                	lw	a5,32(s1)
    80001bf6:	cb91                	beqz	a5,80001c0a <allocproc+0x38>
      release(&p->lock);
    80001bf8:	8526                	mv	a0,s1
    80001bfa:	86cff0ef          	jal	80000c66 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001bfe:	17048493          	addi	s1,s1,368
    80001c02:	ff2496e3          	bne	s1,s2,80001bee <allocproc+0x1c>
  return 0;
    80001c06:	4481                	li	s1,0
    80001c08:	a089                	j	80001c4a <allocproc+0x78>
  p->pid = allocpid();
    80001c0a:	dbbff0ef          	jal	800019c4 <allocpid>
    80001c0e:	dc88                	sw	a0,56(s1)
  p->state = USED;
    80001c10:	4785                	li	a5,1
    80001c12:	d09c                	sw	a5,32(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001c14:	eebfe0ef          	jal	80000afe <kalloc>
    80001c18:	892a                	mv	s2,a0
    80001c1a:	f0a8                	sd	a0,96(s1)
    80001c1c:	cd15                	beqz	a0,80001c58 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001c1e:	8526                	mv	a0,s1
    80001c20:	e99ff0ef          	jal	80001ab8 <proc_pagetable>
    80001c24:	892a                	mv	s2,a0
    80001c26:	eca8                	sd	a0,88(s1)
  if (p->pagetable == 0) {
    80001c28:	c121                	beqz	a0,80001c68 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001c2a:	07000613          	li	a2,112
    80001c2e:	4581                	li	a1,0
    80001c30:	06848513          	addi	a0,s1,104
    80001c34:	86eff0ef          	jal	80000ca2 <memset>
  p->context.ra = (uint64)forkret;
    80001c38:	00000797          	auipc	a5,0x0
    80001c3c:	cc678793          	addi	a5,a5,-826 # 800018fe <forkret>
    80001c40:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c42:	64bc                	ld	a5,72(s1)
    80001c44:	6705                	lui	a4,0x1
    80001c46:	97ba                	add	a5,a5,a4
    80001c48:	f8bc                	sd	a5,112(s1)
}
    80001c4a:	8526                	mv	a0,s1
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6902                	ld	s2,0(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret
    freeproc(p);
    80001c58:	8526                	mv	a0,s1
    80001c5a:	f29ff0ef          	jal	80001b82 <freeproc>
    release(&p->lock);
    80001c5e:	8526                	mv	a0,s1
    80001c60:	806ff0ef          	jal	80000c66 <release>
    return 0;
    80001c64:	84ca                	mv	s1,s2
    80001c66:	b7d5                	j	80001c4a <allocproc+0x78>
    freeproc(p);
    80001c68:	8526                	mv	a0,s1
    80001c6a:	f19ff0ef          	jal	80001b82 <freeproc>
    release(&p->lock);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	ff7fe0ef          	jal	80000c66 <release>
    return 0;
    80001c74:	84ca                	mv	s1,s2
    80001c76:	bfd1                	j	80001c4a <allocproc+0x78>

0000000080001c78 <userinit>:
void userinit(void) {
    80001c78:	1101                	addi	sp,sp,-32
    80001c7a:	ec06                	sd	ra,24(sp)
    80001c7c:	e822                	sd	s0,16(sp)
    80001c7e:	e426                	sd	s1,8(sp)
    80001c80:	1000                	addi	s0,sp,32
  p = allocproc();
    80001c82:	f51ff0ef          	jal	80001bd2 <allocproc>
    80001c86:	84aa                	mv	s1,a0
  initproc = p;
    80001c88:	00009797          	auipc	a5,0x9
    80001c8c:	84a7bc23          	sd	a0,-1960(a5) # 8000a4e0 <initproc>
  p->nice = 20;
    80001c90:	47d1                	li	a5,20
    80001c92:	cd5c                	sw	a5,28(a0)
  p->cwd = namei("/");
    80001c94:	00005517          	auipc	a0,0x5
    80001c98:	57450513          	addi	a0,a0,1396 # 80007208 <etext+0x208>
    80001c9c:	719010ef          	jal	80003bb4 <namei>
    80001ca0:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001ca4:	478d                	li	a5,3
    80001ca6:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001ca8:	8526                	mv	a0,s1
    80001caa:	fbdfe0ef          	jal	80000c66 <release>
}
    80001cae:	60e2                	ld	ra,24(sp)
    80001cb0:	6442                	ld	s0,16(sp)
    80001cb2:	64a2                	ld	s1,8(sp)
    80001cb4:	6105                	addi	sp,sp,32
    80001cb6:	8082                	ret

0000000080001cb8 <growproc>:
int growproc(int n) {
    80001cb8:	1101                	addi	sp,sp,-32
    80001cba:	ec06                	sd	ra,24(sp)
    80001cbc:	e822                	sd	s0,16(sp)
    80001cbe:	e426                	sd	s1,8(sp)
    80001cc0:	e04a                	sd	s2,0(sp)
    80001cc2:	1000                	addi	s0,sp,32
    80001cc4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001cc6:	c09ff0ef          	jal	800018ce <myproc>
    80001cca:	84aa                	mv	s1,a0
  sz = p->sz;
    80001ccc:	692c                	ld	a1,80(a0)
  if (n > 0) {
    80001cce:	01204c63          	bgtz	s2,80001ce6 <growproc+0x2e>
  } else if (n < 0) {
    80001cd2:	02094463          	bltz	s2,80001cfa <growproc+0x42>
  p->sz = sz;
    80001cd6:	e8ac                	sd	a1,80(s1)
  return 0;
    80001cd8:	4501                	li	a0,0
}
    80001cda:	60e2                	ld	ra,24(sp)
    80001cdc:	6442                	ld	s0,16(sp)
    80001cde:	64a2                	ld	s1,8(sp)
    80001ce0:	6902                	ld	s2,0(sp)
    80001ce2:	6105                	addi	sp,sp,32
    80001ce4:	8082                	ret
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001ce6:	4691                	li	a3,4
    80001ce8:	00b90633          	add	a2,s2,a1
    80001cec:	6d28                	ld	a0,88(a0)
    80001cee:	d9aff0ef          	jal	80001288 <uvmalloc>
    80001cf2:	85aa                	mv	a1,a0
    80001cf4:	f16d                	bnez	a0,80001cd6 <growproc+0x1e>
      return -1;
    80001cf6:	557d                	li	a0,-1
    80001cf8:	b7cd                	j	80001cda <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001cfa:	00b90633          	add	a2,s2,a1
    80001cfe:	6d28                	ld	a0,88(a0)
    80001d00:	d44ff0ef          	jal	80001244 <uvmdealloc>
    80001d04:	85aa                	mv	a1,a0
    80001d06:	bfc1                	j	80001cd6 <growproc+0x1e>

0000000080001d08 <kfork>:
int kfork(void) {
    80001d08:	7139                	addi	sp,sp,-64
    80001d0a:	fc06                	sd	ra,56(sp)
    80001d0c:	f822                	sd	s0,48(sp)
    80001d0e:	f04a                	sd	s2,32(sp)
    80001d10:	e456                	sd	s5,8(sp)
    80001d12:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001d14:	bbbff0ef          	jal	800018ce <myproc>
    80001d18:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001d1a:	eb9ff0ef          	jal	80001bd2 <allocproc>
    80001d1e:	0e050f63          	beqz	a0,80001e1c <kfork+0x114>
    80001d22:	ec4e                	sd	s3,24(sp)
    80001d24:	89aa                	mv	s3,a0
  np->tracemask = p->tracemask;
    80001d26:	018aa783          	lw	a5,24(s5)
    80001d2a:	cd1c                	sw	a5,24(a0)
  np->nice = 20;
    80001d2c:	47d1                	li	a5,20
    80001d2e:	cd5c                	sw	a5,28(a0)
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001d30:	050ab603          	ld	a2,80(s5)
    80001d34:	6d2c                	ld	a1,88(a0)
    80001d36:	058ab503          	ld	a0,88(s5)
    80001d3a:	e86ff0ef          	jal	800013c0 <uvmcopy>
    80001d3e:	04054a63          	bltz	a0,80001d92 <kfork+0x8a>
    80001d42:	f426                	sd	s1,40(sp)
    80001d44:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001d46:	050ab783          	ld	a5,80(s5)
    80001d4a:	04f9b823          	sd	a5,80(s3)
  *(np->trapframe) = *(p->trapframe);
    80001d4e:	060ab683          	ld	a3,96(s5)
    80001d52:	87b6                	mv	a5,a3
    80001d54:	0609b703          	ld	a4,96(s3)
    80001d58:	12068693          	addi	a3,a3,288
    80001d5c:	0007b803          	ld	a6,0(a5)
    80001d60:	6788                	ld	a0,8(a5)
    80001d62:	6b8c                	ld	a1,16(a5)
    80001d64:	6f90                	ld	a2,24(a5)
    80001d66:	01073023          	sd	a6,0(a4) # 1000 <_entry-0x7ffff000>
    80001d6a:	e708                	sd	a0,8(a4)
    80001d6c:	eb0c                	sd	a1,16(a4)
    80001d6e:	ef10                	sd	a2,24(a4)
    80001d70:	02078793          	addi	a5,a5,32
    80001d74:	02070713          	addi	a4,a4,32
    80001d78:	fed792e3          	bne	a5,a3,80001d5c <kfork+0x54>
  np->trapframe->a0 = 0;
    80001d7c:	0609b783          	ld	a5,96(s3)
    80001d80:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001d84:	0d8a8493          	addi	s1,s5,216
    80001d88:	0d898913          	addi	s2,s3,216
    80001d8c:	158a8a13          	addi	s4,s5,344
    80001d90:	a831                	j	80001dac <kfork+0xa4>
    freeproc(np);
    80001d92:	854e                	mv	a0,s3
    80001d94:	defff0ef          	jal	80001b82 <freeproc>
    release(&np->lock);
    80001d98:	854e                	mv	a0,s3
    80001d9a:	ecdfe0ef          	jal	80000c66 <release>
    return -1;
    80001d9e:	597d                	li	s2,-1
    80001da0:	69e2                	ld	s3,24(sp)
    80001da2:	a0b5                	j	80001e0e <kfork+0x106>
  for (i = 0; i < NOFILE; i++)
    80001da4:	04a1                	addi	s1,s1,8
    80001da6:	0921                	addi	s2,s2,8
    80001da8:	01448963          	beq	s1,s4,80001dba <kfork+0xb2>
    if (p->ofile[i]) np->ofile[i] = filedup(p->ofile[i]);
    80001dac:	6088                	ld	a0,0(s1)
    80001dae:	d97d                	beqz	a0,80001da4 <kfork+0x9c>
    80001db0:	39e020ef          	jal	8000414e <filedup>
    80001db4:	00a93023          	sd	a0,0(s2)
    80001db8:	b7f5                	j	80001da4 <kfork+0x9c>
  np->cwd = idup(p->cwd);
    80001dba:	158ab503          	ld	a0,344(s5)
    80001dbe:	5aa010ef          	jal	80003368 <idup>
    80001dc2:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001dc6:	4641                	li	a2,16
    80001dc8:	160a8593          	addi	a1,s5,352
    80001dcc:	16098513          	addi	a0,s3,352
    80001dd0:	810ff0ef          	jal	80000de0 <safestrcpy>
  pid = np->pid;
    80001dd4:	0389a903          	lw	s2,56(s3)
  release(&np->lock);
    80001dd8:	854e                	mv	a0,s3
    80001dda:	e8dfe0ef          	jal	80000c66 <release>
  acquire(&wait_lock);
    80001dde:	00011497          	auipc	s1,0x11
    80001de2:	82248493          	addi	s1,s1,-2014 # 80012600 <wait_lock>
    80001de6:	8526                	mv	a0,s1
    80001de8:	de7fe0ef          	jal	80000bce <acquire>
  np->parent = p;
    80001dec:	0559b023          	sd	s5,64(s3)
  release(&wait_lock);
    80001df0:	8526                	mv	a0,s1
    80001df2:	e75fe0ef          	jal	80000c66 <release>
  acquire(&np->lock);
    80001df6:	854e                	mv	a0,s3
    80001df8:	dd7fe0ef          	jal	80000bce <acquire>
  np->state = RUNNABLE;
    80001dfc:	478d                	li	a5,3
    80001dfe:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001e02:	854e                	mv	a0,s3
    80001e04:	e63fe0ef          	jal	80000c66 <release>
  return pid;
    80001e08:	74a2                	ld	s1,40(sp)
    80001e0a:	69e2                	ld	s3,24(sp)
    80001e0c:	6a42                	ld	s4,16(sp)
}
    80001e0e:	854a                	mv	a0,s2
    80001e10:	70e2                	ld	ra,56(sp)
    80001e12:	7442                	ld	s0,48(sp)
    80001e14:	7902                	ld	s2,32(sp)
    80001e16:	6aa2                	ld	s5,8(sp)
    80001e18:	6121                	addi	sp,sp,64
    80001e1a:	8082                	ret
    return -1;
    80001e1c:	597d                	li	s2,-1
    80001e1e:	bfc5                	j	80001e0e <kfork+0x106>

0000000080001e20 <scheduler>:
void scheduler(void) {
    80001e20:	715d                	addi	sp,sp,-80
    80001e22:	e486                	sd	ra,72(sp)
    80001e24:	e0a2                	sd	s0,64(sp)
    80001e26:	fc26                	sd	s1,56(sp)
    80001e28:	f84a                	sd	s2,48(sp)
    80001e2a:	f44e                	sd	s3,40(sp)
    80001e2c:	f052                	sd	s4,32(sp)
    80001e2e:	ec56                	sd	s5,24(sp)
    80001e30:	e85a                	sd	s6,16(sp)
    80001e32:	e45e                	sd	s7,8(sp)
    80001e34:	e062                	sd	s8,0(sp)
    80001e36:	0880                	addi	s0,sp,80
    80001e38:	8792                	mv	a5,tp
  int id = r_tp();
    80001e3a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e3c:	00779b13          	slli	s6,a5,0x7
    80001e40:	00010717          	auipc	a4,0x10
    80001e44:	7a870713          	addi	a4,a4,1960 # 800125e8 <pid_lock>
    80001e48:	975a                	add	a4,a4,s6
    80001e4a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001e4e:	00010717          	auipc	a4,0x10
    80001e52:	7d270713          	addi	a4,a4,2002 # 80012620 <cpus+0x8>
    80001e56:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001e58:	4c11                	li	s8,4
        c->proc = p;
    80001e5a:	079e                	slli	a5,a5,0x7
    80001e5c:	00010a17          	auipc	s4,0x10
    80001e60:	78ca0a13          	addi	s4,s4,1932 # 800125e8 <pid_lock>
    80001e64:	9a3e                	add	s4,s4,a5
        found = 1;
    80001e66:	4b85                	li	s7,1
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e68:	00016997          	auipc	s3,0x16
    80001e6c:	7b098993          	addi	s3,s3,1968 # 80018618 <tickslock>
    80001e70:	a83d                	j	80001eae <scheduler+0x8e>
      release(&p->lock);
    80001e72:	8526                	mv	a0,s1
    80001e74:	df3fe0ef          	jal	80000c66 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001e78:	17048493          	addi	s1,s1,368
    80001e7c:	03348563          	beq	s1,s3,80001ea6 <scheduler+0x86>
      acquire(&p->lock);
    80001e80:	8526                	mv	a0,s1
    80001e82:	d4dfe0ef          	jal	80000bce <acquire>
      if (p->state == RUNNABLE) {
    80001e86:	509c                	lw	a5,32(s1)
    80001e88:	ff2795e3          	bne	a5,s2,80001e72 <scheduler+0x52>
        p->state = RUNNING;
    80001e8c:	0384a023          	sw	s8,32(s1)
        c->proc = p;
    80001e90:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001e94:	06848593          	addi	a1,s1,104
    80001e98:	855a                	mv	a0,s6
    80001e9a:	5b2000ef          	jal	8000244c <swtch>
        c->proc = 0;
    80001e9e:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001ea2:	8ade                	mv	s5,s7
    80001ea4:	b7f9                	j	80001e72 <scheduler+0x52>
    if (found == 0) {
    80001ea6:	000a9463          	bnez	s5,80001eae <scheduler+0x8e>
      asm volatile("wfi");
    80001eaa:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eb2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eb6:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ebe:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ec0:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001ec4:	4a81                	li	s5,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001ec6:	00011497          	auipc	s1,0x11
    80001eca:	b5248493          	addi	s1,s1,-1198 # 80012a18 <proc>
      if (p->state == RUNNABLE) {
    80001ece:	490d                	li	s2,3
    80001ed0:	bf45                	j	80001e80 <scheduler+0x60>

0000000080001ed2 <sched>:
void sched(void) {
    80001ed2:	7179                	addi	sp,sp,-48
    80001ed4:	f406                	sd	ra,40(sp)
    80001ed6:	f022                	sd	s0,32(sp)
    80001ed8:	ec26                	sd	s1,24(sp)
    80001eda:	e84a                	sd	s2,16(sp)
    80001edc:	e44e                	sd	s3,8(sp)
    80001ede:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001ee0:	9efff0ef          	jal	800018ce <myproc>
    80001ee4:	84aa                	mv	s1,a0
  if (!holding(&p->lock)) panic("sched p->lock");
    80001ee6:	c7ffe0ef          	jal	80000b64 <holding>
    80001eea:	c92d                	beqz	a0,80001f5c <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001eec:	8792                	mv	a5,tp
  if (mycpu()->noff != 1) panic("sched locks");
    80001eee:	2781                	sext.w	a5,a5
    80001ef0:	079e                	slli	a5,a5,0x7
    80001ef2:	00010717          	auipc	a4,0x10
    80001ef6:	6f670713          	addi	a4,a4,1782 # 800125e8 <pid_lock>
    80001efa:	97ba                	add	a5,a5,a4
    80001efc:	0a87a703          	lw	a4,168(a5)
    80001f00:	4785                	li	a5,1
    80001f02:	06f71363          	bne	a4,a5,80001f68 <sched+0x96>
  if (p->state == RUNNING) panic("sched RUNNING");
    80001f06:	5098                	lw	a4,32(s1)
    80001f08:	4791                	li	a5,4
    80001f0a:	06f70563          	beq	a4,a5,80001f74 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f0e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f12:	8b89                	andi	a5,a5,2
  if (intr_get()) panic("sched interruptible");
    80001f14:	e7b5                	bnez	a5,80001f80 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f16:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001f18:	00010917          	auipc	s2,0x10
    80001f1c:	6d090913          	addi	s2,s2,1744 # 800125e8 <pid_lock>
    80001f20:	2781                	sext.w	a5,a5
    80001f22:	079e                	slli	a5,a5,0x7
    80001f24:	97ca                	add	a5,a5,s2
    80001f26:	0ac7a983          	lw	s3,172(a5)
    80001f2a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001f2c:	2781                	sext.w	a5,a5
    80001f2e:	079e                	slli	a5,a5,0x7
    80001f30:	00010597          	auipc	a1,0x10
    80001f34:	6f058593          	addi	a1,a1,1776 # 80012620 <cpus+0x8>
    80001f38:	95be                	add	a1,a1,a5
    80001f3a:	06848513          	addi	a0,s1,104
    80001f3e:	50e000ef          	jal	8000244c <swtch>
    80001f42:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001f44:	2781                	sext.w	a5,a5
    80001f46:	079e                	slli	a5,a5,0x7
    80001f48:	993e                	add	s2,s2,a5
    80001f4a:	0b392623          	sw	s3,172(s2)
}
    80001f4e:	70a2                	ld	ra,40(sp)
    80001f50:	7402                	ld	s0,32(sp)
    80001f52:	64e2                	ld	s1,24(sp)
    80001f54:	6942                	ld	s2,16(sp)
    80001f56:	69a2                	ld	s3,8(sp)
    80001f58:	6145                	addi	sp,sp,48
    80001f5a:	8082                	ret
  if (!holding(&p->lock)) panic("sched p->lock");
    80001f5c:	00005517          	auipc	a0,0x5
    80001f60:	2b450513          	addi	a0,a0,692 # 80007210 <etext+0x210>
    80001f64:	87dfe0ef          	jal	800007e0 <panic>
  if (mycpu()->noff != 1) panic("sched locks");
    80001f68:	00005517          	auipc	a0,0x5
    80001f6c:	2b850513          	addi	a0,a0,696 # 80007220 <etext+0x220>
    80001f70:	871fe0ef          	jal	800007e0 <panic>
  if (p->state == RUNNING) panic("sched RUNNING");
    80001f74:	00005517          	auipc	a0,0x5
    80001f78:	2bc50513          	addi	a0,a0,700 # 80007230 <etext+0x230>
    80001f7c:	865fe0ef          	jal	800007e0 <panic>
  if (intr_get()) panic("sched interruptible");
    80001f80:	00005517          	auipc	a0,0x5
    80001f84:	2c050513          	addi	a0,a0,704 # 80007240 <etext+0x240>
    80001f88:	859fe0ef          	jal	800007e0 <panic>

0000000080001f8c <yield>:
void yield(void) {
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f96:	939ff0ef          	jal	800018ce <myproc>
    80001f9a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f9c:	c33fe0ef          	jal	80000bce <acquire>
  p->state = RUNNABLE;
    80001fa0:	478d                	li	a5,3
    80001fa2:	d09c                	sw	a5,32(s1)
  sched();
    80001fa4:	f2fff0ef          	jal	80001ed2 <sched>
  release(&p->lock);
    80001fa8:	8526                	mv	a0,s1
    80001faa:	cbdfe0ef          	jal	80000c66 <release>
}
    80001fae:	60e2                	ld	ra,24(sp)
    80001fb0:	6442                	ld	s0,16(sp)
    80001fb2:	64a2                	ld	s1,8(sp)
    80001fb4:	6105                	addi	sp,sp,32
    80001fb6:	8082                	ret

0000000080001fb8 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void sleep(void *chan, struct spinlock *lk) {
    80001fb8:	7179                	addi	sp,sp,-48
    80001fba:	f406                	sd	ra,40(sp)
    80001fbc:	f022                	sd	s0,32(sp)
    80001fbe:	ec26                	sd	s1,24(sp)
    80001fc0:	e84a                	sd	s2,16(sp)
    80001fc2:	e44e                	sd	s3,8(sp)
    80001fc4:	1800                	addi	s0,sp,48
    80001fc6:	89aa                	mv	s3,a0
    80001fc8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001fca:	905ff0ef          	jal	800018ce <myproc>
    80001fce:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  // DOC: sleeplock1
    80001fd0:	bfffe0ef          	jal	80000bce <acquire>
  release(lk);
    80001fd4:	854a                	mv	a0,s2
    80001fd6:	c91fe0ef          	jal	80000c66 <release>

  // Go to sleep.
  p->chan = chan;
    80001fda:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80001fde:	4789                	li	a5,2
    80001fe0:	d09c                	sw	a5,32(s1)

  sched();
    80001fe2:	ef1ff0ef          	jal	80001ed2 <sched>

  // Tidy up.
  p->chan = 0;
    80001fe6:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001fea:	8526                	mv	a0,s1
    80001fec:	c7bfe0ef          	jal	80000c66 <release>
  acquire(lk);
    80001ff0:	854a                	mv	a0,s2
    80001ff2:	bddfe0ef          	jal	80000bce <acquire>
}
    80001ff6:	70a2                	ld	ra,40(sp)
    80001ff8:	7402                	ld	s0,32(sp)
    80001ffa:	64e2                	ld	s1,24(sp)
    80001ffc:	6942                	ld	s2,16(sp)
    80001ffe:	69a2                	ld	s3,8(sp)
    80002000:	6145                	addi	sp,sp,48
    80002002:	8082                	ret

0000000080002004 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void wakeup(void *chan) {
    80002004:	7139                	addi	sp,sp,-64
    80002006:	fc06                	sd	ra,56(sp)
    80002008:	f822                	sd	s0,48(sp)
    8000200a:	f426                	sd	s1,40(sp)
    8000200c:	f04a                	sd	s2,32(sp)
    8000200e:	ec4e                	sd	s3,24(sp)
    80002010:	e852                	sd	s4,16(sp)
    80002012:	e456                	sd	s5,8(sp)
    80002014:	0080                	addi	s0,sp,64
    80002016:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002018:	00011497          	auipc	s1,0x11
    8000201c:	a0048493          	addi	s1,s1,-1536 # 80012a18 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80002020:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002022:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80002024:	00016917          	auipc	s2,0x16
    80002028:	5f490913          	addi	s2,s2,1524 # 80018618 <tickslock>
    8000202c:	a801                	j	8000203c <wakeup+0x38>
      }
      release(&p->lock);
    8000202e:	8526                	mv	a0,s1
    80002030:	c37fe0ef          	jal	80000c66 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002034:	17048493          	addi	s1,s1,368
    80002038:	03248263          	beq	s1,s2,8000205c <wakeup+0x58>
    if (p != myproc()) {
    8000203c:	893ff0ef          	jal	800018ce <myproc>
    80002040:	fea48ae3          	beq	s1,a0,80002034 <wakeup+0x30>
      acquire(&p->lock);
    80002044:	8526                	mv	a0,s1
    80002046:	b89fe0ef          	jal	80000bce <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    8000204a:	509c                	lw	a5,32(s1)
    8000204c:	ff3791e3          	bne	a5,s3,8000202e <wakeup+0x2a>
    80002050:	749c                	ld	a5,40(s1)
    80002052:	fd479ee3          	bne	a5,s4,8000202e <wakeup+0x2a>
        p->state = RUNNABLE;
    80002056:	0354a023          	sw	s5,32(s1)
    8000205a:	bfd1                	j	8000202e <wakeup+0x2a>
    }
  }
}
    8000205c:	70e2                	ld	ra,56(sp)
    8000205e:	7442                	ld	s0,48(sp)
    80002060:	74a2                	ld	s1,40(sp)
    80002062:	7902                	ld	s2,32(sp)
    80002064:	69e2                	ld	s3,24(sp)
    80002066:	6a42                	ld	s4,16(sp)
    80002068:	6aa2                	ld	s5,8(sp)
    8000206a:	6121                	addi	sp,sp,64
    8000206c:	8082                	ret

000000008000206e <reparent>:
void reparent(struct proc *p) {
    8000206e:	7179                	addi	sp,sp,-48
    80002070:	f406                	sd	ra,40(sp)
    80002072:	f022                	sd	s0,32(sp)
    80002074:	ec26                	sd	s1,24(sp)
    80002076:	e84a                	sd	s2,16(sp)
    80002078:	e44e                	sd	s3,8(sp)
    8000207a:	e052                	sd	s4,0(sp)
    8000207c:	1800                	addi	s0,sp,48
    8000207e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002080:	00011497          	auipc	s1,0x11
    80002084:	99848493          	addi	s1,s1,-1640 # 80012a18 <proc>
      pp->parent = initproc;
    80002088:	00008a17          	auipc	s4,0x8
    8000208c:	458a0a13          	addi	s4,s4,1112 # 8000a4e0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002090:	00016997          	auipc	s3,0x16
    80002094:	58898993          	addi	s3,s3,1416 # 80018618 <tickslock>
    80002098:	a029                	j	800020a2 <reparent+0x34>
    8000209a:	17048493          	addi	s1,s1,368
    8000209e:	01348b63          	beq	s1,s3,800020b4 <reparent+0x46>
    if (pp->parent == p) {
    800020a2:	60bc                	ld	a5,64(s1)
    800020a4:	ff279be3          	bne	a5,s2,8000209a <reparent+0x2c>
      pp->parent = initproc;
    800020a8:	000a3503          	ld	a0,0(s4)
    800020ac:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    800020ae:	f57ff0ef          	jal	80002004 <wakeup>
    800020b2:	b7e5                	j	8000209a <reparent+0x2c>
}
    800020b4:	70a2                	ld	ra,40(sp)
    800020b6:	7402                	ld	s0,32(sp)
    800020b8:	64e2                	ld	s1,24(sp)
    800020ba:	6942                	ld	s2,16(sp)
    800020bc:	69a2                	ld	s3,8(sp)
    800020be:	6a02                	ld	s4,0(sp)
    800020c0:	6145                	addi	sp,sp,48
    800020c2:	8082                	ret

00000000800020c4 <kexit>:
void kexit(int status) {
    800020c4:	7179                	addi	sp,sp,-48
    800020c6:	f406                	sd	ra,40(sp)
    800020c8:	f022                	sd	s0,32(sp)
    800020ca:	ec26                	sd	s1,24(sp)
    800020cc:	e84a                	sd	s2,16(sp)
    800020ce:	e44e                	sd	s3,8(sp)
    800020d0:	e052                	sd	s4,0(sp)
    800020d2:	1800                	addi	s0,sp,48
    800020d4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020d6:	ff8ff0ef          	jal	800018ce <myproc>
    800020da:	89aa                	mv	s3,a0
  if (p == initproc) panic("init exiting");
    800020dc:	00008797          	auipc	a5,0x8
    800020e0:	4047b783          	ld	a5,1028(a5) # 8000a4e0 <initproc>
    800020e4:	0d850493          	addi	s1,a0,216
    800020e8:	15850913          	addi	s2,a0,344
    800020ec:	00a79f63          	bne	a5,a0,8000210a <kexit+0x46>
    800020f0:	00005517          	auipc	a0,0x5
    800020f4:	16850513          	addi	a0,a0,360 # 80007258 <etext+0x258>
    800020f8:	ee8fe0ef          	jal	800007e0 <panic>
      fileclose(f);
    800020fc:	098020ef          	jal	80004194 <fileclose>
      p->ofile[fd] = 0;
    80002100:	0004b023          	sd	zero,0(s1)
  for (int fd = 0; fd < NOFILE; fd++) {
    80002104:	04a1                	addi	s1,s1,8
    80002106:	01248563          	beq	s1,s2,80002110 <kexit+0x4c>
    if (p->ofile[fd]) {
    8000210a:	6088                	ld	a0,0(s1)
    8000210c:	f965                	bnez	a0,800020fc <kexit+0x38>
    8000210e:	bfdd                	j	80002104 <kexit+0x40>
  begin_op();
    80002110:	479010ef          	jal	80003d88 <begin_op>
  iput(p->cwd);
    80002114:	1589b503          	ld	a0,344(s3)
    80002118:	408010ef          	jal	80003520 <iput>
  end_op();
    8000211c:	4d7010ef          	jal	80003df2 <end_op>
  p->cwd = 0;
    80002120:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80002124:	00010497          	auipc	s1,0x10
    80002128:	4dc48493          	addi	s1,s1,1244 # 80012600 <wait_lock>
    8000212c:	8526                	mv	a0,s1
    8000212e:	aa1fe0ef          	jal	80000bce <acquire>
  reparent(p);
    80002132:	854e                	mv	a0,s3
    80002134:	f3bff0ef          	jal	8000206e <reparent>
  wakeup(p->parent);
    80002138:	0409b503          	ld	a0,64(s3)
    8000213c:	ec9ff0ef          	jal	80002004 <wakeup>
  acquire(&p->lock);
    80002140:	854e                	mv	a0,s3
    80002142:	a8dfe0ef          	jal	80000bce <acquire>
  p->xstate = status;
    80002146:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000214a:	4795                	li	a5,5
    8000214c:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80002150:	8526                	mv	a0,s1
    80002152:	b15fe0ef          	jal	80000c66 <release>
  sched();
    80002156:	d7dff0ef          	jal	80001ed2 <sched>
  panic("zombie exit");
    8000215a:	00005517          	auipc	a0,0x5
    8000215e:	10e50513          	addi	a0,a0,270 # 80007268 <etext+0x268>
    80002162:	e7efe0ef          	jal	800007e0 <panic>

0000000080002166 <kkill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kkill(int pid) {
    80002166:	7179                	addi	sp,sp,-48
    80002168:	f406                	sd	ra,40(sp)
    8000216a:	f022                	sd	s0,32(sp)
    8000216c:	ec26                	sd	s1,24(sp)
    8000216e:	e84a                	sd	s2,16(sp)
    80002170:	e44e                	sd	s3,8(sp)
    80002172:	1800                	addi	s0,sp,48
    80002174:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002176:	00011497          	auipc	s1,0x11
    8000217a:	8a248493          	addi	s1,s1,-1886 # 80012a18 <proc>
    8000217e:	00016997          	auipc	s3,0x16
    80002182:	49a98993          	addi	s3,s3,1178 # 80018618 <tickslock>
    acquire(&p->lock);
    80002186:	8526                	mv	a0,s1
    80002188:	a47fe0ef          	jal	80000bce <acquire>
    if (p->pid == pid) {
    8000218c:	5c9c                	lw	a5,56(s1)
    8000218e:	01278b63          	beq	a5,s2,800021a4 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002192:	8526                	mv	a0,s1
    80002194:	ad3fe0ef          	jal	80000c66 <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002198:	17048493          	addi	s1,s1,368
    8000219c:	ff3495e3          	bne	s1,s3,80002186 <kkill+0x20>
  }
  return -1;
    800021a0:	557d                	li	a0,-1
    800021a2:	a819                	j	800021b8 <kkill+0x52>
      p->killed = 1;
    800021a4:	4785                	li	a5,1
    800021a6:	d89c                	sw	a5,48(s1)
      if (p->state == SLEEPING) {
    800021a8:	5098                	lw	a4,32(s1)
    800021aa:	4789                	li	a5,2
    800021ac:	00f70d63          	beq	a4,a5,800021c6 <kkill+0x60>
      release(&p->lock);
    800021b0:	8526                	mv	a0,s1
    800021b2:	ab5fe0ef          	jal	80000c66 <release>
      return 0;
    800021b6:	4501                	li	a0,0
}
    800021b8:	70a2                	ld	ra,40(sp)
    800021ba:	7402                	ld	s0,32(sp)
    800021bc:	64e2                	ld	s1,24(sp)
    800021be:	6942                	ld	s2,16(sp)
    800021c0:	69a2                	ld	s3,8(sp)
    800021c2:	6145                	addi	sp,sp,48
    800021c4:	8082                	ret
        p->state = RUNNABLE;
    800021c6:	478d                	li	a5,3
    800021c8:	d09c                	sw	a5,32(s1)
    800021ca:	b7dd                	j	800021b0 <kkill+0x4a>

00000000800021cc <setkilled>:

void setkilled(struct proc *p) {
    800021cc:	1101                	addi	sp,sp,-32
    800021ce:	ec06                	sd	ra,24(sp)
    800021d0:	e822                	sd	s0,16(sp)
    800021d2:	e426                	sd	s1,8(sp)
    800021d4:	1000                	addi	s0,sp,32
    800021d6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021d8:	9f7fe0ef          	jal	80000bce <acquire>
  p->killed = 1;
    800021dc:	4785                	li	a5,1
    800021de:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    800021e0:	8526                	mv	a0,s1
    800021e2:	a85fe0ef          	jal	80000c66 <release>
}
    800021e6:	60e2                	ld	ra,24(sp)
    800021e8:	6442                	ld	s0,16(sp)
    800021ea:	64a2                	ld	s1,8(sp)
    800021ec:	6105                	addi	sp,sp,32
    800021ee:	8082                	ret

00000000800021f0 <killed>:

int killed(struct proc *p) {
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	e426                	sd	s1,8(sp)
    800021f8:	e04a                	sd	s2,0(sp)
    800021fa:	1000                	addi	s0,sp,32
    800021fc:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800021fe:	9d1fe0ef          	jal	80000bce <acquire>
  k = p->killed;
    80002202:	0304a903          	lw	s2,48(s1)
  release(&p->lock);
    80002206:	8526                	mv	a0,s1
    80002208:	a5ffe0ef          	jal	80000c66 <release>
  return k;
}
    8000220c:	854a                	mv	a0,s2
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6902                	ld	s2,0(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret

000000008000221a <kwait>:
int kwait(uint64 addr) {
    8000221a:	715d                	addi	sp,sp,-80
    8000221c:	e486                	sd	ra,72(sp)
    8000221e:	e0a2                	sd	s0,64(sp)
    80002220:	fc26                	sd	s1,56(sp)
    80002222:	f84a                	sd	s2,48(sp)
    80002224:	f44e                	sd	s3,40(sp)
    80002226:	f052                	sd	s4,32(sp)
    80002228:	ec56                	sd	s5,24(sp)
    8000222a:	e85a                	sd	s6,16(sp)
    8000222c:	e45e                	sd	s7,8(sp)
    8000222e:	e062                	sd	s8,0(sp)
    80002230:	0880                	addi	s0,sp,80
    80002232:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002234:	e9aff0ef          	jal	800018ce <myproc>
    80002238:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000223a:	00010517          	auipc	a0,0x10
    8000223e:	3c650513          	addi	a0,a0,966 # 80012600 <wait_lock>
    80002242:	98dfe0ef          	jal	80000bce <acquire>
    havekids = 0;
    80002246:	4b81                	li	s7,0
        if (pp->state == ZOMBIE) {
    80002248:	4a15                	li	s4,5
        havekids = 1;
    8000224a:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000224c:	00016997          	auipc	s3,0x16
    80002250:	3cc98993          	addi	s3,s3,972 # 80018618 <tickslock>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    80002254:	00010c17          	auipc	s8,0x10
    80002258:	3acc0c13          	addi	s8,s8,940 # 80012600 <wait_lock>
    8000225c:	a871                	j	800022f8 <kwait+0xde>
          pid = pp->pid;
    8000225e:	0384a983          	lw	s3,56(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002262:	000b0c63          	beqz	s6,8000227a <kwait+0x60>
    80002266:	4691                	li	a3,4
    80002268:	03448613          	addi	a2,s1,52
    8000226c:	85da                	mv	a1,s6
    8000226e:	05893503          	ld	a0,88(s2)
    80002272:	b70ff0ef          	jal	800015e2 <copyout>
    80002276:	02054b63          	bltz	a0,800022ac <kwait+0x92>
          freeproc(pp);
    8000227a:	8526                	mv	a0,s1
    8000227c:	907ff0ef          	jal	80001b82 <freeproc>
          release(&pp->lock);
    80002280:	8526                	mv	a0,s1
    80002282:	9e5fe0ef          	jal	80000c66 <release>
          release(&wait_lock);
    80002286:	00010517          	auipc	a0,0x10
    8000228a:	37a50513          	addi	a0,a0,890 # 80012600 <wait_lock>
    8000228e:	9d9fe0ef          	jal	80000c66 <release>
}
    80002292:	854e                	mv	a0,s3
    80002294:	60a6                	ld	ra,72(sp)
    80002296:	6406                	ld	s0,64(sp)
    80002298:	74e2                	ld	s1,56(sp)
    8000229a:	7942                	ld	s2,48(sp)
    8000229c:	79a2                	ld	s3,40(sp)
    8000229e:	7a02                	ld	s4,32(sp)
    800022a0:	6ae2                	ld	s5,24(sp)
    800022a2:	6b42                	ld	s6,16(sp)
    800022a4:	6ba2                	ld	s7,8(sp)
    800022a6:	6c02                	ld	s8,0(sp)
    800022a8:	6161                	addi	sp,sp,80
    800022aa:	8082                	ret
            release(&pp->lock);
    800022ac:	8526                	mv	a0,s1
    800022ae:	9b9fe0ef          	jal	80000c66 <release>
            release(&wait_lock);
    800022b2:	00010517          	auipc	a0,0x10
    800022b6:	34e50513          	addi	a0,a0,846 # 80012600 <wait_lock>
    800022ba:	9adfe0ef          	jal	80000c66 <release>
            return -1;
    800022be:	59fd                	li	s3,-1
    800022c0:	bfc9                	j	80002292 <kwait+0x78>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800022c2:	17048493          	addi	s1,s1,368
    800022c6:	03348063          	beq	s1,s3,800022e6 <kwait+0xcc>
      if (pp->parent == p) {
    800022ca:	60bc                	ld	a5,64(s1)
    800022cc:	ff279be3          	bne	a5,s2,800022c2 <kwait+0xa8>
        acquire(&pp->lock);
    800022d0:	8526                	mv	a0,s1
    800022d2:	8fdfe0ef          	jal	80000bce <acquire>
        if (pp->state == ZOMBIE) {
    800022d6:	509c                	lw	a5,32(s1)
    800022d8:	f94783e3          	beq	a5,s4,8000225e <kwait+0x44>
        release(&pp->lock);
    800022dc:	8526                	mv	a0,s1
    800022de:	989fe0ef          	jal	80000c66 <release>
        havekids = 1;
    800022e2:	8756                	mv	a4,s5
    800022e4:	bff9                	j	800022c2 <kwait+0xa8>
    if (!havekids || killed(p)) {
    800022e6:	cf19                	beqz	a4,80002304 <kwait+0xea>
    800022e8:	854a                	mv	a0,s2
    800022ea:	f07ff0ef          	jal	800021f0 <killed>
    800022ee:	e919                	bnez	a0,80002304 <kwait+0xea>
    sleep(p, &wait_lock);  // DOC: wait-sleep
    800022f0:	85e2                	mv	a1,s8
    800022f2:	854a                	mv	a0,s2
    800022f4:	cc5ff0ef          	jal	80001fb8 <sleep>
    havekids = 0;
    800022f8:	875e                	mv	a4,s7
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800022fa:	00010497          	auipc	s1,0x10
    800022fe:	71e48493          	addi	s1,s1,1822 # 80012a18 <proc>
    80002302:	b7e1                	j	800022ca <kwait+0xb0>
      release(&wait_lock);
    80002304:	00010517          	auipc	a0,0x10
    80002308:	2fc50513          	addi	a0,a0,764 # 80012600 <wait_lock>
    8000230c:	95bfe0ef          	jal	80000c66 <release>
      return -1;
    80002310:	59fd                	li	s3,-1
    80002312:	b741                	j	80002292 <kwait+0x78>

0000000080002314 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len) {
    80002314:	7179                	addi	sp,sp,-48
    80002316:	f406                	sd	ra,40(sp)
    80002318:	f022                	sd	s0,32(sp)
    8000231a:	ec26                	sd	s1,24(sp)
    8000231c:	e84a                	sd	s2,16(sp)
    8000231e:	e44e                	sd	s3,8(sp)
    80002320:	e052                	sd	s4,0(sp)
    80002322:	1800                	addi	s0,sp,48
    80002324:	84aa                	mv	s1,a0
    80002326:	892e                	mv	s2,a1
    80002328:	89b2                	mv	s3,a2
    8000232a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000232c:	da2ff0ef          	jal	800018ce <myproc>
  if (user_dst) {
    80002330:	cc99                	beqz	s1,8000234e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002332:	86d2                	mv	a3,s4
    80002334:	864e                	mv	a2,s3
    80002336:	85ca                	mv	a1,s2
    80002338:	6d28                	ld	a0,88(a0)
    8000233a:	aa8ff0ef          	jal	800015e2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000233e:	70a2                	ld	ra,40(sp)
    80002340:	7402                	ld	s0,32(sp)
    80002342:	64e2                	ld	s1,24(sp)
    80002344:	6942                	ld	s2,16(sp)
    80002346:	69a2                	ld	s3,8(sp)
    80002348:	6a02                	ld	s4,0(sp)
    8000234a:	6145                	addi	sp,sp,48
    8000234c:	8082                	ret
    memmove((char *)dst, src, len);
    8000234e:	000a061b          	sext.w	a2,s4
    80002352:	85ce                	mv	a1,s3
    80002354:	854a                	mv	a0,s2
    80002356:	9a9fe0ef          	jal	80000cfe <memmove>
    return 0;
    8000235a:	8526                	mv	a0,s1
    8000235c:	b7cd                	j	8000233e <either_copyout+0x2a>

000000008000235e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len) {
    8000235e:	7179                	addi	sp,sp,-48
    80002360:	f406                	sd	ra,40(sp)
    80002362:	f022                	sd	s0,32(sp)
    80002364:	ec26                	sd	s1,24(sp)
    80002366:	e84a                	sd	s2,16(sp)
    80002368:	e44e                	sd	s3,8(sp)
    8000236a:	e052                	sd	s4,0(sp)
    8000236c:	1800                	addi	s0,sp,48
    8000236e:	892a                	mv	s2,a0
    80002370:	84ae                	mv	s1,a1
    80002372:	89b2                	mv	s3,a2
    80002374:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002376:	d58ff0ef          	jal	800018ce <myproc>
  if (user_src) {
    8000237a:	cc99                	beqz	s1,80002398 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000237c:	86d2                	mv	a3,s4
    8000237e:	864e                	mv	a2,s3
    80002380:	85ca                	mv	a1,s2
    80002382:	6d28                	ld	a0,88(a0)
    80002384:	b42ff0ef          	jal	800016c6 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    80002388:	70a2                	ld	ra,40(sp)
    8000238a:	7402                	ld	s0,32(sp)
    8000238c:	64e2                	ld	s1,24(sp)
    8000238e:	6942                	ld	s2,16(sp)
    80002390:	69a2                	ld	s3,8(sp)
    80002392:	6a02                	ld	s4,0(sp)
    80002394:	6145                	addi	sp,sp,48
    80002396:	8082                	ret
    memmove(dst, (char *)src, len);
    80002398:	000a061b          	sext.w	a2,s4
    8000239c:	85ce                	mv	a1,s3
    8000239e:	854a                	mv	a0,s2
    800023a0:	95ffe0ef          	jal	80000cfe <memmove>
    return 0;
    800023a4:	8526                	mv	a0,s1
    800023a6:	b7cd                	j	80002388 <either_copyin+0x2a>

00000000800023a8 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
    800023a8:	715d                	addi	sp,sp,-80
    800023aa:	e486                	sd	ra,72(sp)
    800023ac:	e0a2                	sd	s0,64(sp)
    800023ae:	fc26                	sd	s1,56(sp)
    800023b0:	f84a                	sd	s2,48(sp)
    800023b2:	f44e                	sd	s3,40(sp)
    800023b4:	f052                	sd	s4,32(sp)
    800023b6:	ec56                	sd	s5,24(sp)
    800023b8:	e85a                	sd	s6,16(sp)
    800023ba:	e45e                	sd	s7,8(sp)
    800023bc:	0880                	addi	s0,sp,80
      [UNUSED] "unused",   [USED] "used",      [SLEEPING] "sleep ",
      [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
    800023be:	00005517          	auipc	a0,0x5
    800023c2:	e4250513          	addi	a0,a0,-446 # 80007200 <etext+0x200>
    800023c6:	934fe0ef          	jal	800004fa <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    800023ca:	00010497          	auipc	s1,0x10
    800023ce:	7ae48493          	addi	s1,s1,1966 # 80012b78 <proc+0x160>
    800023d2:	00016917          	auipc	s2,0x16
    800023d6:	3a690913          	addi	s2,s2,934 # 80018778 <bcache+0x148>
    if (p->state == UNUSED) continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023da:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800023dc:	00005997          	auipc	s3,0x5
    800023e0:	e9c98993          	addi	s3,s3,-356 # 80007278 <etext+0x278>
    printf("%d %s %s", p->pid, state, p->name);
    800023e4:	00005a97          	auipc	s5,0x5
    800023e8:	e9ca8a93          	addi	s5,s5,-356 # 80007280 <etext+0x280>
    printf("\n");
    800023ec:	00005a17          	auipc	s4,0x5
    800023f0:	e14a0a13          	addi	s4,s4,-492 # 80007200 <etext+0x200>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800023f4:	00005b97          	auipc	s7,0x5
    800023f8:	484b8b93          	addi	s7,s7,1156 # 80007878 <states.0>
    800023fc:	a829                	j	80002416 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800023fe:	ed86a583          	lw	a1,-296(a3)
    80002402:	8556                	mv	a0,s5
    80002404:	8f6fe0ef          	jal	800004fa <printf>
    printf("\n");
    80002408:	8552                	mv	a0,s4
    8000240a:	8f0fe0ef          	jal	800004fa <printf>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000240e:	17048493          	addi	s1,s1,368
    80002412:	03248263          	beq	s1,s2,80002436 <procdump+0x8e>
    if (p->state == UNUSED) continue;
    80002416:	86a6                	mv	a3,s1
    80002418:	ec04a783          	lw	a5,-320(s1)
    8000241c:	dbed                	beqz	a5,8000240e <procdump+0x66>
      state = "???";
    8000241e:	864e                	mv	a2,s3
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002420:	fcfb6fe3          	bltu	s6,a5,800023fe <procdump+0x56>
    80002424:	02079713          	slli	a4,a5,0x20
    80002428:	01d75793          	srli	a5,a4,0x1d
    8000242c:	97de                	add	a5,a5,s7
    8000242e:	6390                	ld	a2,0(a5)
    80002430:	f679                	bnez	a2,800023fe <procdump+0x56>
      state = "???";
    80002432:	864e                	mv	a2,s3
    80002434:	b7e9                	j	800023fe <procdump+0x56>
  }
}
    80002436:	60a6                	ld	ra,72(sp)
    80002438:	6406                	ld	s0,64(sp)
    8000243a:	74e2                	ld	s1,56(sp)
    8000243c:	7942                	ld	s2,48(sp)
    8000243e:	79a2                	ld	s3,40(sp)
    80002440:	7a02                	ld	s4,32(sp)
    80002442:	6ae2                	ld	s5,24(sp)
    80002444:	6b42                	ld	s6,16(sp)
    80002446:	6ba2                	ld	s7,8(sp)
    80002448:	6161                	addi	sp,sp,80
    8000244a:	8082                	ret

000000008000244c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000244c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002450:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002454:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80002456:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002458:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000245c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002460:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002464:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002468:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000246c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002470:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002474:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002478:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000247c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002480:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002484:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80002488:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000248a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000248c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80002490:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80002494:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80002498:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000249c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800024a0:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800024a4:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800024a8:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800024ac:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800024b0:	0685bd83          	ld	s11,104(a1)
        
        ret
    800024b4:	8082                	ret

00000000800024b6 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800024b6:	1141                	addi	sp,sp,-16
    800024b8:	e406                	sd	ra,8(sp)
    800024ba:	e022                	sd	s0,0(sp)
    800024bc:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800024be:	00005597          	auipc	a1,0x5
    800024c2:	e0258593          	addi	a1,a1,-510 # 800072c0 <etext+0x2c0>
    800024c6:	00016517          	auipc	a0,0x16
    800024ca:	15250513          	addi	a0,a0,338 # 80018618 <tickslock>
    800024ce:	e80fe0ef          	jal	80000b4e <initlock>
}
    800024d2:	60a2                	ld	ra,8(sp)
    800024d4:	6402                	ld	s0,0(sp)
    800024d6:	0141                	addi	sp,sp,16
    800024d8:	8082                	ret

00000000800024da <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800024da:	1141                	addi	sp,sp,-16
    800024dc:	e422                	sd	s0,8(sp)
    800024de:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800024e0:	00003797          	auipc	a5,0x3
    800024e4:	02078793          	addi	a5,a5,32 # 80005500 <kernelvec>
    800024e8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800024ec:	6422                	ld	s0,8(sp)
    800024ee:	0141                	addi	sp,sp,16
    800024f0:	8082                	ret

00000000800024f2 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800024f2:	1141                	addi	sp,sp,-16
    800024f4:	e406                	sd	ra,8(sp)
    800024f6:	e022                	sd	s0,0(sp)
    800024f8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800024fa:	bd4ff0ef          	jal	800018ce <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800024fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002502:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002504:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002508:	04000737          	lui	a4,0x4000
    8000250c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    8000250e:	0732                	slli	a4,a4,0xc
    80002510:	00004797          	auipc	a5,0x4
    80002514:	af078793          	addi	a5,a5,-1296 # 80006000 <_trampoline>
    80002518:	00004697          	auipc	a3,0x4
    8000251c:	ae868693          	addi	a3,a3,-1304 # 80006000 <_trampoline>
    80002520:	8f95                	sub	a5,a5,a3
    80002522:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002524:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002528:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000252a:	18002773          	csrr	a4,satp
    8000252e:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002530:	7138                	ld	a4,96(a0)
    80002532:	653c                	ld	a5,72(a0)
    80002534:	6685                	lui	a3,0x1
    80002536:	97b6                	add	a5,a5,a3
    80002538:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000253a:	713c                	ld	a5,96(a0)
    8000253c:	00000717          	auipc	a4,0x0
    80002540:	0f870713          	addi	a4,a4,248 # 80002634 <usertrap>
    80002544:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002546:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002548:	8712                	mv	a4,tp
    8000254a:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000254c:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002550:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002554:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002558:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000255c:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000255e:	6f9c                	ld	a5,24(a5)
    80002560:	14179073          	csrw	sepc,a5
}
    80002564:	60a2                	ld	ra,8(sp)
    80002566:	6402                	ld	s0,0(sp)
    80002568:	0141                	addi	sp,sp,16
    8000256a:	8082                	ret

000000008000256c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000256c:	1101                	addi	sp,sp,-32
    8000256e:	ec06                	sd	ra,24(sp)
    80002570:	e822                	sd	s0,16(sp)
    80002572:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002574:	b2eff0ef          	jal	800018a2 <cpuid>
    80002578:	cd11                	beqz	a0,80002594 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000257a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000257e:	000f4737          	lui	a4,0xf4
    80002582:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002586:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002588:	14d79073          	csrw	stimecmp,a5
}
    8000258c:	60e2                	ld	ra,24(sp)
    8000258e:	6442                	ld	s0,16(sp)
    80002590:	6105                	addi	sp,sp,32
    80002592:	8082                	ret
    80002594:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002596:	00016497          	auipc	s1,0x16
    8000259a:	08248493          	addi	s1,s1,130 # 80018618 <tickslock>
    8000259e:	8526                	mv	a0,s1
    800025a0:	e2efe0ef          	jal	80000bce <acquire>
    ticks++;
    800025a4:	00008517          	auipc	a0,0x8
    800025a8:	f4450513          	addi	a0,a0,-188 # 8000a4e8 <ticks>
    800025ac:	411c                	lw	a5,0(a0)
    800025ae:	2785                	addiw	a5,a5,1
    800025b0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800025b2:	a53ff0ef          	jal	80002004 <wakeup>
    release(&tickslock);
    800025b6:	8526                	mv	a0,s1
    800025b8:	eaefe0ef          	jal	80000c66 <release>
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	bf75                	j	8000257a <clockintr+0xe>

00000000800025c0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800025c0:	1101                	addi	sp,sp,-32
    800025c2:	ec06                	sd	ra,24(sp)
    800025c4:	e822                	sd	s0,16(sp)
    800025c6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800025c8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800025cc:	57fd                	li	a5,-1
    800025ce:	17fe                	slli	a5,a5,0x3f
    800025d0:	07a5                	addi	a5,a5,9
    800025d2:	00f70c63          	beq	a4,a5,800025ea <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800025d6:	57fd                	li	a5,-1
    800025d8:	17fe                	slli	a5,a5,0x3f
    800025da:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800025dc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800025de:	04f70763          	beq	a4,a5,8000262c <devintr+0x6c>
  }
}
    800025e2:	60e2                	ld	ra,24(sp)
    800025e4:	6442                	ld	s0,16(sp)
    800025e6:	6105                	addi	sp,sp,32
    800025e8:	8082                	ret
    800025ea:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800025ec:	7c1020ef          	jal	800055ac <plic_claim>
    800025f0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800025f2:	47a9                	li	a5,10
    800025f4:	00f50963          	beq	a0,a5,80002606 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800025f8:	4785                	li	a5,1
    800025fa:	00f50963          	beq	a0,a5,8000260c <devintr+0x4c>
    return 1;
    800025fe:	4505                	li	a0,1
    } else if(irq){
    80002600:	e889                	bnez	s1,80002612 <devintr+0x52>
    80002602:	64a2                	ld	s1,8(sp)
    80002604:	bff9                	j	800025e2 <devintr+0x22>
      uartintr();
    80002606:	baafe0ef          	jal	800009b0 <uartintr>
    if(irq)
    8000260a:	a819                	j	80002620 <devintr+0x60>
      virtio_disk_intr();
    8000260c:	466030ef          	jal	80005a72 <virtio_disk_intr>
    if(irq)
    80002610:	a801                	j	80002620 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002612:	85a6                	mv	a1,s1
    80002614:	00005517          	auipc	a0,0x5
    80002618:	cb450513          	addi	a0,a0,-844 # 800072c8 <etext+0x2c8>
    8000261c:	edffd0ef          	jal	800004fa <printf>
      plic_complete(irq);
    80002620:	8526                	mv	a0,s1
    80002622:	7ab020ef          	jal	800055cc <plic_complete>
    return 1;
    80002626:	4505                	li	a0,1
    80002628:	64a2                	ld	s1,8(sp)
    8000262a:	bf65                	j	800025e2 <devintr+0x22>
    clockintr();
    8000262c:	f41ff0ef          	jal	8000256c <clockintr>
    return 2;
    80002630:	4509                	li	a0,2
    80002632:	bf45                	j	800025e2 <devintr+0x22>

0000000080002634 <usertrap>:
{
    80002634:	1101                	addi	sp,sp,-32
    80002636:	ec06                	sd	ra,24(sp)
    80002638:	e822                	sd	s0,16(sp)
    8000263a:	e426                	sd	s1,8(sp)
    8000263c:	e04a                	sd	s2,0(sp)
    8000263e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002640:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002644:	1007f793          	andi	a5,a5,256
    80002648:	eba5                	bnez	a5,800026b8 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000264a:	00003797          	auipc	a5,0x3
    8000264e:	eb678793          	addi	a5,a5,-330 # 80005500 <kernelvec>
    80002652:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002656:	a78ff0ef          	jal	800018ce <myproc>
    8000265a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000265c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000265e:	14102773          	csrr	a4,sepc
    80002662:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002664:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002668:	47a1                	li	a5,8
    8000266a:	04f70d63          	beq	a4,a5,800026c4 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    8000266e:	f53ff0ef          	jal	800025c0 <devintr>
    80002672:	892a                	mv	s2,a0
    80002674:	e945                	bnez	a0,80002724 <usertrap+0xf0>
    80002676:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    8000267a:	47bd                	li	a5,15
    8000267c:	08f70863          	beq	a4,a5,8000270c <usertrap+0xd8>
    80002680:	14202773          	csrr	a4,scause
    80002684:	47b5                	li	a5,13
    80002686:	08f70363          	beq	a4,a5,8000270c <usertrap+0xd8>
    8000268a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000268e:	5c90                	lw	a2,56(s1)
    80002690:	00005517          	auipc	a0,0x5
    80002694:	c7850513          	addi	a0,a0,-904 # 80007308 <etext+0x308>
    80002698:	e63fd0ef          	jal	800004fa <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000269c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800026a0:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800026a4:	00005517          	auipc	a0,0x5
    800026a8:	c9450513          	addi	a0,a0,-876 # 80007338 <etext+0x338>
    800026ac:	e4ffd0ef          	jal	800004fa <printf>
    setkilled(p);
    800026b0:	8526                	mv	a0,s1
    800026b2:	b1bff0ef          	jal	800021cc <setkilled>
    800026b6:	a035                	j	800026e2 <usertrap+0xae>
    panic("usertrap: not from user mode");
    800026b8:	00005517          	auipc	a0,0x5
    800026bc:	c3050513          	addi	a0,a0,-976 # 800072e8 <etext+0x2e8>
    800026c0:	920fe0ef          	jal	800007e0 <panic>
    if(killed(p))
    800026c4:	b2dff0ef          	jal	800021f0 <killed>
    800026c8:	ed15                	bnez	a0,80002704 <usertrap+0xd0>
    p->trapframe->epc += 4;
    800026ca:	70b8                	ld	a4,96(s1)
    800026cc:	6f1c                	ld	a5,24(a4)
    800026ce:	0791                	addi	a5,a5,4
    800026d0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026d2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800026d6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026da:	10079073          	csrw	sstatus,a5
    syscall();
    800026de:	246000ef          	jal	80002924 <syscall>
  if(killed(p))
    800026e2:	8526                	mv	a0,s1
    800026e4:	b0dff0ef          	jal	800021f0 <killed>
    800026e8:	e139                	bnez	a0,8000272e <usertrap+0xfa>
  prepare_return();
    800026ea:	e09ff0ef          	jal	800024f2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800026ee:	6ca8                	ld	a0,88(s1)
    800026f0:	8131                	srli	a0,a0,0xc
    800026f2:	57fd                	li	a5,-1
    800026f4:	17fe                	slli	a5,a5,0x3f
    800026f6:	8d5d                	or	a0,a0,a5
}
    800026f8:	60e2                	ld	ra,24(sp)
    800026fa:	6442                	ld	s0,16(sp)
    800026fc:	64a2                	ld	s1,8(sp)
    800026fe:	6902                	ld	s2,0(sp)
    80002700:	6105                	addi	sp,sp,32
    80002702:	8082                	ret
      kexit(-1);
    80002704:	557d                	li	a0,-1
    80002706:	9bfff0ef          	jal	800020c4 <kexit>
    8000270a:	b7c1                	j	800026ca <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000270c:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002710:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002714:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002716:	00163613          	seqz	a2,a2
    8000271a:	6ca8                	ld	a0,88(s1)
    8000271c:	e45fe0ef          	jal	80001560 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002720:	f169                	bnez	a0,800026e2 <usertrap+0xae>
    80002722:	b7a5                	j	8000268a <usertrap+0x56>
  if(killed(p))
    80002724:	8526                	mv	a0,s1
    80002726:	acbff0ef          	jal	800021f0 <killed>
    8000272a:	c511                	beqz	a0,80002736 <usertrap+0x102>
    8000272c:	a011                	j	80002730 <usertrap+0xfc>
    8000272e:	4901                	li	s2,0
    kexit(-1);
    80002730:	557d                	li	a0,-1
    80002732:	993ff0ef          	jal	800020c4 <kexit>
  if(which_dev == 2)
    80002736:	4789                	li	a5,2
    80002738:	faf919e3          	bne	s2,a5,800026ea <usertrap+0xb6>
    yield();
    8000273c:	851ff0ef          	jal	80001f8c <yield>
    80002740:	b76d                	j	800026ea <usertrap+0xb6>

0000000080002742 <kerneltrap>:
{
    80002742:	7179                	addi	sp,sp,-48
    80002744:	f406                	sd	ra,40(sp)
    80002746:	f022                	sd	s0,32(sp)
    80002748:	ec26                	sd	s1,24(sp)
    8000274a:	e84a                	sd	s2,16(sp)
    8000274c:	e44e                	sd	s3,8(sp)
    8000274e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002750:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002754:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002758:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    8000275c:	1004f793          	andi	a5,s1,256
    80002760:	c795                	beqz	a5,8000278c <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002762:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002766:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002768:	eb85                	bnez	a5,80002798 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    8000276a:	e57ff0ef          	jal	800025c0 <devintr>
    8000276e:	c91d                	beqz	a0,800027a4 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002770:	4789                	li	a5,2
    80002772:	04f50a63          	beq	a0,a5,800027c6 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002776:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000277a:	10049073          	csrw	sstatus,s1
}
    8000277e:	70a2                	ld	ra,40(sp)
    80002780:	7402                	ld	s0,32(sp)
    80002782:	64e2                	ld	s1,24(sp)
    80002784:	6942                	ld	s2,16(sp)
    80002786:	69a2                	ld	s3,8(sp)
    80002788:	6145                	addi	sp,sp,48
    8000278a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    8000278c:	00005517          	auipc	a0,0x5
    80002790:	bd450513          	addi	a0,a0,-1068 # 80007360 <etext+0x360>
    80002794:	84cfe0ef          	jal	800007e0 <panic>
    panic("kerneltrap: interrupts enabled");
    80002798:	00005517          	auipc	a0,0x5
    8000279c:	bf050513          	addi	a0,a0,-1040 # 80007388 <etext+0x388>
    800027a0:	840fe0ef          	jal	800007e0 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800027a4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800027a8:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800027ac:	85ce                	mv	a1,s3
    800027ae:	00005517          	auipc	a0,0x5
    800027b2:	bfa50513          	addi	a0,a0,-1030 # 800073a8 <etext+0x3a8>
    800027b6:	d45fd0ef          	jal	800004fa <printf>
    panic("kerneltrap");
    800027ba:	00005517          	auipc	a0,0x5
    800027be:	c1650513          	addi	a0,a0,-1002 # 800073d0 <etext+0x3d0>
    800027c2:	81efe0ef          	jal	800007e0 <panic>
  if(which_dev == 2 && myproc() != 0)
    800027c6:	908ff0ef          	jal	800018ce <myproc>
    800027ca:	d555                	beqz	a0,80002776 <kerneltrap+0x34>
    yield();
    800027cc:	fc0ff0ef          	jal	80001f8c <yield>
    800027d0:	b75d                	j	80002776 <kerneltrap+0x34>

00000000800027d2 <argraw>:
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
  return strlen(buf);
}

static uint64 argraw(int n) {
    800027d2:	1101                	addi	sp,sp,-32
    800027d4:	ec06                	sd	ra,24(sp)
    800027d6:	e822                	sd	s0,16(sp)
    800027d8:	e426                	sd	s1,8(sp)
    800027da:	1000                	addi	s0,sp,32
    800027dc:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800027de:	8f0ff0ef          	jal	800018ce <myproc>
  switch (n) {
    800027e2:	4795                	li	a5,5
    800027e4:	0497e163          	bltu	a5,s1,80002826 <argraw+0x54>
    800027e8:	048a                	slli	s1,s1,0x2
    800027ea:	00005717          	auipc	a4,0x5
    800027ee:	0be70713          	addi	a4,a4,190 # 800078a8 <states.0+0x30>
    800027f2:	94ba                	add	s1,s1,a4
    800027f4:	409c                	lw	a5,0(s1)
    800027f6:	97ba                	add	a5,a5,a4
    800027f8:	8782                	jr	a5
    case 0:
      return p->trapframe->a0;
    800027fa:	713c                	ld	a5,96(a0)
    800027fc:	7ba8                	ld	a0,112(a5)
    case 5:
      return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800027fe:	60e2                	ld	ra,24(sp)
    80002800:	6442                	ld	s0,16(sp)
    80002802:	64a2                	ld	s1,8(sp)
    80002804:	6105                	addi	sp,sp,32
    80002806:	8082                	ret
      return p->trapframe->a1;
    80002808:	713c                	ld	a5,96(a0)
    8000280a:	7fa8                	ld	a0,120(a5)
    8000280c:	bfcd                	j	800027fe <argraw+0x2c>
      return p->trapframe->a2;
    8000280e:	713c                	ld	a5,96(a0)
    80002810:	63c8                	ld	a0,128(a5)
    80002812:	b7f5                	j	800027fe <argraw+0x2c>
      return p->trapframe->a3;
    80002814:	713c                	ld	a5,96(a0)
    80002816:	67c8                	ld	a0,136(a5)
    80002818:	b7dd                	j	800027fe <argraw+0x2c>
      return p->trapframe->a4;
    8000281a:	713c                	ld	a5,96(a0)
    8000281c:	6bc8                	ld	a0,144(a5)
    8000281e:	b7c5                	j	800027fe <argraw+0x2c>
      return p->trapframe->a5;
    80002820:	713c                	ld	a5,96(a0)
    80002822:	6fc8                	ld	a0,152(a5)
    80002824:	bfe9                	j	800027fe <argraw+0x2c>
  panic("argraw");
    80002826:	00005517          	auipc	a0,0x5
    8000282a:	bba50513          	addi	a0,a0,-1094 # 800073e0 <etext+0x3e0>
    8000282e:	fb3fd0ef          	jal	800007e0 <panic>

0000000080002832 <fetchaddr>:
int fetchaddr(uint64 addr, uint64 *ip) {
    80002832:	1101                	addi	sp,sp,-32
    80002834:	ec06                	sd	ra,24(sp)
    80002836:	e822                	sd	s0,16(sp)
    80002838:	e426                	sd	s1,8(sp)
    8000283a:	e04a                	sd	s2,0(sp)
    8000283c:	1000                	addi	s0,sp,32
    8000283e:	84aa                	mv	s1,a0
    80002840:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002842:	88cff0ef          	jal	800018ce <myproc>
  if (addr >= p->sz ||
    80002846:	693c                	ld	a5,80(a0)
    80002848:	02f4f663          	bgeu	s1,a5,80002874 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz)  // both tests needed, in case of overflow
    8000284c:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002850:	02e7e463          	bltu	a5,a4,80002878 <fetchaddr+0x46>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0) return -1;
    80002854:	46a1                	li	a3,8
    80002856:	8626                	mv	a2,s1
    80002858:	85ca                	mv	a1,s2
    8000285a:	6d28                	ld	a0,88(a0)
    8000285c:	e6bfe0ef          	jal	800016c6 <copyin>
    80002860:	00a03533          	snez	a0,a0
    80002864:	40a00533          	neg	a0,a0
}
    80002868:	60e2                	ld	ra,24(sp)
    8000286a:	6442                	ld	s0,16(sp)
    8000286c:	64a2                	ld	s1,8(sp)
    8000286e:	6902                	ld	s2,0(sp)
    80002870:	6105                	addi	sp,sp,32
    80002872:	8082                	ret
    return -1;
    80002874:	557d                	li	a0,-1
    80002876:	bfcd                	j	80002868 <fetchaddr+0x36>
    80002878:	557d                	li	a0,-1
    8000287a:	b7fd                	j	80002868 <fetchaddr+0x36>

000000008000287c <fetchstr>:
int fetchstr(uint64 addr, char *buf, int max) {
    8000287c:	7179                	addi	sp,sp,-48
    8000287e:	f406                	sd	ra,40(sp)
    80002880:	f022                	sd	s0,32(sp)
    80002882:	ec26                	sd	s1,24(sp)
    80002884:	e84a                	sd	s2,16(sp)
    80002886:	e44e                	sd	s3,8(sp)
    80002888:	1800                	addi	s0,sp,48
    8000288a:	892a                	mv	s2,a0
    8000288c:	84ae                	mv	s1,a1
    8000288e:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002890:	83eff0ef          	jal	800018ce <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    80002894:	86ce                	mv	a3,s3
    80002896:	864a                	mv	a2,s2
    80002898:	85a6                	mv	a1,s1
    8000289a:	6d28                	ld	a0,88(a0)
    8000289c:	bedfe0ef          	jal	80001488 <copyinstr>
    800028a0:	00054c63          	bltz	a0,800028b8 <fetchstr+0x3c>
  return strlen(buf);
    800028a4:	8526                	mv	a0,s1
    800028a6:	d6cfe0ef          	jal	80000e12 <strlen>
}
    800028aa:	70a2                	ld	ra,40(sp)
    800028ac:	7402                	ld	s0,32(sp)
    800028ae:	64e2                	ld	s1,24(sp)
    800028b0:	6942                	ld	s2,16(sp)
    800028b2:	69a2                	ld	s3,8(sp)
    800028b4:	6145                	addi	sp,sp,48
    800028b6:	8082                	ret
  if (copyinstr(p->pagetable, buf, addr, max) < 0) return -1;
    800028b8:	557d                	li	a0,-1
    800028ba:	bfc5                	j	800028aa <fetchstr+0x2e>

00000000800028bc <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip) { *ip = argraw(n); }
    800028bc:	1101                	addi	sp,sp,-32
    800028be:	ec06                	sd	ra,24(sp)
    800028c0:	e822                	sd	s0,16(sp)
    800028c2:	e426                	sd	s1,8(sp)
    800028c4:	1000                	addi	s0,sp,32
    800028c6:	84ae                	mv	s1,a1
    800028c8:	f0bff0ef          	jal	800027d2 <argraw>
    800028cc:	c088                	sw	a0,0(s1)
    800028ce:	60e2                	ld	ra,24(sp)
    800028d0:	6442                	ld	s0,16(sp)
    800028d2:	64a2                	ld	s1,8(sp)
    800028d4:	6105                	addi	sp,sp,32
    800028d6:	8082                	ret

00000000800028d8 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip) { *ip = argraw(n); }
    800028d8:	1101                	addi	sp,sp,-32
    800028da:	ec06                	sd	ra,24(sp)
    800028dc:	e822                	sd	s0,16(sp)
    800028de:	e426                	sd	s1,8(sp)
    800028e0:	1000                	addi	s0,sp,32
    800028e2:	84ae                	mv	s1,a1
    800028e4:	eefff0ef          	jal	800027d2 <argraw>
    800028e8:	e088                	sd	a0,0(s1)
    800028ea:	60e2                	ld	ra,24(sp)
    800028ec:	6442                	ld	s0,16(sp)
    800028ee:	64a2                	ld	s1,8(sp)
    800028f0:	6105                	addi	sp,sp,32
    800028f2:	8082                	ret

00000000800028f4 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max) {
    800028f4:	7179                	addi	sp,sp,-48
    800028f6:	f406                	sd	ra,40(sp)
    800028f8:	f022                	sd	s0,32(sp)
    800028fa:	ec26                	sd	s1,24(sp)
    800028fc:	e84a                	sd	s2,16(sp)
    800028fe:	1800                	addi	s0,sp,48
    80002900:	84ae                	mv	s1,a1
    80002902:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002904:	fd840593          	addi	a1,s0,-40
    80002908:	fd1ff0ef          	jal	800028d8 <argaddr>
  return fetchstr(addr, buf, max);
    8000290c:	864a                	mv	a2,s2
    8000290e:	85a6                	mv	a1,s1
    80002910:	fd843503          	ld	a0,-40(s0)
    80002914:	f69ff0ef          	jal	8000287c <fetchstr>
}
    80002918:	70a2                	ld	ra,40(sp)
    8000291a:	7402                	ld	s0,32(sp)
    8000291c:	64e2                	ld	s1,24(sp)
    8000291e:	6942                	ld	s2,16(sp)
    80002920:	6145                	addi	sp,sp,48
    80002922:	8082                	ret

0000000080002924 <syscall>:
                               [SYS_mkdir] "mkdir",
                               [SYS_close] "close",
                               [SYS_get_priority] "get_priority",
                               [SYS_set_priority] "set_priority"};

void syscall(void) {
    80002924:	7179                	addi	sp,sp,-48
    80002926:	f406                	sd	ra,40(sp)
    80002928:	f022                	sd	s0,32(sp)
    8000292a:	ec26                	sd	s1,24(sp)
    8000292c:	e84a                	sd	s2,16(sp)
    8000292e:	e44e                	sd	s3,8(sp)
    80002930:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002932:	f9dfe0ef          	jal	800018ce <myproc>
    80002936:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002938:	06053903          	ld	s2,96(a0)
    8000293c:	0a893783          	ld	a5,168(s2)
    80002940:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002944:	37fd                	addiw	a5,a5,-1
    80002946:	4761                	li	a4,24
    80002948:	04f76463          	bltu	a4,a5,80002990 <syscall+0x6c>
    8000294c:	00399713          	slli	a4,s3,0x3
    80002950:	00005797          	auipc	a5,0x5
    80002954:	f7078793          	addi	a5,a5,-144 # 800078c0 <syscalls>
    80002958:	97ba                	add	a5,a5,a4
    8000295a:	639c                	ld	a5,0(a5)
    8000295c:	cb95                	beqz	a5,80002990 <syscall+0x6c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000295e:	9782                	jalr	a5
    80002960:	06a93823          	sd	a0,112(s2)

    // Check to see if syscall num is in the tracemask
    // If so print PID: syscall name -> return value

    if (p->tracemask & (1 << num)) {  // check if syscall 'num' is enabled
    80002964:	4c9c                	lw	a5,24(s1)
    80002966:	4137d7bb          	sraw	a5,a5,s3
    8000296a:	8b85                	andi	a5,a5,1
    8000296c:	cf9d                	beqz	a5,800029aa <syscall+0x86>
      extern char *syscallnames[];    // syscall name lookup table
      printf("%d: syscall %s -> %d\n", p->pid, syscallnames[num],
             (int)p->trapframe->a0);
    8000296e:	70b8                	ld	a4,96(s1)
      printf("%d: syscall %s -> %d\n", p->pid, syscallnames[num],
    80002970:	098e                	slli	s3,s3,0x3
    80002972:	00005797          	auipc	a5,0x5
    80002976:	f4e78793          	addi	a5,a5,-178 # 800078c0 <syscalls>
    8000297a:	97ce                	add	a5,a5,s3
    8000297c:	5b34                	lw	a3,112(a4)
    8000297e:	6bf0                	ld	a2,208(a5)
    80002980:	5c8c                	lw	a1,56(s1)
    80002982:	00005517          	auipc	a0,0x5
    80002986:	a6650513          	addi	a0,a0,-1434 # 800073e8 <etext+0x3e8>
    8000298a:	b71fd0ef          	jal	800004fa <printf>
    8000298e:	a831                	j	800029aa <syscall+0x86>
    }

  } else {
    printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    80002990:	86ce                	mv	a3,s3
    80002992:	16048613          	addi	a2,s1,352
    80002996:	5c8c                	lw	a1,56(s1)
    80002998:	00005517          	auipc	a0,0x5
    8000299c:	a6850513          	addi	a0,a0,-1432 # 80007400 <etext+0x400>
    800029a0:	b5bfd0ef          	jal	800004fa <printf>
    p->trapframe->a0 = -1;
    800029a4:	70bc                	ld	a5,96(s1)
    800029a6:	577d                	li	a4,-1
    800029a8:	fbb8                	sd	a4,112(a5)
  }
}
    800029aa:	70a2                	ld	ra,40(sp)
    800029ac:	7402                	ld	s0,32(sp)
    800029ae:	64e2                	ld	s1,24(sp)
    800029b0:	6942                	ld	s2,16(sp)
    800029b2:	69a2                	ld	s3,8(sp)
    800029b4:	6145                	addi	sp,sp,48
    800029b6:	8082                	ret

00000000800029b8 <sys_cps>:
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"

uint64 sys_cps(void) {
    800029b8:	1141                	addi	sp,sp,-16
    800029ba:	e406                	sd	ra,8(sp)
    800029bc:	e022                	sd	s0,0(sp)
    800029be:	0800                	addi	s0,sp,16
return cps();
    800029c0:	842ff0ef          	jal	80001a02 <cps>
}
    800029c4:	60a2                	ld	ra,8(sp)
    800029c6:	6402                	ld	s0,0(sp)
    800029c8:	0141                	addi	sp,sp,16
    800029ca:	8082                	ret

00000000800029cc <sys_get_priority>:

uint64 sys_get_priority(void) {
    800029cc:	1101                	addi	sp,sp,-32
    800029ce:	ec06                	sd	ra,24(sp)
    800029d0:	e822                	sd	s0,16(sp)
    800029d2:	1000                	addi	s0,sp,32
  int pid;
  argint(0, &pid);
    800029d4:	fec40593          	addi	a1,s0,-20
    800029d8:	4501                	li	a0,0
    800029da:	ee3ff0ef          	jal	800028bc <argint>
  struct proc *p = getprocbyid(pid);
    800029de:	fec42503          	lw	a0,-20(s0)
    800029e2:	fb5fe0ef          	jal	80001996 <getprocbyid>
  if (p == 0) {
    800029e6:	c511                	beqz	a0,800029f2 <sys_get_priority+0x26>
    return -1;
  } else {
    return p->nice;
    800029e8:	4d48                	lw	a0,28(a0)
  }
}
    800029ea:	60e2                	ld	ra,24(sp)
    800029ec:	6442                	ld	s0,16(sp)
    800029ee:	6105                	addi	sp,sp,32
    800029f0:	8082                	ret
    return -1;
    800029f2:	557d                	li	a0,-1
    800029f4:	bfdd                	j	800029ea <sys_get_priority+0x1e>

00000000800029f6 <sys_set_priority>:

uint64 sys_set_priority(void) {
    800029f6:	1101                	addi	sp,sp,-32
    800029f8:	ec06                	sd	ra,24(sp)
    800029fa:	e822                	sd	s0,16(sp)
    800029fc:	1000                	addi	s0,sp,32
  int pid, priority;
  argint(0, &pid);
    800029fe:	fec40593          	addi	a1,s0,-20
    80002a02:	4501                	li	a0,0
    80002a04:	eb9ff0ef          	jal	800028bc <argint>
  argint(1, &priority);
    80002a08:	fe840593          	addi	a1,s0,-24
    80002a0c:	4505                	li	a0,1
    80002a0e:	eafff0ef          	jal	800028bc <argint>

  if (priority > 39) {
    80002a12:	fe842783          	lw	a5,-24(s0)
    80002a16:	02700713          	li	a4,39
    80002a1a:	02f75363          	bge	a4,a5,80002a40 <sys_set_priority+0x4a>
    priority = 39;
    80002a1e:	02700793          	li	a5,39
    80002a22:	fef42423          	sw	a5,-24(s0)
  }
  if (priority < 0) {
    priority = 0;
  }

  struct proc *p = getprocbyid(pid);
    80002a26:	fec42503          	lw	a0,-20(s0)
    80002a2a:	f6dfe0ef          	jal	80001996 <getprocbyid>
  if (p == 0) {
    80002a2e:	cd11                	beqz	a0,80002a4a <sys_set_priority+0x54>
    return -1;
  } else {
    p->nice = priority;
    80002a30:	fe842783          	lw	a5,-24(s0)
    80002a34:	cd5c                	sw	a5,28(a0)
    return 0;
    80002a36:	4501                	li	a0,0
  }
}
    80002a38:	60e2                	ld	ra,24(sp)
    80002a3a:	6442                	ld	s0,16(sp)
    80002a3c:	6105                	addi	sp,sp,32
    80002a3e:	8082                	ret
  if (priority < 0) {
    80002a40:	fe07d3e3          	bgez	a5,80002a26 <sys_set_priority+0x30>
    priority = 0;
    80002a44:	fe042423          	sw	zero,-24(s0)
    80002a48:	bff9                	j	80002a26 <sys_set_priority+0x30>
    return -1;
    80002a4a:	557d                	li	a0,-1
    80002a4c:	b7f5                	j	80002a38 <sys_set_priority+0x42>

0000000080002a4e <sys_trace>:

uint64 sys_trace(void) {
    80002a4e:	1101                	addi	sp,sp,-32
    80002a50:	ec06                	sd	ra,24(sp)
    80002a52:	e822                	sd	s0,16(sp)
    80002a54:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80002a56:	fec40593          	addi	a1,s0,-20
    80002a5a:	4501                	li	a0,0
    80002a5c:	e61ff0ef          	jal	800028bc <argint>
  myproc()->tracemask = mask;
    80002a60:	e6ffe0ef          	jal	800018ce <myproc>
    80002a64:	fec42783          	lw	a5,-20(s0)
    80002a68:	cd1c                	sw	a5,24(a0)

  return 0;
}
    80002a6a:	4501                	li	a0,0
    80002a6c:	60e2                	ld	ra,24(sp)
    80002a6e:	6442                	ld	s0,16(sp)
    80002a70:	6105                	addi	sp,sp,32
    80002a72:	8082                	ret

0000000080002a74 <sys_exit>:

uint64 sys_exit(void) {
    80002a74:	1101                	addi	sp,sp,-32
    80002a76:	ec06                	sd	ra,24(sp)
    80002a78:	e822                	sd	s0,16(sp)
    80002a7a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002a7c:	fec40593          	addi	a1,s0,-20
    80002a80:	4501                	li	a0,0
    80002a82:	e3bff0ef          	jal	800028bc <argint>
  kexit(n);
    80002a86:	fec42503          	lw	a0,-20(s0)
    80002a8a:	e3aff0ef          	jal	800020c4 <kexit>
  return 0;  // not reached
}
    80002a8e:	4501                	li	a0,0
    80002a90:	60e2                	ld	ra,24(sp)
    80002a92:	6442                	ld	s0,16(sp)
    80002a94:	6105                	addi	sp,sp,32
    80002a96:	8082                	ret

0000000080002a98 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002a98:	1141                	addi	sp,sp,-16
    80002a9a:	e406                	sd	ra,8(sp)
    80002a9c:	e022                	sd	s0,0(sp)
    80002a9e:	0800                	addi	s0,sp,16
    80002aa0:	e2ffe0ef          	jal	800018ce <myproc>
    80002aa4:	5d08                	lw	a0,56(a0)
    80002aa6:	60a2                	ld	ra,8(sp)
    80002aa8:	6402                	ld	s0,0(sp)
    80002aaa:	0141                	addi	sp,sp,16
    80002aac:	8082                	ret

0000000080002aae <sys_fork>:

uint64 sys_fork(void) { return kfork(); }
    80002aae:	1141                	addi	sp,sp,-16
    80002ab0:	e406                	sd	ra,8(sp)
    80002ab2:	e022                	sd	s0,0(sp)
    80002ab4:	0800                	addi	s0,sp,16
    80002ab6:	a52ff0ef          	jal	80001d08 <kfork>
    80002aba:	60a2                	ld	ra,8(sp)
    80002abc:	6402                	ld	s0,0(sp)
    80002abe:	0141                	addi	sp,sp,16
    80002ac0:	8082                	ret

0000000080002ac2 <sys_wait>:

uint64 sys_wait(void) {
    80002ac2:	1101                	addi	sp,sp,-32
    80002ac4:	ec06                	sd	ra,24(sp)
    80002ac6:	e822                	sd	s0,16(sp)
    80002ac8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002aca:	fe840593          	addi	a1,s0,-24
    80002ace:	4501                	li	a0,0
    80002ad0:	e09ff0ef          	jal	800028d8 <argaddr>
  return kwait(p);
    80002ad4:	fe843503          	ld	a0,-24(s0)
    80002ad8:	f42ff0ef          	jal	8000221a <kwait>
}
    80002adc:	60e2                	ld	ra,24(sp)
    80002ade:	6442                	ld	s0,16(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002ae4:	7179                	addi	sp,sp,-48
    80002ae6:	f406                	sd	ra,40(sp)
    80002ae8:	f022                	sd	s0,32(sp)
    80002aea:	ec26                	sd	s1,24(sp)
    80002aec:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002aee:	fd840593          	addi	a1,s0,-40
    80002af2:	4501                	li	a0,0
    80002af4:	dc9ff0ef          	jal	800028bc <argint>
  argint(1, &t);
    80002af8:	fdc40593          	addi	a1,s0,-36
    80002afc:	4505                	li	a0,1
    80002afe:	dbfff0ef          	jal	800028bc <argint>
  addr = myproc()->sz;
    80002b02:	dcdfe0ef          	jal	800018ce <myproc>
    80002b06:	6924                	ld	s1,80(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002b08:	fdc42703          	lw	a4,-36(s0)
    80002b0c:	4785                	li	a5,1
    80002b0e:	02f70163          	beq	a4,a5,80002b30 <sys_sbrk+0x4c>
    80002b12:	fd842783          	lw	a5,-40(s0)
    80002b16:	0007cd63          	bltz	a5,80002b30 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr) return -1;
    80002b1a:	97a6                	add	a5,a5,s1
    80002b1c:	0297e863          	bltu	a5,s1,80002b4c <sys_sbrk+0x68>
    myproc()->sz += n;
    80002b20:	daffe0ef          	jal	800018ce <myproc>
    80002b24:	fd842703          	lw	a4,-40(s0)
    80002b28:	693c                	ld	a5,80(a0)
    80002b2a:	97ba                	add	a5,a5,a4
    80002b2c:	e93c                	sd	a5,80(a0)
    80002b2e:	a039                	j	80002b3c <sys_sbrk+0x58>
    if (growproc(n) < 0) {
    80002b30:	fd842503          	lw	a0,-40(s0)
    80002b34:	984ff0ef          	jal	80001cb8 <growproc>
    80002b38:	00054863          	bltz	a0,80002b48 <sys_sbrk+0x64>
  }
  return addr;
}
    80002b3c:	8526                	mv	a0,s1
    80002b3e:	70a2                	ld	ra,40(sp)
    80002b40:	7402                	ld	s0,32(sp)
    80002b42:	64e2                	ld	s1,24(sp)
    80002b44:	6145                	addi	sp,sp,48
    80002b46:	8082                	ret
      return -1;
    80002b48:	54fd                	li	s1,-1
    80002b4a:	bfcd                	j	80002b3c <sys_sbrk+0x58>
    if (addr + n < addr) return -1;
    80002b4c:	54fd                	li	s1,-1
    80002b4e:	b7fd                	j	80002b3c <sys_sbrk+0x58>

0000000080002b50 <sys_pause>:

uint64 sys_pause(void) {
    80002b50:	7139                	addi	sp,sp,-64
    80002b52:	fc06                	sd	ra,56(sp)
    80002b54:	f822                	sd	s0,48(sp)
    80002b56:	f04a                	sd	s2,32(sp)
    80002b58:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002b5a:	fcc40593          	addi	a1,s0,-52
    80002b5e:	4501                	li	a0,0
    80002b60:	d5dff0ef          	jal	800028bc <argint>
  if (n < 0) n = 0;
    80002b64:	fcc42783          	lw	a5,-52(s0)
    80002b68:	0607c763          	bltz	a5,80002bd6 <sys_pause+0x86>
  acquire(&tickslock);
    80002b6c:	00016517          	auipc	a0,0x16
    80002b70:	aac50513          	addi	a0,a0,-1364 # 80018618 <tickslock>
    80002b74:	85afe0ef          	jal	80000bce <acquire>
  ticks0 = ticks;
    80002b78:	00008917          	auipc	s2,0x8
    80002b7c:	97092903          	lw	s2,-1680(s2) # 8000a4e8 <ticks>
  while (ticks - ticks0 < n) {
    80002b80:	fcc42783          	lw	a5,-52(s0)
    80002b84:	cf8d                	beqz	a5,80002bbe <sys_pause+0x6e>
    80002b86:	f426                	sd	s1,40(sp)
    80002b88:	ec4e                	sd	s3,24(sp)
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002b8a:	00016997          	auipc	s3,0x16
    80002b8e:	a8e98993          	addi	s3,s3,-1394 # 80018618 <tickslock>
    80002b92:	00008497          	auipc	s1,0x8
    80002b96:	95648493          	addi	s1,s1,-1706 # 8000a4e8 <ticks>
    if (killed(myproc())) {
    80002b9a:	d35fe0ef          	jal	800018ce <myproc>
    80002b9e:	e52ff0ef          	jal	800021f0 <killed>
    80002ba2:	ed0d                	bnez	a0,80002bdc <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002ba4:	85ce                	mv	a1,s3
    80002ba6:	8526                	mv	a0,s1
    80002ba8:	c10ff0ef          	jal	80001fb8 <sleep>
  while (ticks - ticks0 < n) {
    80002bac:	409c                	lw	a5,0(s1)
    80002bae:	412787bb          	subw	a5,a5,s2
    80002bb2:	fcc42703          	lw	a4,-52(s0)
    80002bb6:	fee7e2e3          	bltu	a5,a4,80002b9a <sys_pause+0x4a>
    80002bba:	74a2                	ld	s1,40(sp)
    80002bbc:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002bbe:	00016517          	auipc	a0,0x16
    80002bc2:	a5a50513          	addi	a0,a0,-1446 # 80018618 <tickslock>
    80002bc6:	8a0fe0ef          	jal	80000c66 <release>
  return 0;
    80002bca:	4501                	li	a0,0
}
    80002bcc:	70e2                	ld	ra,56(sp)
    80002bce:	7442                	ld	s0,48(sp)
    80002bd0:	7902                	ld	s2,32(sp)
    80002bd2:	6121                	addi	sp,sp,64
    80002bd4:	8082                	ret
  if (n < 0) n = 0;
    80002bd6:	fc042623          	sw	zero,-52(s0)
    80002bda:	bf49                	j	80002b6c <sys_pause+0x1c>
      release(&tickslock);
    80002bdc:	00016517          	auipc	a0,0x16
    80002be0:	a3c50513          	addi	a0,a0,-1476 # 80018618 <tickslock>
    80002be4:	882fe0ef          	jal	80000c66 <release>
      return -1;
    80002be8:	557d                	li	a0,-1
    80002bea:	74a2                	ld	s1,40(sp)
    80002bec:	69e2                	ld	s3,24(sp)
    80002bee:	bff9                	j	80002bcc <sys_pause+0x7c>

0000000080002bf0 <sys_kill>:

uint64 sys_kill(void) {
    80002bf0:	1101                	addi	sp,sp,-32
    80002bf2:	ec06                	sd	ra,24(sp)
    80002bf4:	e822                	sd	s0,16(sp)
    80002bf6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002bf8:	fec40593          	addi	a1,s0,-20
    80002bfc:	4501                	li	a0,0
    80002bfe:	cbfff0ef          	jal	800028bc <argint>
  return kkill(pid);
    80002c02:	fec42503          	lw	a0,-20(s0)
    80002c06:	d60ff0ef          	jal	80002166 <kkill>
}
    80002c0a:	60e2                	ld	ra,24(sp)
    80002c0c:	6442                	ld	s0,16(sp)
    80002c0e:	6105                	addi	sp,sp,32
    80002c10:	8082                	ret

0000000080002c12 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002c12:	1101                	addi	sp,sp,-32
    80002c14:	ec06                	sd	ra,24(sp)
    80002c16:	e822                	sd	s0,16(sp)
    80002c18:	e426                	sd	s1,8(sp)
    80002c1a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002c1c:	00016517          	auipc	a0,0x16
    80002c20:	9fc50513          	addi	a0,a0,-1540 # 80018618 <tickslock>
    80002c24:	fabfd0ef          	jal	80000bce <acquire>
  xticks = ticks;
    80002c28:	00008497          	auipc	s1,0x8
    80002c2c:	8c04a483          	lw	s1,-1856(s1) # 8000a4e8 <ticks>
  release(&tickslock);
    80002c30:	00016517          	auipc	a0,0x16
    80002c34:	9e850513          	addi	a0,a0,-1560 # 80018618 <tickslock>
    80002c38:	82efe0ef          	jal	80000c66 <release>
  return xticks;
}
    80002c3c:	02049513          	slli	a0,s1,0x20
    80002c40:	9101                	srli	a0,a0,0x20
    80002c42:	60e2                	ld	ra,24(sp)
    80002c44:	6442                	ld	s0,16(sp)
    80002c46:	64a2                	ld	s1,8(sp)
    80002c48:	6105                	addi	sp,sp,32
    80002c4a:	8082                	ret

0000000080002c4c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c4c:	7179                	addi	sp,sp,-48
    80002c4e:	f406                	sd	ra,40(sp)
    80002c50:	f022                	sd	s0,32(sp)
    80002c52:	ec26                	sd	s1,24(sp)
    80002c54:	e84a                	sd	s2,16(sp)
    80002c56:	e44e                	sd	s3,8(sp)
    80002c58:	e052                	sd	s4,0(sp)
    80002c5a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c5c:	00005597          	auipc	a1,0x5
    80002c60:	88c58593          	addi	a1,a1,-1908 # 800074e8 <etext+0x4e8>
    80002c64:	00016517          	auipc	a0,0x16
    80002c68:	9cc50513          	addi	a0,a0,-1588 # 80018630 <bcache>
    80002c6c:	ee3fd0ef          	jal	80000b4e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c70:	0001e797          	auipc	a5,0x1e
    80002c74:	9c078793          	addi	a5,a5,-1600 # 80020630 <bcache+0x8000>
    80002c78:	0001e717          	auipc	a4,0x1e
    80002c7c:	c2070713          	addi	a4,a4,-992 # 80020898 <bcache+0x8268>
    80002c80:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002c84:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002c88:	00016497          	auipc	s1,0x16
    80002c8c:	9c048493          	addi	s1,s1,-1600 # 80018648 <bcache+0x18>
    b->next = bcache.head.next;
    80002c90:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002c92:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002c94:	00005a17          	auipc	s4,0x5
    80002c98:	85ca0a13          	addi	s4,s4,-1956 # 800074f0 <etext+0x4f0>
    b->next = bcache.head.next;
    80002c9c:	2b893783          	ld	a5,696(s2)
    80002ca0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002ca2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002ca6:	85d2                	mv	a1,s4
    80002ca8:	01048513          	addi	a0,s1,16
    80002cac:	322010ef          	jal	80003fce <initsleeplock>
    bcache.head.next->prev = b;
    80002cb0:	2b893783          	ld	a5,696(s2)
    80002cb4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002cb6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cba:	45848493          	addi	s1,s1,1112
    80002cbe:	fd349fe3          	bne	s1,s3,80002c9c <binit+0x50>
  }
}
    80002cc2:	70a2                	ld	ra,40(sp)
    80002cc4:	7402                	ld	s0,32(sp)
    80002cc6:	64e2                	ld	s1,24(sp)
    80002cc8:	6942                	ld	s2,16(sp)
    80002cca:	69a2                	ld	s3,8(sp)
    80002ccc:	6a02                	ld	s4,0(sp)
    80002cce:	6145                	addi	sp,sp,48
    80002cd0:	8082                	ret

0000000080002cd2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002cd2:	7179                	addi	sp,sp,-48
    80002cd4:	f406                	sd	ra,40(sp)
    80002cd6:	f022                	sd	s0,32(sp)
    80002cd8:	ec26                	sd	s1,24(sp)
    80002cda:	e84a                	sd	s2,16(sp)
    80002cdc:	e44e                	sd	s3,8(sp)
    80002cde:	1800                	addi	s0,sp,48
    80002ce0:	892a                	mv	s2,a0
    80002ce2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002ce4:	00016517          	auipc	a0,0x16
    80002ce8:	94c50513          	addi	a0,a0,-1716 # 80018630 <bcache>
    80002cec:	ee3fd0ef          	jal	80000bce <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002cf0:	0001e497          	auipc	s1,0x1e
    80002cf4:	bf84b483          	ld	s1,-1032(s1) # 800208e8 <bcache+0x82b8>
    80002cf8:	0001e797          	auipc	a5,0x1e
    80002cfc:	ba078793          	addi	a5,a5,-1120 # 80020898 <bcache+0x8268>
    80002d00:	02f48b63          	beq	s1,a5,80002d36 <bread+0x64>
    80002d04:	873e                	mv	a4,a5
    80002d06:	a021                	j	80002d0e <bread+0x3c>
    80002d08:	68a4                	ld	s1,80(s1)
    80002d0a:	02e48663          	beq	s1,a4,80002d36 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002d0e:	449c                	lw	a5,8(s1)
    80002d10:	ff279ce3          	bne	a5,s2,80002d08 <bread+0x36>
    80002d14:	44dc                	lw	a5,12(s1)
    80002d16:	ff3799e3          	bne	a5,s3,80002d08 <bread+0x36>
      b->refcnt++;
    80002d1a:	40bc                	lw	a5,64(s1)
    80002d1c:	2785                	addiw	a5,a5,1
    80002d1e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d20:	00016517          	auipc	a0,0x16
    80002d24:	91050513          	addi	a0,a0,-1776 # 80018630 <bcache>
    80002d28:	f3ffd0ef          	jal	80000c66 <release>
      acquiresleep(&b->lock);
    80002d2c:	01048513          	addi	a0,s1,16
    80002d30:	2d4010ef          	jal	80004004 <acquiresleep>
      return b;
    80002d34:	a889                	j	80002d86 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d36:	0001e497          	auipc	s1,0x1e
    80002d3a:	baa4b483          	ld	s1,-1110(s1) # 800208e0 <bcache+0x82b0>
    80002d3e:	0001e797          	auipc	a5,0x1e
    80002d42:	b5a78793          	addi	a5,a5,-1190 # 80020898 <bcache+0x8268>
    80002d46:	00f48863          	beq	s1,a5,80002d56 <bread+0x84>
    80002d4a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d4c:	40bc                	lw	a5,64(s1)
    80002d4e:	cb91                	beqz	a5,80002d62 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d50:	64a4                	ld	s1,72(s1)
    80002d52:	fee49de3          	bne	s1,a4,80002d4c <bread+0x7a>
  panic("bget: no buffers");
    80002d56:	00004517          	auipc	a0,0x4
    80002d5a:	7a250513          	addi	a0,a0,1954 # 800074f8 <etext+0x4f8>
    80002d5e:	a83fd0ef          	jal	800007e0 <panic>
      b->dev = dev;
    80002d62:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d66:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d6a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d6e:	4785                	li	a5,1
    80002d70:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d72:	00016517          	auipc	a0,0x16
    80002d76:	8be50513          	addi	a0,a0,-1858 # 80018630 <bcache>
    80002d7a:	eedfd0ef          	jal	80000c66 <release>
      acquiresleep(&b->lock);
    80002d7e:	01048513          	addi	a0,s1,16
    80002d82:	282010ef          	jal	80004004 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002d86:	409c                	lw	a5,0(s1)
    80002d88:	cb89                	beqz	a5,80002d9a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002d8a:	8526                	mv	a0,s1
    80002d8c:	70a2                	ld	ra,40(sp)
    80002d8e:	7402                	ld	s0,32(sp)
    80002d90:	64e2                	ld	s1,24(sp)
    80002d92:	6942                	ld	s2,16(sp)
    80002d94:	69a2                	ld	s3,8(sp)
    80002d96:	6145                	addi	sp,sp,48
    80002d98:	8082                	ret
    virtio_disk_rw(b, 0);
    80002d9a:	4581                	li	a1,0
    80002d9c:	8526                	mv	a0,s1
    80002d9e:	2c3020ef          	jal	80005860 <virtio_disk_rw>
    b->valid = 1;
    80002da2:	4785                	li	a5,1
    80002da4:	c09c                	sw	a5,0(s1)
  return b;
    80002da6:	b7d5                	j	80002d8a <bread+0xb8>

0000000080002da8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002da8:	1101                	addi	sp,sp,-32
    80002daa:	ec06                	sd	ra,24(sp)
    80002dac:	e822                	sd	s0,16(sp)
    80002dae:	e426                	sd	s1,8(sp)
    80002db0:	1000                	addi	s0,sp,32
    80002db2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002db4:	0541                	addi	a0,a0,16
    80002db6:	2cc010ef          	jal	80004082 <holdingsleep>
    80002dba:	c911                	beqz	a0,80002dce <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002dbc:	4585                	li	a1,1
    80002dbe:	8526                	mv	a0,s1
    80002dc0:	2a1020ef          	jal	80005860 <virtio_disk_rw>
}
    80002dc4:	60e2                	ld	ra,24(sp)
    80002dc6:	6442                	ld	s0,16(sp)
    80002dc8:	64a2                	ld	s1,8(sp)
    80002dca:	6105                	addi	sp,sp,32
    80002dcc:	8082                	ret
    panic("bwrite");
    80002dce:	00004517          	auipc	a0,0x4
    80002dd2:	74250513          	addi	a0,a0,1858 # 80007510 <etext+0x510>
    80002dd6:	a0bfd0ef          	jal	800007e0 <panic>

0000000080002dda <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	e04a                	sd	s2,0(sp)
    80002de4:	1000                	addi	s0,sp,32
    80002de6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002de8:	01050913          	addi	s2,a0,16
    80002dec:	854a                	mv	a0,s2
    80002dee:	294010ef          	jal	80004082 <holdingsleep>
    80002df2:	c135                	beqz	a0,80002e56 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002df4:	854a                	mv	a0,s2
    80002df6:	254010ef          	jal	8000404a <releasesleep>

  acquire(&bcache.lock);
    80002dfa:	00016517          	auipc	a0,0x16
    80002dfe:	83650513          	addi	a0,a0,-1994 # 80018630 <bcache>
    80002e02:	dcdfd0ef          	jal	80000bce <acquire>
  b->refcnt--;
    80002e06:	40bc                	lw	a5,64(s1)
    80002e08:	37fd                	addiw	a5,a5,-1
    80002e0a:	0007871b          	sext.w	a4,a5
    80002e0e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e10:	e71d                	bnez	a4,80002e3e <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e12:	68b8                	ld	a4,80(s1)
    80002e14:	64bc                	ld	a5,72(s1)
    80002e16:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e18:	68b8                	ld	a4,80(s1)
    80002e1a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e1c:	0001e797          	auipc	a5,0x1e
    80002e20:	81478793          	addi	a5,a5,-2028 # 80020630 <bcache+0x8000>
    80002e24:	2b87b703          	ld	a4,696(a5)
    80002e28:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e2a:	0001e717          	auipc	a4,0x1e
    80002e2e:	a6e70713          	addi	a4,a4,-1426 # 80020898 <bcache+0x8268>
    80002e32:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e34:	2b87b703          	ld	a4,696(a5)
    80002e38:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e3a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002e3e:	00015517          	auipc	a0,0x15
    80002e42:	7f250513          	addi	a0,a0,2034 # 80018630 <bcache>
    80002e46:	e21fd0ef          	jal	80000c66 <release>
}
    80002e4a:	60e2                	ld	ra,24(sp)
    80002e4c:	6442                	ld	s0,16(sp)
    80002e4e:	64a2                	ld	s1,8(sp)
    80002e50:	6902                	ld	s2,0(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret
    panic("brelse");
    80002e56:	00004517          	auipc	a0,0x4
    80002e5a:	6c250513          	addi	a0,a0,1730 # 80007518 <etext+0x518>
    80002e5e:	983fd0ef          	jal	800007e0 <panic>

0000000080002e62 <bpin>:

void
bpin(struct buf *b) {
    80002e62:	1101                	addi	sp,sp,-32
    80002e64:	ec06                	sd	ra,24(sp)
    80002e66:	e822                	sd	s0,16(sp)
    80002e68:	e426                	sd	s1,8(sp)
    80002e6a:	1000                	addi	s0,sp,32
    80002e6c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e6e:	00015517          	auipc	a0,0x15
    80002e72:	7c250513          	addi	a0,a0,1986 # 80018630 <bcache>
    80002e76:	d59fd0ef          	jal	80000bce <acquire>
  b->refcnt++;
    80002e7a:	40bc                	lw	a5,64(s1)
    80002e7c:	2785                	addiw	a5,a5,1
    80002e7e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e80:	00015517          	auipc	a0,0x15
    80002e84:	7b050513          	addi	a0,a0,1968 # 80018630 <bcache>
    80002e88:	ddffd0ef          	jal	80000c66 <release>
}
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6105                	addi	sp,sp,32
    80002e94:	8082                	ret

0000000080002e96 <bunpin>:

void
bunpin(struct buf *b) {
    80002e96:	1101                	addi	sp,sp,-32
    80002e98:	ec06                	sd	ra,24(sp)
    80002e9a:	e822                	sd	s0,16(sp)
    80002e9c:	e426                	sd	s1,8(sp)
    80002e9e:	1000                	addi	s0,sp,32
    80002ea0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ea2:	00015517          	auipc	a0,0x15
    80002ea6:	78e50513          	addi	a0,a0,1934 # 80018630 <bcache>
    80002eaa:	d25fd0ef          	jal	80000bce <acquire>
  b->refcnt--;
    80002eae:	40bc                	lw	a5,64(s1)
    80002eb0:	37fd                	addiw	a5,a5,-1
    80002eb2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002eb4:	00015517          	auipc	a0,0x15
    80002eb8:	77c50513          	addi	a0,a0,1916 # 80018630 <bcache>
    80002ebc:	dabfd0ef          	jal	80000c66 <release>
}
    80002ec0:	60e2                	ld	ra,24(sp)
    80002ec2:	6442                	ld	s0,16(sp)
    80002ec4:	64a2                	ld	s1,8(sp)
    80002ec6:	6105                	addi	sp,sp,32
    80002ec8:	8082                	ret

0000000080002eca <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002eca:	1101                	addi	sp,sp,-32
    80002ecc:	ec06                	sd	ra,24(sp)
    80002ece:	e822                	sd	s0,16(sp)
    80002ed0:	e426                	sd	s1,8(sp)
    80002ed2:	e04a                	sd	s2,0(sp)
    80002ed4:	1000                	addi	s0,sp,32
    80002ed6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002ed8:	00d5d59b          	srliw	a1,a1,0xd
    80002edc:	0001e797          	auipc	a5,0x1e
    80002ee0:	e307a783          	lw	a5,-464(a5) # 80020d0c <sb+0x1c>
    80002ee4:	9dbd                	addw	a1,a1,a5
    80002ee6:	dedff0ef          	jal	80002cd2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002eea:	0074f713          	andi	a4,s1,7
    80002eee:	4785                	li	a5,1
    80002ef0:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002ef4:	14ce                	slli	s1,s1,0x33
    80002ef6:	90d9                	srli	s1,s1,0x36
    80002ef8:	00950733          	add	a4,a0,s1
    80002efc:	05874703          	lbu	a4,88(a4)
    80002f00:	00e7f6b3          	and	a3,a5,a4
    80002f04:	c29d                	beqz	a3,80002f2a <bfree+0x60>
    80002f06:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002f08:	94aa                	add	s1,s1,a0
    80002f0a:	fff7c793          	not	a5,a5
    80002f0e:	8f7d                	and	a4,a4,a5
    80002f10:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f14:	7f9000ef          	jal	80003f0c <log_write>
  brelse(bp);
    80002f18:	854a                	mv	a0,s2
    80002f1a:	ec1ff0ef          	jal	80002dda <brelse>
}
    80002f1e:	60e2                	ld	ra,24(sp)
    80002f20:	6442                	ld	s0,16(sp)
    80002f22:	64a2                	ld	s1,8(sp)
    80002f24:	6902                	ld	s2,0(sp)
    80002f26:	6105                	addi	sp,sp,32
    80002f28:	8082                	ret
    panic("freeing free block");
    80002f2a:	00004517          	auipc	a0,0x4
    80002f2e:	5f650513          	addi	a0,a0,1526 # 80007520 <etext+0x520>
    80002f32:	8affd0ef          	jal	800007e0 <panic>

0000000080002f36 <balloc>:
{
    80002f36:	711d                	addi	sp,sp,-96
    80002f38:	ec86                	sd	ra,88(sp)
    80002f3a:	e8a2                	sd	s0,80(sp)
    80002f3c:	e4a6                	sd	s1,72(sp)
    80002f3e:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f40:	0001e797          	auipc	a5,0x1e
    80002f44:	db47a783          	lw	a5,-588(a5) # 80020cf4 <sb+0x4>
    80002f48:	0e078f63          	beqz	a5,80003046 <balloc+0x110>
    80002f4c:	e0ca                	sd	s2,64(sp)
    80002f4e:	fc4e                	sd	s3,56(sp)
    80002f50:	f852                	sd	s4,48(sp)
    80002f52:	f456                	sd	s5,40(sp)
    80002f54:	f05a                	sd	s6,32(sp)
    80002f56:	ec5e                	sd	s7,24(sp)
    80002f58:	e862                	sd	s8,16(sp)
    80002f5a:	e466                	sd	s9,8(sp)
    80002f5c:	8baa                	mv	s7,a0
    80002f5e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f60:	0001eb17          	auipc	s6,0x1e
    80002f64:	d90b0b13          	addi	s6,s6,-624 # 80020cf0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f68:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002f6a:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002f6c:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002f6e:	6c89                	lui	s9,0x2
    80002f70:	a0b5                	j	80002fdc <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002f72:	97ca                	add	a5,a5,s2
    80002f74:	8e55                	or	a2,a2,a3
    80002f76:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f7a:	854a                	mv	a0,s2
    80002f7c:	791000ef          	jal	80003f0c <log_write>
        brelse(bp);
    80002f80:	854a                	mv	a0,s2
    80002f82:	e59ff0ef          	jal	80002dda <brelse>
  bp = bread(dev, bno);
    80002f86:	85a6                	mv	a1,s1
    80002f88:	855e                	mv	a0,s7
    80002f8a:	d49ff0ef          	jal	80002cd2 <bread>
    80002f8e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002f90:	40000613          	li	a2,1024
    80002f94:	4581                	li	a1,0
    80002f96:	05850513          	addi	a0,a0,88
    80002f9a:	d09fd0ef          	jal	80000ca2 <memset>
  log_write(bp);
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	76d000ef          	jal	80003f0c <log_write>
  brelse(bp);
    80002fa4:	854a                	mv	a0,s2
    80002fa6:	e35ff0ef          	jal	80002dda <brelse>
}
    80002faa:	6906                	ld	s2,64(sp)
    80002fac:	79e2                	ld	s3,56(sp)
    80002fae:	7a42                	ld	s4,48(sp)
    80002fb0:	7aa2                	ld	s5,40(sp)
    80002fb2:	7b02                	ld	s6,32(sp)
    80002fb4:	6be2                	ld	s7,24(sp)
    80002fb6:	6c42                	ld	s8,16(sp)
    80002fb8:	6ca2                	ld	s9,8(sp)
}
    80002fba:	8526                	mv	a0,s1
    80002fbc:	60e6                	ld	ra,88(sp)
    80002fbe:	6446                	ld	s0,80(sp)
    80002fc0:	64a6                	ld	s1,72(sp)
    80002fc2:	6125                	addi	sp,sp,96
    80002fc4:	8082                	ret
    brelse(bp);
    80002fc6:	854a                	mv	a0,s2
    80002fc8:	e13ff0ef          	jal	80002dda <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002fcc:	015c87bb          	addw	a5,s9,s5
    80002fd0:	00078a9b          	sext.w	s5,a5
    80002fd4:	004b2703          	lw	a4,4(s6)
    80002fd8:	04eaff63          	bgeu	s5,a4,80003036 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80002fdc:	41fad79b          	sraiw	a5,s5,0x1f
    80002fe0:	0137d79b          	srliw	a5,a5,0x13
    80002fe4:	015787bb          	addw	a5,a5,s5
    80002fe8:	40d7d79b          	sraiw	a5,a5,0xd
    80002fec:	01cb2583          	lw	a1,28(s6)
    80002ff0:	9dbd                	addw	a1,a1,a5
    80002ff2:	855e                	mv	a0,s7
    80002ff4:	cdfff0ef          	jal	80002cd2 <bread>
    80002ff8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002ffa:	004b2503          	lw	a0,4(s6)
    80002ffe:	000a849b          	sext.w	s1,s5
    80003002:	8762                	mv	a4,s8
    80003004:	fca4f1e3          	bgeu	s1,a0,80002fc6 <balloc+0x90>
      m = 1 << (bi % 8);
    80003008:	00777693          	andi	a3,a4,7
    8000300c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003010:	41f7579b          	sraiw	a5,a4,0x1f
    80003014:	01d7d79b          	srliw	a5,a5,0x1d
    80003018:	9fb9                	addw	a5,a5,a4
    8000301a:	4037d79b          	sraiw	a5,a5,0x3
    8000301e:	00f90633          	add	a2,s2,a5
    80003022:	05864603          	lbu	a2,88(a2)
    80003026:	00c6f5b3          	and	a1,a3,a2
    8000302a:	d5a1                	beqz	a1,80002f72 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000302c:	2705                	addiw	a4,a4,1
    8000302e:	2485                	addiw	s1,s1,1
    80003030:	fd471ae3          	bne	a4,s4,80003004 <balloc+0xce>
    80003034:	bf49                	j	80002fc6 <balloc+0x90>
    80003036:	6906                	ld	s2,64(sp)
    80003038:	79e2                	ld	s3,56(sp)
    8000303a:	7a42                	ld	s4,48(sp)
    8000303c:	7aa2                	ld	s5,40(sp)
    8000303e:	7b02                	ld	s6,32(sp)
    80003040:	6be2                	ld	s7,24(sp)
    80003042:	6c42                	ld	s8,16(sp)
    80003044:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003046:	00004517          	auipc	a0,0x4
    8000304a:	4f250513          	addi	a0,a0,1266 # 80007538 <etext+0x538>
    8000304e:	cacfd0ef          	jal	800004fa <printf>
  return 0;
    80003052:	4481                	li	s1,0
    80003054:	b79d                	j	80002fba <balloc+0x84>

0000000080003056 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003056:	7179                	addi	sp,sp,-48
    80003058:	f406                	sd	ra,40(sp)
    8000305a:	f022                	sd	s0,32(sp)
    8000305c:	ec26                	sd	s1,24(sp)
    8000305e:	e84a                	sd	s2,16(sp)
    80003060:	e44e                	sd	s3,8(sp)
    80003062:	1800                	addi	s0,sp,48
    80003064:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003066:	47ad                	li	a5,11
    80003068:	02b7e663          	bltu	a5,a1,80003094 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000306c:	02059793          	slli	a5,a1,0x20
    80003070:	01e7d593          	srli	a1,a5,0x1e
    80003074:	00b504b3          	add	s1,a0,a1
    80003078:	0504a903          	lw	s2,80(s1)
    8000307c:	06091a63          	bnez	s2,800030f0 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003080:	4108                	lw	a0,0(a0)
    80003082:	eb5ff0ef          	jal	80002f36 <balloc>
    80003086:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000308a:	06090363          	beqz	s2,800030f0 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000308e:	0524a823          	sw	s2,80(s1)
    80003092:	a8b9                	j	800030f0 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003094:	ff45849b          	addiw	s1,a1,-12
    80003098:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000309c:	0ff00793          	li	a5,255
    800030a0:	06e7ee63          	bltu	a5,a4,8000311c <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800030a4:	08052903          	lw	s2,128(a0)
    800030a8:	00091d63          	bnez	s2,800030c2 <bmap+0x6c>
      addr = balloc(ip->dev);
    800030ac:	4108                	lw	a0,0(a0)
    800030ae:	e89ff0ef          	jal	80002f36 <balloc>
    800030b2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800030b6:	02090d63          	beqz	s2,800030f0 <bmap+0x9a>
    800030ba:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800030bc:	0929a023          	sw	s2,128(s3)
    800030c0:	a011                	j	800030c4 <bmap+0x6e>
    800030c2:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800030c4:	85ca                	mv	a1,s2
    800030c6:	0009a503          	lw	a0,0(s3)
    800030ca:	c09ff0ef          	jal	80002cd2 <bread>
    800030ce:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800030d0:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800030d4:	02049713          	slli	a4,s1,0x20
    800030d8:	01e75593          	srli	a1,a4,0x1e
    800030dc:	00b784b3          	add	s1,a5,a1
    800030e0:	0004a903          	lw	s2,0(s1)
    800030e4:	00090e63          	beqz	s2,80003100 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800030e8:	8552                	mv	a0,s4
    800030ea:	cf1ff0ef          	jal	80002dda <brelse>
    return addr;
    800030ee:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800030f0:	854a                	mv	a0,s2
    800030f2:	70a2                	ld	ra,40(sp)
    800030f4:	7402                	ld	s0,32(sp)
    800030f6:	64e2                	ld	s1,24(sp)
    800030f8:	6942                	ld	s2,16(sp)
    800030fa:	69a2                	ld	s3,8(sp)
    800030fc:	6145                	addi	sp,sp,48
    800030fe:	8082                	ret
      addr = balloc(ip->dev);
    80003100:	0009a503          	lw	a0,0(s3)
    80003104:	e33ff0ef          	jal	80002f36 <balloc>
    80003108:	0005091b          	sext.w	s2,a0
      if(addr){
    8000310c:	fc090ee3          	beqz	s2,800030e8 <bmap+0x92>
        a[bn] = addr;
    80003110:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003114:	8552                	mv	a0,s4
    80003116:	5f7000ef          	jal	80003f0c <log_write>
    8000311a:	b7f9                	j	800030e8 <bmap+0x92>
    8000311c:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000311e:	00004517          	auipc	a0,0x4
    80003122:	43250513          	addi	a0,a0,1074 # 80007550 <etext+0x550>
    80003126:	ebafd0ef          	jal	800007e0 <panic>

000000008000312a <iget>:
{
    8000312a:	7179                	addi	sp,sp,-48
    8000312c:	f406                	sd	ra,40(sp)
    8000312e:	f022                	sd	s0,32(sp)
    80003130:	ec26                	sd	s1,24(sp)
    80003132:	e84a                	sd	s2,16(sp)
    80003134:	e44e                	sd	s3,8(sp)
    80003136:	e052                	sd	s4,0(sp)
    80003138:	1800                	addi	s0,sp,48
    8000313a:	89aa                	mv	s3,a0
    8000313c:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000313e:	0001e517          	auipc	a0,0x1e
    80003142:	bd250513          	addi	a0,a0,-1070 # 80020d10 <itable>
    80003146:	a89fd0ef          	jal	80000bce <acquire>
  empty = 0;
    8000314a:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000314c:	0001e497          	auipc	s1,0x1e
    80003150:	bdc48493          	addi	s1,s1,-1060 # 80020d28 <itable+0x18>
    80003154:	0001f697          	auipc	a3,0x1f
    80003158:	66468693          	addi	a3,a3,1636 # 800227b8 <log>
    8000315c:	a039                	j	8000316a <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000315e:	02090963          	beqz	s2,80003190 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003162:	08848493          	addi	s1,s1,136
    80003166:	02d48863          	beq	s1,a3,80003196 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000316a:	449c                	lw	a5,8(s1)
    8000316c:	fef059e3          	blez	a5,8000315e <iget+0x34>
    80003170:	4098                	lw	a4,0(s1)
    80003172:	ff3716e3          	bne	a4,s3,8000315e <iget+0x34>
    80003176:	40d8                	lw	a4,4(s1)
    80003178:	ff4713e3          	bne	a4,s4,8000315e <iget+0x34>
      ip->ref++;
    8000317c:	2785                	addiw	a5,a5,1
    8000317e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003180:	0001e517          	auipc	a0,0x1e
    80003184:	b9050513          	addi	a0,a0,-1136 # 80020d10 <itable>
    80003188:	adffd0ef          	jal	80000c66 <release>
      return ip;
    8000318c:	8926                	mv	s2,s1
    8000318e:	a02d                	j	800031b8 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003190:	fbe9                	bnez	a5,80003162 <iget+0x38>
      empty = ip;
    80003192:	8926                	mv	s2,s1
    80003194:	b7f9                	j	80003162 <iget+0x38>
  if(empty == 0)
    80003196:	02090a63          	beqz	s2,800031ca <iget+0xa0>
  ip->dev = dev;
    8000319a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000319e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800031a2:	4785                	li	a5,1
    800031a4:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800031a8:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800031ac:	0001e517          	auipc	a0,0x1e
    800031b0:	b6450513          	addi	a0,a0,-1180 # 80020d10 <itable>
    800031b4:	ab3fd0ef          	jal	80000c66 <release>
}
    800031b8:	854a                	mv	a0,s2
    800031ba:	70a2                	ld	ra,40(sp)
    800031bc:	7402                	ld	s0,32(sp)
    800031be:	64e2                	ld	s1,24(sp)
    800031c0:	6942                	ld	s2,16(sp)
    800031c2:	69a2                	ld	s3,8(sp)
    800031c4:	6a02                	ld	s4,0(sp)
    800031c6:	6145                	addi	sp,sp,48
    800031c8:	8082                	ret
    panic("iget: no inodes");
    800031ca:	00004517          	auipc	a0,0x4
    800031ce:	39e50513          	addi	a0,a0,926 # 80007568 <etext+0x568>
    800031d2:	e0efd0ef          	jal	800007e0 <panic>

00000000800031d6 <iinit>:
{
    800031d6:	7179                	addi	sp,sp,-48
    800031d8:	f406                	sd	ra,40(sp)
    800031da:	f022                	sd	s0,32(sp)
    800031dc:	ec26                	sd	s1,24(sp)
    800031de:	e84a                	sd	s2,16(sp)
    800031e0:	e44e                	sd	s3,8(sp)
    800031e2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031e4:	00004597          	auipc	a1,0x4
    800031e8:	39458593          	addi	a1,a1,916 # 80007578 <etext+0x578>
    800031ec:	0001e517          	auipc	a0,0x1e
    800031f0:	b2450513          	addi	a0,a0,-1244 # 80020d10 <itable>
    800031f4:	95bfd0ef          	jal	80000b4e <initlock>
  for(i = 0; i < NINODE; i++) {
    800031f8:	0001e497          	auipc	s1,0x1e
    800031fc:	b4048493          	addi	s1,s1,-1216 # 80020d38 <itable+0x28>
    80003200:	0001f997          	auipc	s3,0x1f
    80003204:	5c898993          	addi	s3,s3,1480 # 800227c8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003208:	00004917          	auipc	s2,0x4
    8000320c:	37890913          	addi	s2,s2,888 # 80007580 <etext+0x580>
    80003210:	85ca                	mv	a1,s2
    80003212:	8526                	mv	a0,s1
    80003214:	5bb000ef          	jal	80003fce <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003218:	08848493          	addi	s1,s1,136
    8000321c:	ff349ae3          	bne	s1,s3,80003210 <iinit+0x3a>
}
    80003220:	70a2                	ld	ra,40(sp)
    80003222:	7402                	ld	s0,32(sp)
    80003224:	64e2                	ld	s1,24(sp)
    80003226:	6942                	ld	s2,16(sp)
    80003228:	69a2                	ld	s3,8(sp)
    8000322a:	6145                	addi	sp,sp,48
    8000322c:	8082                	ret

000000008000322e <ialloc>:
{
    8000322e:	7139                	addi	sp,sp,-64
    80003230:	fc06                	sd	ra,56(sp)
    80003232:	f822                	sd	s0,48(sp)
    80003234:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003236:	0001e717          	auipc	a4,0x1e
    8000323a:	ac672703          	lw	a4,-1338(a4) # 80020cfc <sb+0xc>
    8000323e:	4785                	li	a5,1
    80003240:	06e7f063          	bgeu	a5,a4,800032a0 <ialloc+0x72>
    80003244:	f426                	sd	s1,40(sp)
    80003246:	f04a                	sd	s2,32(sp)
    80003248:	ec4e                	sd	s3,24(sp)
    8000324a:	e852                	sd	s4,16(sp)
    8000324c:	e456                	sd	s5,8(sp)
    8000324e:	e05a                	sd	s6,0(sp)
    80003250:	8aaa                	mv	s5,a0
    80003252:	8b2e                	mv	s6,a1
    80003254:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003256:	0001ea17          	auipc	s4,0x1e
    8000325a:	a9aa0a13          	addi	s4,s4,-1382 # 80020cf0 <sb>
    8000325e:	00495593          	srli	a1,s2,0x4
    80003262:	018a2783          	lw	a5,24(s4)
    80003266:	9dbd                	addw	a1,a1,a5
    80003268:	8556                	mv	a0,s5
    8000326a:	a69ff0ef          	jal	80002cd2 <bread>
    8000326e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003270:	05850993          	addi	s3,a0,88
    80003274:	00f97793          	andi	a5,s2,15
    80003278:	079a                	slli	a5,a5,0x6
    8000327a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000327c:	00099783          	lh	a5,0(s3)
    80003280:	cb9d                	beqz	a5,800032b6 <ialloc+0x88>
    brelse(bp);
    80003282:	b59ff0ef          	jal	80002dda <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003286:	0905                	addi	s2,s2,1
    80003288:	00ca2703          	lw	a4,12(s4)
    8000328c:	0009079b          	sext.w	a5,s2
    80003290:	fce7e7e3          	bltu	a5,a4,8000325e <ialloc+0x30>
    80003294:	74a2                	ld	s1,40(sp)
    80003296:	7902                	ld	s2,32(sp)
    80003298:	69e2                	ld	s3,24(sp)
    8000329a:	6a42                	ld	s4,16(sp)
    8000329c:	6aa2                	ld	s5,8(sp)
    8000329e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800032a0:	00004517          	auipc	a0,0x4
    800032a4:	2e850513          	addi	a0,a0,744 # 80007588 <etext+0x588>
    800032a8:	a52fd0ef          	jal	800004fa <printf>
  return 0;
    800032ac:	4501                	li	a0,0
}
    800032ae:	70e2                	ld	ra,56(sp)
    800032b0:	7442                	ld	s0,48(sp)
    800032b2:	6121                	addi	sp,sp,64
    800032b4:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800032b6:	04000613          	li	a2,64
    800032ba:	4581                	li	a1,0
    800032bc:	854e                	mv	a0,s3
    800032be:	9e5fd0ef          	jal	80000ca2 <memset>
      dip->type = type;
    800032c2:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800032c6:	8526                	mv	a0,s1
    800032c8:	445000ef          	jal	80003f0c <log_write>
      brelse(bp);
    800032cc:	8526                	mv	a0,s1
    800032ce:	b0dff0ef          	jal	80002dda <brelse>
      return iget(dev, inum);
    800032d2:	0009059b          	sext.w	a1,s2
    800032d6:	8556                	mv	a0,s5
    800032d8:	e53ff0ef          	jal	8000312a <iget>
    800032dc:	74a2                	ld	s1,40(sp)
    800032de:	7902                	ld	s2,32(sp)
    800032e0:	69e2                	ld	s3,24(sp)
    800032e2:	6a42                	ld	s4,16(sp)
    800032e4:	6aa2                	ld	s5,8(sp)
    800032e6:	6b02                	ld	s6,0(sp)
    800032e8:	b7d9                	j	800032ae <ialloc+0x80>

00000000800032ea <iupdate>:
{
    800032ea:	1101                	addi	sp,sp,-32
    800032ec:	ec06                	sd	ra,24(sp)
    800032ee:	e822                	sd	s0,16(sp)
    800032f0:	e426                	sd	s1,8(sp)
    800032f2:	e04a                	sd	s2,0(sp)
    800032f4:	1000                	addi	s0,sp,32
    800032f6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032f8:	415c                	lw	a5,4(a0)
    800032fa:	0047d79b          	srliw	a5,a5,0x4
    800032fe:	0001e597          	auipc	a1,0x1e
    80003302:	a0a5a583          	lw	a1,-1526(a1) # 80020d08 <sb+0x18>
    80003306:	9dbd                	addw	a1,a1,a5
    80003308:	4108                	lw	a0,0(a0)
    8000330a:	9c9ff0ef          	jal	80002cd2 <bread>
    8000330e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003310:	05850793          	addi	a5,a0,88
    80003314:	40d8                	lw	a4,4(s1)
    80003316:	8b3d                	andi	a4,a4,15
    80003318:	071a                	slli	a4,a4,0x6
    8000331a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000331c:	04449703          	lh	a4,68(s1)
    80003320:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003324:	04649703          	lh	a4,70(s1)
    80003328:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000332c:	04849703          	lh	a4,72(s1)
    80003330:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003334:	04a49703          	lh	a4,74(s1)
    80003338:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000333c:	44f8                	lw	a4,76(s1)
    8000333e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003340:	03400613          	li	a2,52
    80003344:	05048593          	addi	a1,s1,80
    80003348:	00c78513          	addi	a0,a5,12
    8000334c:	9b3fd0ef          	jal	80000cfe <memmove>
  log_write(bp);
    80003350:	854a                	mv	a0,s2
    80003352:	3bb000ef          	jal	80003f0c <log_write>
  brelse(bp);
    80003356:	854a                	mv	a0,s2
    80003358:	a83ff0ef          	jal	80002dda <brelse>
}
    8000335c:	60e2                	ld	ra,24(sp)
    8000335e:	6442                	ld	s0,16(sp)
    80003360:	64a2                	ld	s1,8(sp)
    80003362:	6902                	ld	s2,0(sp)
    80003364:	6105                	addi	sp,sp,32
    80003366:	8082                	ret

0000000080003368 <idup>:
{
    80003368:	1101                	addi	sp,sp,-32
    8000336a:	ec06                	sd	ra,24(sp)
    8000336c:	e822                	sd	s0,16(sp)
    8000336e:	e426                	sd	s1,8(sp)
    80003370:	1000                	addi	s0,sp,32
    80003372:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003374:	0001e517          	auipc	a0,0x1e
    80003378:	99c50513          	addi	a0,a0,-1636 # 80020d10 <itable>
    8000337c:	853fd0ef          	jal	80000bce <acquire>
  ip->ref++;
    80003380:	449c                	lw	a5,8(s1)
    80003382:	2785                	addiw	a5,a5,1
    80003384:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003386:	0001e517          	auipc	a0,0x1e
    8000338a:	98a50513          	addi	a0,a0,-1654 # 80020d10 <itable>
    8000338e:	8d9fd0ef          	jal	80000c66 <release>
}
    80003392:	8526                	mv	a0,s1
    80003394:	60e2                	ld	ra,24(sp)
    80003396:	6442                	ld	s0,16(sp)
    80003398:	64a2                	ld	s1,8(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <ilock>:
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800033a8:	cd19                	beqz	a0,800033c6 <ilock+0x28>
    800033aa:	84aa                	mv	s1,a0
    800033ac:	451c                	lw	a5,8(a0)
    800033ae:	00f05c63          	blez	a5,800033c6 <ilock+0x28>
  acquiresleep(&ip->lock);
    800033b2:	0541                	addi	a0,a0,16
    800033b4:	451000ef          	jal	80004004 <acquiresleep>
  if(ip->valid == 0){
    800033b8:	40bc                	lw	a5,64(s1)
    800033ba:	cf89                	beqz	a5,800033d4 <ilock+0x36>
}
    800033bc:	60e2                	ld	ra,24(sp)
    800033be:	6442                	ld	s0,16(sp)
    800033c0:	64a2                	ld	s1,8(sp)
    800033c2:	6105                	addi	sp,sp,32
    800033c4:	8082                	ret
    800033c6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800033c8:	00004517          	auipc	a0,0x4
    800033cc:	1d850513          	addi	a0,a0,472 # 800075a0 <etext+0x5a0>
    800033d0:	c10fd0ef          	jal	800007e0 <panic>
    800033d4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033d6:	40dc                	lw	a5,4(s1)
    800033d8:	0047d79b          	srliw	a5,a5,0x4
    800033dc:	0001e597          	auipc	a1,0x1e
    800033e0:	92c5a583          	lw	a1,-1748(a1) # 80020d08 <sb+0x18>
    800033e4:	9dbd                	addw	a1,a1,a5
    800033e6:	4088                	lw	a0,0(s1)
    800033e8:	8ebff0ef          	jal	80002cd2 <bread>
    800033ec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800033ee:	05850593          	addi	a1,a0,88
    800033f2:	40dc                	lw	a5,4(s1)
    800033f4:	8bbd                	andi	a5,a5,15
    800033f6:	079a                	slli	a5,a5,0x6
    800033f8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033fa:	00059783          	lh	a5,0(a1)
    800033fe:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003402:	00259783          	lh	a5,2(a1)
    80003406:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000340a:	00459783          	lh	a5,4(a1)
    8000340e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003412:	00659783          	lh	a5,6(a1)
    80003416:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000341a:	459c                	lw	a5,8(a1)
    8000341c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000341e:	03400613          	li	a2,52
    80003422:	05b1                	addi	a1,a1,12
    80003424:	05048513          	addi	a0,s1,80
    80003428:	8d7fd0ef          	jal	80000cfe <memmove>
    brelse(bp);
    8000342c:	854a                	mv	a0,s2
    8000342e:	9adff0ef          	jal	80002dda <brelse>
    ip->valid = 1;
    80003432:	4785                	li	a5,1
    80003434:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003436:	04449783          	lh	a5,68(s1)
    8000343a:	c399                	beqz	a5,80003440 <ilock+0xa2>
    8000343c:	6902                	ld	s2,0(sp)
    8000343e:	bfbd                	j	800033bc <ilock+0x1e>
      panic("ilock: no type");
    80003440:	00004517          	auipc	a0,0x4
    80003444:	16850513          	addi	a0,a0,360 # 800075a8 <etext+0x5a8>
    80003448:	b98fd0ef          	jal	800007e0 <panic>

000000008000344c <iunlock>:
{
    8000344c:	1101                	addi	sp,sp,-32
    8000344e:	ec06                	sd	ra,24(sp)
    80003450:	e822                	sd	s0,16(sp)
    80003452:	e426                	sd	s1,8(sp)
    80003454:	e04a                	sd	s2,0(sp)
    80003456:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003458:	c505                	beqz	a0,80003480 <iunlock+0x34>
    8000345a:	84aa                	mv	s1,a0
    8000345c:	01050913          	addi	s2,a0,16
    80003460:	854a                	mv	a0,s2
    80003462:	421000ef          	jal	80004082 <holdingsleep>
    80003466:	cd09                	beqz	a0,80003480 <iunlock+0x34>
    80003468:	449c                	lw	a5,8(s1)
    8000346a:	00f05b63          	blez	a5,80003480 <iunlock+0x34>
  releasesleep(&ip->lock);
    8000346e:	854a                	mv	a0,s2
    80003470:	3db000ef          	jal	8000404a <releasesleep>
}
    80003474:	60e2                	ld	ra,24(sp)
    80003476:	6442                	ld	s0,16(sp)
    80003478:	64a2                	ld	s1,8(sp)
    8000347a:	6902                	ld	s2,0(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret
    panic("iunlock");
    80003480:	00004517          	auipc	a0,0x4
    80003484:	13850513          	addi	a0,a0,312 # 800075b8 <etext+0x5b8>
    80003488:	b58fd0ef          	jal	800007e0 <panic>

000000008000348c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000348c:	7179                	addi	sp,sp,-48
    8000348e:	f406                	sd	ra,40(sp)
    80003490:	f022                	sd	s0,32(sp)
    80003492:	ec26                	sd	s1,24(sp)
    80003494:	e84a                	sd	s2,16(sp)
    80003496:	e44e                	sd	s3,8(sp)
    80003498:	1800                	addi	s0,sp,48
    8000349a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000349c:	05050493          	addi	s1,a0,80
    800034a0:	08050913          	addi	s2,a0,128
    800034a4:	a021                	j	800034ac <itrunc+0x20>
    800034a6:	0491                	addi	s1,s1,4
    800034a8:	01248b63          	beq	s1,s2,800034be <itrunc+0x32>
    if(ip->addrs[i]){
    800034ac:	408c                	lw	a1,0(s1)
    800034ae:	dde5                	beqz	a1,800034a6 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800034b0:	0009a503          	lw	a0,0(s3)
    800034b4:	a17ff0ef          	jal	80002eca <bfree>
      ip->addrs[i] = 0;
    800034b8:	0004a023          	sw	zero,0(s1)
    800034bc:	b7ed                	j	800034a6 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800034be:	0809a583          	lw	a1,128(s3)
    800034c2:	ed89                	bnez	a1,800034dc <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800034c4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800034c8:	854e                	mv	a0,s3
    800034ca:	e21ff0ef          	jal	800032ea <iupdate>
}
    800034ce:	70a2                	ld	ra,40(sp)
    800034d0:	7402                	ld	s0,32(sp)
    800034d2:	64e2                	ld	s1,24(sp)
    800034d4:	6942                	ld	s2,16(sp)
    800034d6:	69a2                	ld	s3,8(sp)
    800034d8:	6145                	addi	sp,sp,48
    800034da:	8082                	ret
    800034dc:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800034de:	0009a503          	lw	a0,0(s3)
    800034e2:	ff0ff0ef          	jal	80002cd2 <bread>
    800034e6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800034e8:	05850493          	addi	s1,a0,88
    800034ec:	45850913          	addi	s2,a0,1112
    800034f0:	a021                	j	800034f8 <itrunc+0x6c>
    800034f2:	0491                	addi	s1,s1,4
    800034f4:	01248963          	beq	s1,s2,80003506 <itrunc+0x7a>
      if(a[j])
    800034f8:	408c                	lw	a1,0(s1)
    800034fa:	dde5                	beqz	a1,800034f2 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800034fc:	0009a503          	lw	a0,0(s3)
    80003500:	9cbff0ef          	jal	80002eca <bfree>
    80003504:	b7fd                	j	800034f2 <itrunc+0x66>
    brelse(bp);
    80003506:	8552                	mv	a0,s4
    80003508:	8d3ff0ef          	jal	80002dda <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000350c:	0809a583          	lw	a1,128(s3)
    80003510:	0009a503          	lw	a0,0(s3)
    80003514:	9b7ff0ef          	jal	80002eca <bfree>
    ip->addrs[NDIRECT] = 0;
    80003518:	0809a023          	sw	zero,128(s3)
    8000351c:	6a02                	ld	s4,0(sp)
    8000351e:	b75d                	j	800034c4 <itrunc+0x38>

0000000080003520 <iput>:
{
    80003520:	1101                	addi	sp,sp,-32
    80003522:	ec06                	sd	ra,24(sp)
    80003524:	e822                	sd	s0,16(sp)
    80003526:	e426                	sd	s1,8(sp)
    80003528:	1000                	addi	s0,sp,32
    8000352a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000352c:	0001d517          	auipc	a0,0x1d
    80003530:	7e450513          	addi	a0,a0,2020 # 80020d10 <itable>
    80003534:	e9afd0ef          	jal	80000bce <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003538:	4498                	lw	a4,8(s1)
    8000353a:	4785                	li	a5,1
    8000353c:	02f70063          	beq	a4,a5,8000355c <iput+0x3c>
  ip->ref--;
    80003540:	449c                	lw	a5,8(s1)
    80003542:	37fd                	addiw	a5,a5,-1
    80003544:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003546:	0001d517          	auipc	a0,0x1d
    8000354a:	7ca50513          	addi	a0,a0,1994 # 80020d10 <itable>
    8000354e:	f18fd0ef          	jal	80000c66 <release>
}
    80003552:	60e2                	ld	ra,24(sp)
    80003554:	6442                	ld	s0,16(sp)
    80003556:	64a2                	ld	s1,8(sp)
    80003558:	6105                	addi	sp,sp,32
    8000355a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000355c:	40bc                	lw	a5,64(s1)
    8000355e:	d3ed                	beqz	a5,80003540 <iput+0x20>
    80003560:	04a49783          	lh	a5,74(s1)
    80003564:	fff1                	bnez	a5,80003540 <iput+0x20>
    80003566:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003568:	01048913          	addi	s2,s1,16
    8000356c:	854a                	mv	a0,s2
    8000356e:	297000ef          	jal	80004004 <acquiresleep>
    release(&itable.lock);
    80003572:	0001d517          	auipc	a0,0x1d
    80003576:	79e50513          	addi	a0,a0,1950 # 80020d10 <itable>
    8000357a:	eecfd0ef          	jal	80000c66 <release>
    itrunc(ip);
    8000357e:	8526                	mv	a0,s1
    80003580:	f0dff0ef          	jal	8000348c <itrunc>
    ip->type = 0;
    80003584:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003588:	8526                	mv	a0,s1
    8000358a:	d61ff0ef          	jal	800032ea <iupdate>
    ip->valid = 0;
    8000358e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003592:	854a                	mv	a0,s2
    80003594:	2b7000ef          	jal	8000404a <releasesleep>
    acquire(&itable.lock);
    80003598:	0001d517          	auipc	a0,0x1d
    8000359c:	77850513          	addi	a0,a0,1912 # 80020d10 <itable>
    800035a0:	e2efd0ef          	jal	80000bce <acquire>
    800035a4:	6902                	ld	s2,0(sp)
    800035a6:	bf69                	j	80003540 <iput+0x20>

00000000800035a8 <iunlockput>:
{
    800035a8:	1101                	addi	sp,sp,-32
    800035aa:	ec06                	sd	ra,24(sp)
    800035ac:	e822                	sd	s0,16(sp)
    800035ae:	e426                	sd	s1,8(sp)
    800035b0:	1000                	addi	s0,sp,32
    800035b2:	84aa                	mv	s1,a0
  iunlock(ip);
    800035b4:	e99ff0ef          	jal	8000344c <iunlock>
  iput(ip);
    800035b8:	8526                	mv	a0,s1
    800035ba:	f67ff0ef          	jal	80003520 <iput>
}
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6105                	addi	sp,sp,32
    800035c6:	8082                	ret

00000000800035c8 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035c8:	0001d717          	auipc	a4,0x1d
    800035cc:	73472703          	lw	a4,1844(a4) # 80020cfc <sb+0xc>
    800035d0:	4785                	li	a5,1
    800035d2:	0ae7ff63          	bgeu	a5,a4,80003690 <ireclaim+0xc8>
{
    800035d6:	7139                	addi	sp,sp,-64
    800035d8:	fc06                	sd	ra,56(sp)
    800035da:	f822                	sd	s0,48(sp)
    800035dc:	f426                	sd	s1,40(sp)
    800035de:	f04a                	sd	s2,32(sp)
    800035e0:	ec4e                	sd	s3,24(sp)
    800035e2:	e852                	sd	s4,16(sp)
    800035e4:	e456                	sd	s5,8(sp)
    800035e6:	e05a                	sd	s6,0(sp)
    800035e8:	0080                	addi	s0,sp,64
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800035ea:	4485                	li	s1,1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800035ec:	00050a1b          	sext.w	s4,a0
    800035f0:	0001da97          	auipc	s5,0x1d
    800035f4:	700a8a93          	addi	s5,s5,1792 # 80020cf0 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800035f8:	00004b17          	auipc	s6,0x4
    800035fc:	fc8b0b13          	addi	s6,s6,-56 # 800075c0 <etext+0x5c0>
    80003600:	a099                	j	80003646 <ireclaim+0x7e>
    80003602:	85ce                	mv	a1,s3
    80003604:	855a                	mv	a0,s6
    80003606:	ef5fc0ef          	jal	800004fa <printf>
      ip = iget(dev, inum);
    8000360a:	85ce                	mv	a1,s3
    8000360c:	8552                	mv	a0,s4
    8000360e:	b1dff0ef          	jal	8000312a <iget>
    80003612:	89aa                	mv	s3,a0
    brelse(bp);
    80003614:	854a                	mv	a0,s2
    80003616:	fc4ff0ef          	jal	80002dda <brelse>
    if (ip) {
    8000361a:	00098f63          	beqz	s3,80003638 <ireclaim+0x70>
      begin_op();
    8000361e:	76a000ef          	jal	80003d88 <begin_op>
      ilock(ip);
    80003622:	854e                	mv	a0,s3
    80003624:	d7bff0ef          	jal	8000339e <ilock>
      iunlock(ip);
    80003628:	854e                	mv	a0,s3
    8000362a:	e23ff0ef          	jal	8000344c <iunlock>
      iput(ip);
    8000362e:	854e                	mv	a0,s3
    80003630:	ef1ff0ef          	jal	80003520 <iput>
      end_op();
    80003634:	7be000ef          	jal	80003df2 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003638:	0485                	addi	s1,s1,1
    8000363a:	00caa703          	lw	a4,12(s5)
    8000363e:	0004879b          	sext.w	a5,s1
    80003642:	02e7fd63          	bgeu	a5,a4,8000367c <ireclaim+0xb4>
    80003646:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000364a:	0044d593          	srli	a1,s1,0x4
    8000364e:	018aa783          	lw	a5,24(s5)
    80003652:	9dbd                	addw	a1,a1,a5
    80003654:	8552                	mv	a0,s4
    80003656:	e7cff0ef          	jal	80002cd2 <bread>
    8000365a:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000365c:	05850793          	addi	a5,a0,88
    80003660:	00f9f713          	andi	a4,s3,15
    80003664:	071a                	slli	a4,a4,0x6
    80003666:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80003668:	00079703          	lh	a4,0(a5)
    8000366c:	c701                	beqz	a4,80003674 <ireclaim+0xac>
    8000366e:	00679783          	lh	a5,6(a5)
    80003672:	dbc1                	beqz	a5,80003602 <ireclaim+0x3a>
    brelse(bp);
    80003674:	854a                	mv	a0,s2
    80003676:	f64ff0ef          	jal	80002dda <brelse>
    if (ip) {
    8000367a:	bf7d                	j	80003638 <ireclaim+0x70>
}
    8000367c:	70e2                	ld	ra,56(sp)
    8000367e:	7442                	ld	s0,48(sp)
    80003680:	74a2                	ld	s1,40(sp)
    80003682:	7902                	ld	s2,32(sp)
    80003684:	69e2                	ld	s3,24(sp)
    80003686:	6a42                	ld	s4,16(sp)
    80003688:	6aa2                	ld	s5,8(sp)
    8000368a:	6b02                	ld	s6,0(sp)
    8000368c:	6121                	addi	sp,sp,64
    8000368e:	8082                	ret
    80003690:	8082                	ret

0000000080003692 <fsinit>:
fsinit(int dev) {
    80003692:	7179                	addi	sp,sp,-48
    80003694:	f406                	sd	ra,40(sp)
    80003696:	f022                	sd	s0,32(sp)
    80003698:	ec26                	sd	s1,24(sp)
    8000369a:	e84a                	sd	s2,16(sp)
    8000369c:	e44e                	sd	s3,8(sp)
    8000369e:	1800                	addi	s0,sp,48
    800036a0:	84aa                	mv	s1,a0
  bp = bread(dev, 1);
    800036a2:	4585                	li	a1,1
    800036a4:	e2eff0ef          	jal	80002cd2 <bread>
    800036a8:	892a                	mv	s2,a0
  memmove(sb, bp->data, sizeof(*sb));
    800036aa:	0001d997          	auipc	s3,0x1d
    800036ae:	64698993          	addi	s3,s3,1606 # 80020cf0 <sb>
    800036b2:	02000613          	li	a2,32
    800036b6:	05850593          	addi	a1,a0,88
    800036ba:	854e                	mv	a0,s3
    800036bc:	e42fd0ef          	jal	80000cfe <memmove>
  brelse(bp);
    800036c0:	854a                	mv	a0,s2
    800036c2:	f18ff0ef          	jal	80002dda <brelse>
  if(sb.magic != FSMAGIC)
    800036c6:	0009a703          	lw	a4,0(s3)
    800036ca:	102037b7          	lui	a5,0x10203
    800036ce:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800036d2:	02f71363          	bne	a4,a5,800036f8 <fsinit+0x66>
  initlog(dev, &sb);
    800036d6:	0001d597          	auipc	a1,0x1d
    800036da:	61a58593          	addi	a1,a1,1562 # 80020cf0 <sb>
    800036de:	8526                	mv	a0,s1
    800036e0:	62a000ef          	jal	80003d0a <initlog>
  ireclaim(dev);
    800036e4:	8526                	mv	a0,s1
    800036e6:	ee3ff0ef          	jal	800035c8 <ireclaim>
}
    800036ea:	70a2                	ld	ra,40(sp)
    800036ec:	7402                	ld	s0,32(sp)
    800036ee:	64e2                	ld	s1,24(sp)
    800036f0:	6942                	ld	s2,16(sp)
    800036f2:	69a2                	ld	s3,8(sp)
    800036f4:	6145                	addi	sp,sp,48
    800036f6:	8082                	ret
    panic("invalid file system");
    800036f8:	00004517          	auipc	a0,0x4
    800036fc:	ee850513          	addi	a0,a0,-280 # 800075e0 <etext+0x5e0>
    80003700:	8e0fd0ef          	jal	800007e0 <panic>

0000000080003704 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003704:	1141                	addi	sp,sp,-16
    80003706:	e422                	sd	s0,8(sp)
    80003708:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000370a:	411c                	lw	a5,0(a0)
    8000370c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000370e:	415c                	lw	a5,4(a0)
    80003710:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003712:	04451783          	lh	a5,68(a0)
    80003716:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000371a:	04a51783          	lh	a5,74(a0)
    8000371e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003722:	04c56783          	lwu	a5,76(a0)
    80003726:	e99c                	sd	a5,16(a1)
}
    80003728:	6422                	ld	s0,8(sp)
    8000372a:	0141                	addi	sp,sp,16
    8000372c:	8082                	ret

000000008000372e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000372e:	457c                	lw	a5,76(a0)
    80003730:	0ed7eb63          	bltu	a5,a3,80003826 <readi+0xf8>
{
    80003734:	7159                	addi	sp,sp,-112
    80003736:	f486                	sd	ra,104(sp)
    80003738:	f0a2                	sd	s0,96(sp)
    8000373a:	eca6                	sd	s1,88(sp)
    8000373c:	e0d2                	sd	s4,64(sp)
    8000373e:	fc56                	sd	s5,56(sp)
    80003740:	f85a                	sd	s6,48(sp)
    80003742:	f45e                	sd	s7,40(sp)
    80003744:	1880                	addi	s0,sp,112
    80003746:	8b2a                	mv	s6,a0
    80003748:	8bae                	mv	s7,a1
    8000374a:	8a32                	mv	s4,a2
    8000374c:	84b6                	mv	s1,a3
    8000374e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003750:	9f35                	addw	a4,a4,a3
    return 0;
    80003752:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003754:	0cd76063          	bltu	a4,a3,80003814 <readi+0xe6>
    80003758:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000375a:	00e7f463          	bgeu	a5,a4,80003762 <readi+0x34>
    n = ip->size - off;
    8000375e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003762:	080a8f63          	beqz	s5,80003800 <readi+0xd2>
    80003766:	e8ca                	sd	s2,80(sp)
    80003768:	f062                	sd	s8,32(sp)
    8000376a:	ec66                	sd	s9,24(sp)
    8000376c:	e86a                	sd	s10,16(sp)
    8000376e:	e46e                	sd	s11,8(sp)
    80003770:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003772:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003776:	5c7d                	li	s8,-1
    80003778:	a80d                	j	800037aa <readi+0x7c>
    8000377a:	020d1d93          	slli	s11,s10,0x20
    8000377e:	020ddd93          	srli	s11,s11,0x20
    80003782:	05890613          	addi	a2,s2,88
    80003786:	86ee                	mv	a3,s11
    80003788:	963a                	add	a2,a2,a4
    8000378a:	85d2                	mv	a1,s4
    8000378c:	855e                	mv	a0,s7
    8000378e:	b87fe0ef          	jal	80002314 <either_copyout>
    80003792:	05850763          	beq	a0,s8,800037e0 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003796:	854a                	mv	a0,s2
    80003798:	e42ff0ef          	jal	80002dda <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000379c:	013d09bb          	addw	s3,s10,s3
    800037a0:	009d04bb          	addw	s1,s10,s1
    800037a4:	9a6e                	add	s4,s4,s11
    800037a6:	0559f763          	bgeu	s3,s5,800037f4 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800037aa:	00a4d59b          	srliw	a1,s1,0xa
    800037ae:	855a                	mv	a0,s6
    800037b0:	8a7ff0ef          	jal	80003056 <bmap>
    800037b4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800037b8:	c5b1                	beqz	a1,80003804 <readi+0xd6>
    bp = bread(ip->dev, addr);
    800037ba:	000b2503          	lw	a0,0(s6)
    800037be:	d14ff0ef          	jal	80002cd2 <bread>
    800037c2:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800037c4:	3ff4f713          	andi	a4,s1,1023
    800037c8:	40ec87bb          	subw	a5,s9,a4
    800037cc:	413a86bb          	subw	a3,s5,s3
    800037d0:	8d3e                	mv	s10,a5
    800037d2:	2781                	sext.w	a5,a5
    800037d4:	0006861b          	sext.w	a2,a3
    800037d8:	faf671e3          	bgeu	a2,a5,8000377a <readi+0x4c>
    800037dc:	8d36                	mv	s10,a3
    800037de:	bf71                	j	8000377a <readi+0x4c>
      brelse(bp);
    800037e0:	854a                	mv	a0,s2
    800037e2:	df8ff0ef          	jal	80002dda <brelse>
      tot = -1;
    800037e6:	59fd                	li	s3,-1
      break;
    800037e8:	6946                	ld	s2,80(sp)
    800037ea:	7c02                	ld	s8,32(sp)
    800037ec:	6ce2                	ld	s9,24(sp)
    800037ee:	6d42                	ld	s10,16(sp)
    800037f0:	6da2                	ld	s11,8(sp)
    800037f2:	a831                	j	8000380e <readi+0xe0>
    800037f4:	6946                	ld	s2,80(sp)
    800037f6:	7c02                	ld	s8,32(sp)
    800037f8:	6ce2                	ld	s9,24(sp)
    800037fa:	6d42                	ld	s10,16(sp)
    800037fc:	6da2                	ld	s11,8(sp)
    800037fe:	a801                	j	8000380e <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003800:	89d6                	mv	s3,s5
    80003802:	a031                	j	8000380e <readi+0xe0>
    80003804:	6946                	ld	s2,80(sp)
    80003806:	7c02                	ld	s8,32(sp)
    80003808:	6ce2                	ld	s9,24(sp)
    8000380a:	6d42                	ld	s10,16(sp)
    8000380c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000380e:	0009851b          	sext.w	a0,s3
    80003812:	69a6                	ld	s3,72(sp)
}
    80003814:	70a6                	ld	ra,104(sp)
    80003816:	7406                	ld	s0,96(sp)
    80003818:	64e6                	ld	s1,88(sp)
    8000381a:	6a06                	ld	s4,64(sp)
    8000381c:	7ae2                	ld	s5,56(sp)
    8000381e:	7b42                	ld	s6,48(sp)
    80003820:	7ba2                	ld	s7,40(sp)
    80003822:	6165                	addi	sp,sp,112
    80003824:	8082                	ret
    return 0;
    80003826:	4501                	li	a0,0
}
    80003828:	8082                	ret

000000008000382a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000382a:	457c                	lw	a5,76(a0)
    8000382c:	10d7e063          	bltu	a5,a3,8000392c <writei+0x102>
{
    80003830:	7159                	addi	sp,sp,-112
    80003832:	f486                	sd	ra,104(sp)
    80003834:	f0a2                	sd	s0,96(sp)
    80003836:	e8ca                	sd	s2,80(sp)
    80003838:	e0d2                	sd	s4,64(sp)
    8000383a:	fc56                	sd	s5,56(sp)
    8000383c:	f85a                	sd	s6,48(sp)
    8000383e:	f45e                	sd	s7,40(sp)
    80003840:	1880                	addi	s0,sp,112
    80003842:	8aaa                	mv	s5,a0
    80003844:	8bae                	mv	s7,a1
    80003846:	8a32                	mv	s4,a2
    80003848:	8936                	mv	s2,a3
    8000384a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000384c:	00e687bb          	addw	a5,a3,a4
    80003850:	0ed7e063          	bltu	a5,a3,80003930 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003854:	00043737          	lui	a4,0x43
    80003858:	0cf76e63          	bltu	a4,a5,80003934 <writei+0x10a>
    8000385c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000385e:	0a0b0f63          	beqz	s6,8000391c <writei+0xf2>
    80003862:	eca6                	sd	s1,88(sp)
    80003864:	f062                	sd	s8,32(sp)
    80003866:	ec66                	sd	s9,24(sp)
    80003868:	e86a                	sd	s10,16(sp)
    8000386a:	e46e                	sd	s11,8(sp)
    8000386c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000386e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003872:	5c7d                	li	s8,-1
    80003874:	a825                	j	800038ac <writei+0x82>
    80003876:	020d1d93          	slli	s11,s10,0x20
    8000387a:	020ddd93          	srli	s11,s11,0x20
    8000387e:	05848513          	addi	a0,s1,88
    80003882:	86ee                	mv	a3,s11
    80003884:	8652                	mv	a2,s4
    80003886:	85de                	mv	a1,s7
    80003888:	953a                	add	a0,a0,a4
    8000388a:	ad5fe0ef          	jal	8000235e <either_copyin>
    8000388e:	05850a63          	beq	a0,s8,800038e2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003892:	8526                	mv	a0,s1
    80003894:	678000ef          	jal	80003f0c <log_write>
    brelse(bp);
    80003898:	8526                	mv	a0,s1
    8000389a:	d40ff0ef          	jal	80002dda <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000389e:	013d09bb          	addw	s3,s10,s3
    800038a2:	012d093b          	addw	s2,s10,s2
    800038a6:	9a6e                	add	s4,s4,s11
    800038a8:	0569f063          	bgeu	s3,s6,800038e8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800038ac:	00a9559b          	srliw	a1,s2,0xa
    800038b0:	8556                	mv	a0,s5
    800038b2:	fa4ff0ef          	jal	80003056 <bmap>
    800038b6:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800038ba:	c59d                	beqz	a1,800038e8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800038bc:	000aa503          	lw	a0,0(s5)
    800038c0:	c12ff0ef          	jal	80002cd2 <bread>
    800038c4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800038c6:	3ff97713          	andi	a4,s2,1023
    800038ca:	40ec87bb          	subw	a5,s9,a4
    800038ce:	413b06bb          	subw	a3,s6,s3
    800038d2:	8d3e                	mv	s10,a5
    800038d4:	2781                	sext.w	a5,a5
    800038d6:	0006861b          	sext.w	a2,a3
    800038da:	f8f67ee3          	bgeu	a2,a5,80003876 <writei+0x4c>
    800038de:	8d36                	mv	s10,a3
    800038e0:	bf59                	j	80003876 <writei+0x4c>
      brelse(bp);
    800038e2:	8526                	mv	a0,s1
    800038e4:	cf6ff0ef          	jal	80002dda <brelse>
  }

  if(off > ip->size)
    800038e8:	04caa783          	lw	a5,76(s5)
    800038ec:	0327fa63          	bgeu	a5,s2,80003920 <writei+0xf6>
    ip->size = off;
    800038f0:	052aa623          	sw	s2,76(s5)
    800038f4:	64e6                	ld	s1,88(sp)
    800038f6:	7c02                	ld	s8,32(sp)
    800038f8:	6ce2                	ld	s9,24(sp)
    800038fa:	6d42                	ld	s10,16(sp)
    800038fc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800038fe:	8556                	mv	a0,s5
    80003900:	9ebff0ef          	jal	800032ea <iupdate>

  return tot;
    80003904:	0009851b          	sext.w	a0,s3
    80003908:	69a6                	ld	s3,72(sp)
}
    8000390a:	70a6                	ld	ra,104(sp)
    8000390c:	7406                	ld	s0,96(sp)
    8000390e:	6946                	ld	s2,80(sp)
    80003910:	6a06                	ld	s4,64(sp)
    80003912:	7ae2                	ld	s5,56(sp)
    80003914:	7b42                	ld	s6,48(sp)
    80003916:	7ba2                	ld	s7,40(sp)
    80003918:	6165                	addi	sp,sp,112
    8000391a:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000391c:	89da                	mv	s3,s6
    8000391e:	b7c5                	j	800038fe <writei+0xd4>
    80003920:	64e6                	ld	s1,88(sp)
    80003922:	7c02                	ld	s8,32(sp)
    80003924:	6ce2                	ld	s9,24(sp)
    80003926:	6d42                	ld	s10,16(sp)
    80003928:	6da2                	ld	s11,8(sp)
    8000392a:	bfd1                	j	800038fe <writei+0xd4>
    return -1;
    8000392c:	557d                	li	a0,-1
}
    8000392e:	8082                	ret
    return -1;
    80003930:	557d                	li	a0,-1
    80003932:	bfe1                	j	8000390a <writei+0xe0>
    return -1;
    80003934:	557d                	li	a0,-1
    80003936:	bfd1                	j	8000390a <writei+0xe0>

0000000080003938 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003938:	1141                	addi	sp,sp,-16
    8000393a:	e406                	sd	ra,8(sp)
    8000393c:	e022                	sd	s0,0(sp)
    8000393e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003940:	4639                	li	a2,14
    80003942:	c2cfd0ef          	jal	80000d6e <strncmp>
}
    80003946:	60a2                	ld	ra,8(sp)
    80003948:	6402                	ld	s0,0(sp)
    8000394a:	0141                	addi	sp,sp,16
    8000394c:	8082                	ret

000000008000394e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000394e:	7139                	addi	sp,sp,-64
    80003950:	fc06                	sd	ra,56(sp)
    80003952:	f822                	sd	s0,48(sp)
    80003954:	f426                	sd	s1,40(sp)
    80003956:	f04a                	sd	s2,32(sp)
    80003958:	ec4e                	sd	s3,24(sp)
    8000395a:	e852                	sd	s4,16(sp)
    8000395c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000395e:	04451703          	lh	a4,68(a0)
    80003962:	4785                	li	a5,1
    80003964:	00f71a63          	bne	a4,a5,80003978 <dirlookup+0x2a>
    80003968:	892a                	mv	s2,a0
    8000396a:	89ae                	mv	s3,a1
    8000396c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000396e:	457c                	lw	a5,76(a0)
    80003970:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003972:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003974:	e39d                	bnez	a5,8000399a <dirlookup+0x4c>
    80003976:	a095                	j	800039da <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003978:	00004517          	auipc	a0,0x4
    8000397c:	c8050513          	addi	a0,a0,-896 # 800075f8 <etext+0x5f8>
    80003980:	e61fc0ef          	jal	800007e0 <panic>
      panic("dirlookup read");
    80003984:	00004517          	auipc	a0,0x4
    80003988:	c8c50513          	addi	a0,a0,-884 # 80007610 <etext+0x610>
    8000398c:	e55fc0ef          	jal	800007e0 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003990:	24c1                	addiw	s1,s1,16
    80003992:	04c92783          	lw	a5,76(s2)
    80003996:	04f4f163          	bgeu	s1,a5,800039d8 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000399a:	4741                	li	a4,16
    8000399c:	86a6                	mv	a3,s1
    8000399e:	fc040613          	addi	a2,s0,-64
    800039a2:	4581                	li	a1,0
    800039a4:	854a                	mv	a0,s2
    800039a6:	d89ff0ef          	jal	8000372e <readi>
    800039aa:	47c1                	li	a5,16
    800039ac:	fcf51ce3          	bne	a0,a5,80003984 <dirlookup+0x36>
    if(de.inum == 0)
    800039b0:	fc045783          	lhu	a5,-64(s0)
    800039b4:	dff1                	beqz	a5,80003990 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    800039b6:	fc240593          	addi	a1,s0,-62
    800039ba:	854e                	mv	a0,s3
    800039bc:	f7dff0ef          	jal	80003938 <namecmp>
    800039c0:	f961                	bnez	a0,80003990 <dirlookup+0x42>
      if(poff)
    800039c2:	000a0463          	beqz	s4,800039ca <dirlookup+0x7c>
        *poff = off;
    800039c6:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800039ca:	fc045583          	lhu	a1,-64(s0)
    800039ce:	00092503          	lw	a0,0(s2)
    800039d2:	f58ff0ef          	jal	8000312a <iget>
    800039d6:	a011                	j	800039da <dirlookup+0x8c>
  return 0;
    800039d8:	4501                	li	a0,0
}
    800039da:	70e2                	ld	ra,56(sp)
    800039dc:	7442                	ld	s0,48(sp)
    800039de:	74a2                	ld	s1,40(sp)
    800039e0:	7902                	ld	s2,32(sp)
    800039e2:	69e2                	ld	s3,24(sp)
    800039e4:	6a42                	ld	s4,16(sp)
    800039e6:	6121                	addi	sp,sp,64
    800039e8:	8082                	ret

00000000800039ea <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800039ea:	711d                	addi	sp,sp,-96
    800039ec:	ec86                	sd	ra,88(sp)
    800039ee:	e8a2                	sd	s0,80(sp)
    800039f0:	e4a6                	sd	s1,72(sp)
    800039f2:	e0ca                	sd	s2,64(sp)
    800039f4:	fc4e                	sd	s3,56(sp)
    800039f6:	f852                	sd	s4,48(sp)
    800039f8:	f456                	sd	s5,40(sp)
    800039fa:	f05a                	sd	s6,32(sp)
    800039fc:	ec5e                	sd	s7,24(sp)
    800039fe:	e862                	sd	s8,16(sp)
    80003a00:	e466                	sd	s9,8(sp)
    80003a02:	1080                	addi	s0,sp,96
    80003a04:	84aa                	mv	s1,a0
    80003a06:	8b2e                	mv	s6,a1
    80003a08:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003a0a:	00054703          	lbu	a4,0(a0)
    80003a0e:	02f00793          	li	a5,47
    80003a12:	00f70e63          	beq	a4,a5,80003a2e <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003a16:	eb9fd0ef          	jal	800018ce <myproc>
    80003a1a:	15853503          	ld	a0,344(a0)
    80003a1e:	94bff0ef          	jal	80003368 <idup>
    80003a22:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003a24:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003a28:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003a2a:	4b85                	li	s7,1
    80003a2c:	a871                	j	80003ac8 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003a2e:	4585                	li	a1,1
    80003a30:	4505                	li	a0,1
    80003a32:	ef8ff0ef          	jal	8000312a <iget>
    80003a36:	8a2a                	mv	s4,a0
    80003a38:	b7f5                	j	80003a24 <namex+0x3a>
      iunlockput(ip);
    80003a3a:	8552                	mv	a0,s4
    80003a3c:	b6dff0ef          	jal	800035a8 <iunlockput>
      return 0;
    80003a40:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a42:	8552                	mv	a0,s4
    80003a44:	60e6                	ld	ra,88(sp)
    80003a46:	6446                	ld	s0,80(sp)
    80003a48:	64a6                	ld	s1,72(sp)
    80003a4a:	6906                	ld	s2,64(sp)
    80003a4c:	79e2                	ld	s3,56(sp)
    80003a4e:	7a42                	ld	s4,48(sp)
    80003a50:	7aa2                	ld	s5,40(sp)
    80003a52:	7b02                	ld	s6,32(sp)
    80003a54:	6be2                	ld	s7,24(sp)
    80003a56:	6c42                	ld	s8,16(sp)
    80003a58:	6ca2                	ld	s9,8(sp)
    80003a5a:	6125                	addi	sp,sp,96
    80003a5c:	8082                	ret
      iunlock(ip);
    80003a5e:	8552                	mv	a0,s4
    80003a60:	9edff0ef          	jal	8000344c <iunlock>
      return ip;
    80003a64:	bff9                	j	80003a42 <namex+0x58>
      iunlockput(ip);
    80003a66:	8552                	mv	a0,s4
    80003a68:	b41ff0ef          	jal	800035a8 <iunlockput>
      return 0;
    80003a6c:	8a4e                	mv	s4,s3
    80003a6e:	bfd1                	j	80003a42 <namex+0x58>
  len = path - s;
    80003a70:	40998633          	sub	a2,s3,s1
    80003a74:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003a78:	099c5063          	bge	s8,s9,80003af8 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003a7c:	4639                	li	a2,14
    80003a7e:	85a6                	mv	a1,s1
    80003a80:	8556                	mv	a0,s5
    80003a82:	a7cfd0ef          	jal	80000cfe <memmove>
    80003a86:	84ce                	mv	s1,s3
  while(*path == '/')
    80003a88:	0004c783          	lbu	a5,0(s1)
    80003a8c:	01279763          	bne	a5,s2,80003a9a <namex+0xb0>
    path++;
    80003a90:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003a92:	0004c783          	lbu	a5,0(s1)
    80003a96:	ff278de3          	beq	a5,s2,80003a90 <namex+0xa6>
    ilock(ip);
    80003a9a:	8552                	mv	a0,s4
    80003a9c:	903ff0ef          	jal	8000339e <ilock>
    if(ip->type != T_DIR){
    80003aa0:	044a1783          	lh	a5,68(s4)
    80003aa4:	f9779be3          	bne	a5,s7,80003a3a <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003aa8:	000b0563          	beqz	s6,80003ab2 <namex+0xc8>
    80003aac:	0004c783          	lbu	a5,0(s1)
    80003ab0:	d7dd                	beqz	a5,80003a5e <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ab2:	4601                	li	a2,0
    80003ab4:	85d6                	mv	a1,s5
    80003ab6:	8552                	mv	a0,s4
    80003ab8:	e97ff0ef          	jal	8000394e <dirlookup>
    80003abc:	89aa                	mv	s3,a0
    80003abe:	d545                	beqz	a0,80003a66 <namex+0x7c>
    iunlockput(ip);
    80003ac0:	8552                	mv	a0,s4
    80003ac2:	ae7ff0ef          	jal	800035a8 <iunlockput>
    ip = next;
    80003ac6:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003ac8:	0004c783          	lbu	a5,0(s1)
    80003acc:	01279763          	bne	a5,s2,80003ada <namex+0xf0>
    path++;
    80003ad0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ad2:	0004c783          	lbu	a5,0(s1)
    80003ad6:	ff278de3          	beq	a5,s2,80003ad0 <namex+0xe6>
  if(*path == 0)
    80003ada:	cb8d                	beqz	a5,80003b0c <namex+0x122>
  while(*path != '/' && *path != 0)
    80003adc:	0004c783          	lbu	a5,0(s1)
    80003ae0:	89a6                	mv	s3,s1
  len = path - s;
    80003ae2:	4c81                	li	s9,0
    80003ae4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003ae6:	01278963          	beq	a5,s2,80003af8 <namex+0x10e>
    80003aea:	d3d9                	beqz	a5,80003a70 <namex+0x86>
    path++;
    80003aec:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003aee:	0009c783          	lbu	a5,0(s3)
    80003af2:	ff279ce3          	bne	a5,s2,80003aea <namex+0x100>
    80003af6:	bfad                	j	80003a70 <namex+0x86>
    memmove(name, s, len);
    80003af8:	2601                	sext.w	a2,a2
    80003afa:	85a6                	mv	a1,s1
    80003afc:	8556                	mv	a0,s5
    80003afe:	a00fd0ef          	jal	80000cfe <memmove>
    name[len] = 0;
    80003b02:	9cd6                	add	s9,s9,s5
    80003b04:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003b08:	84ce                	mv	s1,s3
    80003b0a:	bfbd                	j	80003a88 <namex+0x9e>
  if(nameiparent){
    80003b0c:	f20b0be3          	beqz	s6,80003a42 <namex+0x58>
    iput(ip);
    80003b10:	8552                	mv	a0,s4
    80003b12:	a0fff0ef          	jal	80003520 <iput>
    return 0;
    80003b16:	4a01                	li	s4,0
    80003b18:	b72d                	j	80003a42 <namex+0x58>

0000000080003b1a <dirlink>:
{
    80003b1a:	7139                	addi	sp,sp,-64
    80003b1c:	fc06                	sd	ra,56(sp)
    80003b1e:	f822                	sd	s0,48(sp)
    80003b20:	f04a                	sd	s2,32(sp)
    80003b22:	ec4e                	sd	s3,24(sp)
    80003b24:	e852                	sd	s4,16(sp)
    80003b26:	0080                	addi	s0,sp,64
    80003b28:	892a                	mv	s2,a0
    80003b2a:	8a2e                	mv	s4,a1
    80003b2c:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003b2e:	4601                	li	a2,0
    80003b30:	e1fff0ef          	jal	8000394e <dirlookup>
    80003b34:	e535                	bnez	a0,80003ba0 <dirlink+0x86>
    80003b36:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b38:	04c92483          	lw	s1,76(s2)
    80003b3c:	c48d                	beqz	s1,80003b66 <dirlink+0x4c>
    80003b3e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b40:	4741                	li	a4,16
    80003b42:	86a6                	mv	a3,s1
    80003b44:	fc040613          	addi	a2,s0,-64
    80003b48:	4581                	li	a1,0
    80003b4a:	854a                	mv	a0,s2
    80003b4c:	be3ff0ef          	jal	8000372e <readi>
    80003b50:	47c1                	li	a5,16
    80003b52:	04f51b63          	bne	a0,a5,80003ba8 <dirlink+0x8e>
    if(de.inum == 0)
    80003b56:	fc045783          	lhu	a5,-64(s0)
    80003b5a:	c791                	beqz	a5,80003b66 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b5c:	24c1                	addiw	s1,s1,16
    80003b5e:	04c92783          	lw	a5,76(s2)
    80003b62:	fcf4efe3          	bltu	s1,a5,80003b40 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003b66:	4639                	li	a2,14
    80003b68:	85d2                	mv	a1,s4
    80003b6a:	fc240513          	addi	a0,s0,-62
    80003b6e:	a36fd0ef          	jal	80000da4 <strncpy>
  de.inum = inum;
    80003b72:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b76:	4741                	li	a4,16
    80003b78:	86a6                	mv	a3,s1
    80003b7a:	fc040613          	addi	a2,s0,-64
    80003b7e:	4581                	li	a1,0
    80003b80:	854a                	mv	a0,s2
    80003b82:	ca9ff0ef          	jal	8000382a <writei>
    80003b86:	1541                	addi	a0,a0,-16
    80003b88:	00a03533          	snez	a0,a0
    80003b8c:	40a00533          	neg	a0,a0
    80003b90:	74a2                	ld	s1,40(sp)
}
    80003b92:	70e2                	ld	ra,56(sp)
    80003b94:	7442                	ld	s0,48(sp)
    80003b96:	7902                	ld	s2,32(sp)
    80003b98:	69e2                	ld	s3,24(sp)
    80003b9a:	6a42                	ld	s4,16(sp)
    80003b9c:	6121                	addi	sp,sp,64
    80003b9e:	8082                	ret
    iput(ip);
    80003ba0:	981ff0ef          	jal	80003520 <iput>
    return -1;
    80003ba4:	557d                	li	a0,-1
    80003ba6:	b7f5                	j	80003b92 <dirlink+0x78>
      panic("dirlink read");
    80003ba8:	00004517          	auipc	a0,0x4
    80003bac:	a7850513          	addi	a0,a0,-1416 # 80007620 <etext+0x620>
    80003bb0:	c31fc0ef          	jal	800007e0 <panic>

0000000080003bb4 <namei>:

struct inode*
namei(char *path)
{
    80003bb4:	1101                	addi	sp,sp,-32
    80003bb6:	ec06                	sd	ra,24(sp)
    80003bb8:	e822                	sd	s0,16(sp)
    80003bba:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003bbc:	fe040613          	addi	a2,s0,-32
    80003bc0:	4581                	li	a1,0
    80003bc2:	e29ff0ef          	jal	800039ea <namex>
}
    80003bc6:	60e2                	ld	ra,24(sp)
    80003bc8:	6442                	ld	s0,16(sp)
    80003bca:	6105                	addi	sp,sp,32
    80003bcc:	8082                	ret

0000000080003bce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003bce:	1141                	addi	sp,sp,-16
    80003bd0:	e406                	sd	ra,8(sp)
    80003bd2:	e022                	sd	s0,0(sp)
    80003bd4:	0800                	addi	s0,sp,16
    80003bd6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003bd8:	4585                	li	a1,1
    80003bda:	e11ff0ef          	jal	800039ea <namex>
}
    80003bde:	60a2                	ld	ra,8(sp)
    80003be0:	6402                	ld	s0,0(sp)
    80003be2:	0141                	addi	sp,sp,16
    80003be4:	8082                	ret

0000000080003be6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003be6:	1101                	addi	sp,sp,-32
    80003be8:	ec06                	sd	ra,24(sp)
    80003bea:	e822                	sd	s0,16(sp)
    80003bec:	e426                	sd	s1,8(sp)
    80003bee:	e04a                	sd	s2,0(sp)
    80003bf0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003bf2:	0001f917          	auipc	s2,0x1f
    80003bf6:	bc690913          	addi	s2,s2,-1082 # 800227b8 <log>
    80003bfa:	01892583          	lw	a1,24(s2)
    80003bfe:	02492503          	lw	a0,36(s2)
    80003c02:	8d0ff0ef          	jal	80002cd2 <bread>
    80003c06:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003c08:	02892603          	lw	a2,40(s2)
    80003c0c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003c0e:	00c05f63          	blez	a2,80003c2c <write_head+0x46>
    80003c12:	0001f717          	auipc	a4,0x1f
    80003c16:	bd270713          	addi	a4,a4,-1070 # 800227e4 <log+0x2c>
    80003c1a:	87aa                	mv	a5,a0
    80003c1c:	060a                	slli	a2,a2,0x2
    80003c1e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003c20:	4314                	lw	a3,0(a4)
    80003c22:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003c24:	0711                	addi	a4,a4,4
    80003c26:	0791                	addi	a5,a5,4
    80003c28:	fec79ce3          	bne	a5,a2,80003c20 <write_head+0x3a>
  }
  bwrite(buf);
    80003c2c:	8526                	mv	a0,s1
    80003c2e:	97aff0ef          	jal	80002da8 <bwrite>
  brelse(buf);
    80003c32:	8526                	mv	a0,s1
    80003c34:	9a6ff0ef          	jal	80002dda <brelse>
}
    80003c38:	60e2                	ld	ra,24(sp)
    80003c3a:	6442                	ld	s0,16(sp)
    80003c3c:	64a2                	ld	s1,8(sp)
    80003c3e:	6902                	ld	s2,0(sp)
    80003c40:	6105                	addi	sp,sp,32
    80003c42:	8082                	ret

0000000080003c44 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c44:	0001f797          	auipc	a5,0x1f
    80003c48:	b9c7a783          	lw	a5,-1124(a5) # 800227e0 <log+0x28>
    80003c4c:	0af05e63          	blez	a5,80003d08 <install_trans+0xc4>
{
    80003c50:	715d                	addi	sp,sp,-80
    80003c52:	e486                	sd	ra,72(sp)
    80003c54:	e0a2                	sd	s0,64(sp)
    80003c56:	fc26                	sd	s1,56(sp)
    80003c58:	f84a                	sd	s2,48(sp)
    80003c5a:	f44e                	sd	s3,40(sp)
    80003c5c:	f052                	sd	s4,32(sp)
    80003c5e:	ec56                	sd	s5,24(sp)
    80003c60:	e85a                	sd	s6,16(sp)
    80003c62:	e45e                	sd	s7,8(sp)
    80003c64:	0880                	addi	s0,sp,80
    80003c66:	8b2a                	mv	s6,a0
    80003c68:	0001fa97          	auipc	s5,0x1f
    80003c6c:	b7ca8a93          	addi	s5,s5,-1156 # 800227e4 <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c70:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c72:	00004b97          	auipc	s7,0x4
    80003c76:	9beb8b93          	addi	s7,s7,-1602 # 80007630 <etext+0x630>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003c7a:	0001fa17          	auipc	s4,0x1f
    80003c7e:	b3ea0a13          	addi	s4,s4,-1218 # 800227b8 <log>
    80003c82:	a025                	j	80003caa <install_trans+0x66>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003c84:	000aa603          	lw	a2,0(s5)
    80003c88:	85ce                	mv	a1,s3
    80003c8a:	855e                	mv	a0,s7
    80003c8c:	86ffc0ef          	jal	800004fa <printf>
    80003c90:	a839                	j	80003cae <install_trans+0x6a>
    brelse(lbuf);
    80003c92:	854a                	mv	a0,s2
    80003c94:	946ff0ef          	jal	80002dda <brelse>
    brelse(dbuf);
    80003c98:	8526                	mv	a0,s1
    80003c9a:	940ff0ef          	jal	80002dda <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003c9e:	2985                	addiw	s3,s3,1
    80003ca0:	0a91                	addi	s5,s5,4
    80003ca2:	028a2783          	lw	a5,40(s4)
    80003ca6:	04f9d663          	bge	s3,a5,80003cf2 <install_trans+0xae>
    if(recovering) {
    80003caa:	fc0b1de3          	bnez	s6,80003c84 <install_trans+0x40>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003cae:	018a2583          	lw	a1,24(s4)
    80003cb2:	013585bb          	addw	a1,a1,s3
    80003cb6:	2585                	addiw	a1,a1,1
    80003cb8:	024a2503          	lw	a0,36(s4)
    80003cbc:	816ff0ef          	jal	80002cd2 <bread>
    80003cc0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003cc2:	000aa583          	lw	a1,0(s5)
    80003cc6:	024a2503          	lw	a0,36(s4)
    80003cca:	808ff0ef          	jal	80002cd2 <bread>
    80003cce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003cd0:	40000613          	li	a2,1024
    80003cd4:	05890593          	addi	a1,s2,88
    80003cd8:	05850513          	addi	a0,a0,88
    80003cdc:	822fd0ef          	jal	80000cfe <memmove>
    bwrite(dbuf);  // write dst to disk
    80003ce0:	8526                	mv	a0,s1
    80003ce2:	8c6ff0ef          	jal	80002da8 <bwrite>
    if(recovering == 0)
    80003ce6:	fa0b16e3          	bnez	s6,80003c92 <install_trans+0x4e>
      bunpin(dbuf);
    80003cea:	8526                	mv	a0,s1
    80003cec:	9aaff0ef          	jal	80002e96 <bunpin>
    80003cf0:	b74d                	j	80003c92 <install_trans+0x4e>
}
    80003cf2:	60a6                	ld	ra,72(sp)
    80003cf4:	6406                	ld	s0,64(sp)
    80003cf6:	74e2                	ld	s1,56(sp)
    80003cf8:	7942                	ld	s2,48(sp)
    80003cfa:	79a2                	ld	s3,40(sp)
    80003cfc:	7a02                	ld	s4,32(sp)
    80003cfe:	6ae2                	ld	s5,24(sp)
    80003d00:	6b42                	ld	s6,16(sp)
    80003d02:	6ba2                	ld	s7,8(sp)
    80003d04:	6161                	addi	sp,sp,80
    80003d06:	8082                	ret
    80003d08:	8082                	ret

0000000080003d0a <initlog>:
{
    80003d0a:	7179                	addi	sp,sp,-48
    80003d0c:	f406                	sd	ra,40(sp)
    80003d0e:	f022                	sd	s0,32(sp)
    80003d10:	ec26                	sd	s1,24(sp)
    80003d12:	e84a                	sd	s2,16(sp)
    80003d14:	e44e                	sd	s3,8(sp)
    80003d16:	1800                	addi	s0,sp,48
    80003d18:	892a                	mv	s2,a0
    80003d1a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d1c:	0001f497          	auipc	s1,0x1f
    80003d20:	a9c48493          	addi	s1,s1,-1380 # 800227b8 <log>
    80003d24:	00004597          	auipc	a1,0x4
    80003d28:	92c58593          	addi	a1,a1,-1748 # 80007650 <etext+0x650>
    80003d2c:	8526                	mv	a0,s1
    80003d2e:	e21fc0ef          	jal	80000b4e <initlock>
  log.start = sb->logstart;
    80003d32:	0149a583          	lw	a1,20(s3)
    80003d36:	cc8c                	sw	a1,24(s1)
  log.dev = dev;
    80003d38:	0324a223          	sw	s2,36(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003d3c:	854a                	mv	a0,s2
    80003d3e:	f95fe0ef          	jal	80002cd2 <bread>
  log.lh.n = lh->n;
    80003d42:	4d30                	lw	a2,88(a0)
    80003d44:	d490                	sw	a2,40(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003d46:	00c05f63          	blez	a2,80003d64 <initlog+0x5a>
    80003d4a:	87aa                	mv	a5,a0
    80003d4c:	0001f717          	auipc	a4,0x1f
    80003d50:	a9870713          	addi	a4,a4,-1384 # 800227e4 <log+0x2c>
    80003d54:	060a                	slli	a2,a2,0x2
    80003d56:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003d58:	4ff4                	lw	a3,92(a5)
    80003d5a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003d5c:	0791                	addi	a5,a5,4
    80003d5e:	0711                	addi	a4,a4,4
    80003d60:	fec79ce3          	bne	a5,a2,80003d58 <initlog+0x4e>
  brelse(buf);
    80003d64:	876ff0ef          	jal	80002dda <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003d68:	4505                	li	a0,1
    80003d6a:	edbff0ef          	jal	80003c44 <install_trans>
  log.lh.n = 0;
    80003d6e:	0001f797          	auipc	a5,0x1f
    80003d72:	a607a923          	sw	zero,-1422(a5) # 800227e0 <log+0x28>
  write_head(); // clear the log
    80003d76:	e71ff0ef          	jal	80003be6 <write_head>
}
    80003d7a:	70a2                	ld	ra,40(sp)
    80003d7c:	7402                	ld	s0,32(sp)
    80003d7e:	64e2                	ld	s1,24(sp)
    80003d80:	6942                	ld	s2,16(sp)
    80003d82:	69a2                	ld	s3,8(sp)
    80003d84:	6145                	addi	sp,sp,48
    80003d86:	8082                	ret

0000000080003d88 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003d88:	1101                	addi	sp,sp,-32
    80003d8a:	ec06                	sd	ra,24(sp)
    80003d8c:	e822                	sd	s0,16(sp)
    80003d8e:	e426                	sd	s1,8(sp)
    80003d90:	e04a                	sd	s2,0(sp)
    80003d92:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003d94:	0001f517          	auipc	a0,0x1f
    80003d98:	a2450513          	addi	a0,a0,-1500 # 800227b8 <log>
    80003d9c:	e33fc0ef          	jal	80000bce <acquire>
  while(1){
    if(log.committing){
    80003da0:	0001f497          	auipc	s1,0x1f
    80003da4:	a1848493          	addi	s1,s1,-1512 # 800227b8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003da8:	4979                	li	s2,30
    80003daa:	a029                	j	80003db4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003dac:	85a6                	mv	a1,s1
    80003dae:	8526                	mv	a0,s1
    80003db0:	a08fe0ef          	jal	80001fb8 <sleep>
    if(log.committing){
    80003db4:	509c                	lw	a5,32(s1)
    80003db6:	fbfd                	bnez	a5,80003dac <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003db8:	4cd8                	lw	a4,28(s1)
    80003dba:	2705                	addiw	a4,a4,1
    80003dbc:	0027179b          	slliw	a5,a4,0x2
    80003dc0:	9fb9                	addw	a5,a5,a4
    80003dc2:	0017979b          	slliw	a5,a5,0x1
    80003dc6:	5494                	lw	a3,40(s1)
    80003dc8:	9fb5                	addw	a5,a5,a3
    80003dca:	00f95763          	bge	s2,a5,80003dd8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003dce:	85a6                	mv	a1,s1
    80003dd0:	8526                	mv	a0,s1
    80003dd2:	9e6fe0ef          	jal	80001fb8 <sleep>
    80003dd6:	bff9                	j	80003db4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003dd8:	0001f517          	auipc	a0,0x1f
    80003ddc:	9e050513          	addi	a0,a0,-1568 # 800227b8 <log>
    80003de0:	cd58                	sw	a4,28(a0)
      release(&log.lock);
    80003de2:	e85fc0ef          	jal	80000c66 <release>
      break;
    }
  }
}
    80003de6:	60e2                	ld	ra,24(sp)
    80003de8:	6442                	ld	s0,16(sp)
    80003dea:	64a2                	ld	s1,8(sp)
    80003dec:	6902                	ld	s2,0(sp)
    80003dee:	6105                	addi	sp,sp,32
    80003df0:	8082                	ret

0000000080003df2 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003df2:	7139                	addi	sp,sp,-64
    80003df4:	fc06                	sd	ra,56(sp)
    80003df6:	f822                	sd	s0,48(sp)
    80003df8:	f426                	sd	s1,40(sp)
    80003dfa:	f04a                	sd	s2,32(sp)
    80003dfc:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003dfe:	0001f497          	auipc	s1,0x1f
    80003e02:	9ba48493          	addi	s1,s1,-1606 # 800227b8 <log>
    80003e06:	8526                	mv	a0,s1
    80003e08:	dc7fc0ef          	jal	80000bce <acquire>
  log.outstanding -= 1;
    80003e0c:	4cdc                	lw	a5,28(s1)
    80003e0e:	37fd                	addiw	a5,a5,-1
    80003e10:	0007891b          	sext.w	s2,a5
    80003e14:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003e16:	509c                	lw	a5,32(s1)
    80003e18:	ef9d                	bnez	a5,80003e56 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003e1a:	04091763          	bnez	s2,80003e68 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003e1e:	0001f497          	auipc	s1,0x1f
    80003e22:	99a48493          	addi	s1,s1,-1638 # 800227b8 <log>
    80003e26:	4785                	li	a5,1
    80003e28:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003e2a:	8526                	mv	a0,s1
    80003e2c:	e3bfc0ef          	jal	80000c66 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003e30:	549c                	lw	a5,40(s1)
    80003e32:	04f04b63          	bgtz	a5,80003e88 <end_op+0x96>
    acquire(&log.lock);
    80003e36:	0001f497          	auipc	s1,0x1f
    80003e3a:	98248493          	addi	s1,s1,-1662 # 800227b8 <log>
    80003e3e:	8526                	mv	a0,s1
    80003e40:	d8ffc0ef          	jal	80000bce <acquire>
    log.committing = 0;
    80003e44:	0204a023          	sw	zero,32(s1)
    wakeup(&log);
    80003e48:	8526                	mv	a0,s1
    80003e4a:	9bafe0ef          	jal	80002004 <wakeup>
    release(&log.lock);
    80003e4e:	8526                	mv	a0,s1
    80003e50:	e17fc0ef          	jal	80000c66 <release>
}
    80003e54:	a025                	j	80003e7c <end_op+0x8a>
    80003e56:	ec4e                	sd	s3,24(sp)
    80003e58:	e852                	sd	s4,16(sp)
    80003e5a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003e5c:	00003517          	auipc	a0,0x3
    80003e60:	7fc50513          	addi	a0,a0,2044 # 80007658 <etext+0x658>
    80003e64:	97dfc0ef          	jal	800007e0 <panic>
    wakeup(&log);
    80003e68:	0001f497          	auipc	s1,0x1f
    80003e6c:	95048493          	addi	s1,s1,-1712 # 800227b8 <log>
    80003e70:	8526                	mv	a0,s1
    80003e72:	992fe0ef          	jal	80002004 <wakeup>
  release(&log.lock);
    80003e76:	8526                	mv	a0,s1
    80003e78:	deffc0ef          	jal	80000c66 <release>
}
    80003e7c:	70e2                	ld	ra,56(sp)
    80003e7e:	7442                	ld	s0,48(sp)
    80003e80:	74a2                	ld	s1,40(sp)
    80003e82:	7902                	ld	s2,32(sp)
    80003e84:	6121                	addi	sp,sp,64
    80003e86:	8082                	ret
    80003e88:	ec4e                	sd	s3,24(sp)
    80003e8a:	e852                	sd	s4,16(sp)
    80003e8c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e8e:	0001fa97          	auipc	s5,0x1f
    80003e92:	956a8a93          	addi	s5,s5,-1706 # 800227e4 <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003e96:	0001fa17          	auipc	s4,0x1f
    80003e9a:	922a0a13          	addi	s4,s4,-1758 # 800227b8 <log>
    80003e9e:	018a2583          	lw	a1,24(s4)
    80003ea2:	012585bb          	addw	a1,a1,s2
    80003ea6:	2585                	addiw	a1,a1,1
    80003ea8:	024a2503          	lw	a0,36(s4)
    80003eac:	e27fe0ef          	jal	80002cd2 <bread>
    80003eb0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003eb2:	000aa583          	lw	a1,0(s5)
    80003eb6:	024a2503          	lw	a0,36(s4)
    80003eba:	e19fe0ef          	jal	80002cd2 <bread>
    80003ebe:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003ec0:	40000613          	li	a2,1024
    80003ec4:	05850593          	addi	a1,a0,88
    80003ec8:	05848513          	addi	a0,s1,88
    80003ecc:	e33fc0ef          	jal	80000cfe <memmove>
    bwrite(to);  // write the log
    80003ed0:	8526                	mv	a0,s1
    80003ed2:	ed7fe0ef          	jal	80002da8 <bwrite>
    brelse(from);
    80003ed6:	854e                	mv	a0,s3
    80003ed8:	f03fe0ef          	jal	80002dda <brelse>
    brelse(to);
    80003edc:	8526                	mv	a0,s1
    80003ede:	efdfe0ef          	jal	80002dda <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ee2:	2905                	addiw	s2,s2,1
    80003ee4:	0a91                	addi	s5,s5,4
    80003ee6:	028a2783          	lw	a5,40(s4)
    80003eea:	faf94ae3          	blt	s2,a5,80003e9e <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003eee:	cf9ff0ef          	jal	80003be6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003ef2:	4501                	li	a0,0
    80003ef4:	d51ff0ef          	jal	80003c44 <install_trans>
    log.lh.n = 0;
    80003ef8:	0001f797          	auipc	a5,0x1f
    80003efc:	8e07a423          	sw	zero,-1816(a5) # 800227e0 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003f00:	ce7ff0ef          	jal	80003be6 <write_head>
    80003f04:	69e2                	ld	s3,24(sp)
    80003f06:	6a42                	ld	s4,16(sp)
    80003f08:	6aa2                	ld	s5,8(sp)
    80003f0a:	b735                	j	80003e36 <end_op+0x44>

0000000080003f0c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003f0c:	1101                	addi	sp,sp,-32
    80003f0e:	ec06                	sd	ra,24(sp)
    80003f10:	e822                	sd	s0,16(sp)
    80003f12:	e426                	sd	s1,8(sp)
    80003f14:	e04a                	sd	s2,0(sp)
    80003f16:	1000                	addi	s0,sp,32
    80003f18:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003f1a:	0001f917          	auipc	s2,0x1f
    80003f1e:	89e90913          	addi	s2,s2,-1890 # 800227b8 <log>
    80003f22:	854a                	mv	a0,s2
    80003f24:	cabfc0ef          	jal	80000bce <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003f28:	02892603          	lw	a2,40(s2)
    80003f2c:	47f5                	li	a5,29
    80003f2e:	04c7cc63          	blt	a5,a2,80003f86 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003f32:	0001f797          	auipc	a5,0x1f
    80003f36:	8a27a783          	lw	a5,-1886(a5) # 800227d4 <log+0x1c>
    80003f3a:	04f05c63          	blez	a5,80003f92 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003f3e:	4781                	li	a5,0
    80003f40:	04c05f63          	blez	a2,80003f9e <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f44:	44cc                	lw	a1,12(s1)
    80003f46:	0001f717          	auipc	a4,0x1f
    80003f4a:	89e70713          	addi	a4,a4,-1890 # 800227e4 <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003f4e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003f50:	4314                	lw	a3,0(a4)
    80003f52:	04b68663          	beq	a3,a1,80003f9e <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003f56:	2785                	addiw	a5,a5,1
    80003f58:	0711                	addi	a4,a4,4
    80003f5a:	fef61be3          	bne	a2,a5,80003f50 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003f5e:	0621                	addi	a2,a2,8
    80003f60:	060a                	slli	a2,a2,0x2
    80003f62:	0001f797          	auipc	a5,0x1f
    80003f66:	85678793          	addi	a5,a5,-1962 # 800227b8 <log>
    80003f6a:	97b2                	add	a5,a5,a2
    80003f6c:	44d8                	lw	a4,12(s1)
    80003f6e:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003f70:	8526                	mv	a0,s1
    80003f72:	ef1fe0ef          	jal	80002e62 <bpin>
    log.lh.n++;
    80003f76:	0001f717          	auipc	a4,0x1f
    80003f7a:	84270713          	addi	a4,a4,-1982 # 800227b8 <log>
    80003f7e:	571c                	lw	a5,40(a4)
    80003f80:	2785                	addiw	a5,a5,1
    80003f82:	d71c                	sw	a5,40(a4)
    80003f84:	a80d                	j	80003fb6 <log_write+0xaa>
    panic("too big a transaction");
    80003f86:	00003517          	auipc	a0,0x3
    80003f8a:	6e250513          	addi	a0,a0,1762 # 80007668 <etext+0x668>
    80003f8e:	853fc0ef          	jal	800007e0 <panic>
    panic("log_write outside of trans");
    80003f92:	00003517          	auipc	a0,0x3
    80003f96:	6ee50513          	addi	a0,a0,1774 # 80007680 <etext+0x680>
    80003f9a:	847fc0ef          	jal	800007e0 <panic>
  log.lh.block[i] = b->blockno;
    80003f9e:	00878693          	addi	a3,a5,8
    80003fa2:	068a                	slli	a3,a3,0x2
    80003fa4:	0001f717          	auipc	a4,0x1f
    80003fa8:	81470713          	addi	a4,a4,-2028 # 800227b8 <log>
    80003fac:	9736                	add	a4,a4,a3
    80003fae:	44d4                	lw	a3,12(s1)
    80003fb0:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003fb2:	faf60fe3          	beq	a2,a5,80003f70 <log_write+0x64>
  }
  release(&log.lock);
    80003fb6:	0001f517          	auipc	a0,0x1f
    80003fba:	80250513          	addi	a0,a0,-2046 # 800227b8 <log>
    80003fbe:	ca9fc0ef          	jal	80000c66 <release>
}
    80003fc2:	60e2                	ld	ra,24(sp)
    80003fc4:	6442                	ld	s0,16(sp)
    80003fc6:	64a2                	ld	s1,8(sp)
    80003fc8:	6902                	ld	s2,0(sp)
    80003fca:	6105                	addi	sp,sp,32
    80003fcc:	8082                	ret

0000000080003fce <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003fce:	1101                	addi	sp,sp,-32
    80003fd0:	ec06                	sd	ra,24(sp)
    80003fd2:	e822                	sd	s0,16(sp)
    80003fd4:	e426                	sd	s1,8(sp)
    80003fd6:	e04a                	sd	s2,0(sp)
    80003fd8:	1000                	addi	s0,sp,32
    80003fda:	84aa                	mv	s1,a0
    80003fdc:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003fde:	00003597          	auipc	a1,0x3
    80003fe2:	6c258593          	addi	a1,a1,1730 # 800076a0 <etext+0x6a0>
    80003fe6:	0521                	addi	a0,a0,8
    80003fe8:	b67fc0ef          	jal	80000b4e <initlock>
  lk->name = name;
    80003fec:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003ff0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ff4:	0204a423          	sw	zero,40(s1)
}
    80003ff8:	60e2                	ld	ra,24(sp)
    80003ffa:	6442                	ld	s0,16(sp)
    80003ffc:	64a2                	ld	s1,8(sp)
    80003ffe:	6902                	ld	s2,0(sp)
    80004000:	6105                	addi	sp,sp,32
    80004002:	8082                	ret

0000000080004004 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004004:	1101                	addi	sp,sp,-32
    80004006:	ec06                	sd	ra,24(sp)
    80004008:	e822                	sd	s0,16(sp)
    8000400a:	e426                	sd	s1,8(sp)
    8000400c:	e04a                	sd	s2,0(sp)
    8000400e:	1000                	addi	s0,sp,32
    80004010:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004012:	00850913          	addi	s2,a0,8
    80004016:	854a                	mv	a0,s2
    80004018:	bb7fc0ef          	jal	80000bce <acquire>
  while (lk->locked) {
    8000401c:	409c                	lw	a5,0(s1)
    8000401e:	c799                	beqz	a5,8000402c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004020:	85ca                	mv	a1,s2
    80004022:	8526                	mv	a0,s1
    80004024:	f95fd0ef          	jal	80001fb8 <sleep>
  while (lk->locked) {
    80004028:	409c                	lw	a5,0(s1)
    8000402a:	fbfd                	bnez	a5,80004020 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000402c:	4785                	li	a5,1
    8000402e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004030:	89ffd0ef          	jal	800018ce <myproc>
    80004034:	5d1c                	lw	a5,56(a0)
    80004036:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004038:	854a                	mv	a0,s2
    8000403a:	c2dfc0ef          	jal	80000c66 <release>
}
    8000403e:	60e2                	ld	ra,24(sp)
    80004040:	6442                	ld	s0,16(sp)
    80004042:	64a2                	ld	s1,8(sp)
    80004044:	6902                	ld	s2,0(sp)
    80004046:	6105                	addi	sp,sp,32
    80004048:	8082                	ret

000000008000404a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000404a:	1101                	addi	sp,sp,-32
    8000404c:	ec06                	sd	ra,24(sp)
    8000404e:	e822                	sd	s0,16(sp)
    80004050:	e426                	sd	s1,8(sp)
    80004052:	e04a                	sd	s2,0(sp)
    80004054:	1000                	addi	s0,sp,32
    80004056:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004058:	00850913          	addi	s2,a0,8
    8000405c:	854a                	mv	a0,s2
    8000405e:	b71fc0ef          	jal	80000bce <acquire>
  lk->locked = 0;
    80004062:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004066:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000406a:	8526                	mv	a0,s1
    8000406c:	f99fd0ef          	jal	80002004 <wakeup>
  release(&lk->lk);
    80004070:	854a                	mv	a0,s2
    80004072:	bf5fc0ef          	jal	80000c66 <release>
}
    80004076:	60e2                	ld	ra,24(sp)
    80004078:	6442                	ld	s0,16(sp)
    8000407a:	64a2                	ld	s1,8(sp)
    8000407c:	6902                	ld	s2,0(sp)
    8000407e:	6105                	addi	sp,sp,32
    80004080:	8082                	ret

0000000080004082 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004082:	7179                	addi	sp,sp,-48
    80004084:	f406                	sd	ra,40(sp)
    80004086:	f022                	sd	s0,32(sp)
    80004088:	ec26                	sd	s1,24(sp)
    8000408a:	e84a                	sd	s2,16(sp)
    8000408c:	1800                	addi	s0,sp,48
    8000408e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004090:	00850913          	addi	s2,a0,8
    80004094:	854a                	mv	a0,s2
    80004096:	b39fc0ef          	jal	80000bce <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000409a:	409c                	lw	a5,0(s1)
    8000409c:	ef81                	bnez	a5,800040b4 <holdingsleep+0x32>
    8000409e:	4481                	li	s1,0
  release(&lk->lk);
    800040a0:	854a                	mv	a0,s2
    800040a2:	bc5fc0ef          	jal	80000c66 <release>
  return r;
}
    800040a6:	8526                	mv	a0,s1
    800040a8:	70a2                	ld	ra,40(sp)
    800040aa:	7402                	ld	s0,32(sp)
    800040ac:	64e2                	ld	s1,24(sp)
    800040ae:	6942                	ld	s2,16(sp)
    800040b0:	6145                	addi	sp,sp,48
    800040b2:	8082                	ret
    800040b4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800040b6:	0284a983          	lw	s3,40(s1)
    800040ba:	815fd0ef          	jal	800018ce <myproc>
    800040be:	5d04                	lw	s1,56(a0)
    800040c0:	413484b3          	sub	s1,s1,s3
    800040c4:	0014b493          	seqz	s1,s1
    800040c8:	69a2                	ld	s3,8(sp)
    800040ca:	bfd9                	j	800040a0 <holdingsleep+0x1e>

00000000800040cc <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800040cc:	1141                	addi	sp,sp,-16
    800040ce:	e406                	sd	ra,8(sp)
    800040d0:	e022                	sd	s0,0(sp)
    800040d2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800040d4:	00003597          	auipc	a1,0x3
    800040d8:	5dc58593          	addi	a1,a1,1500 # 800076b0 <etext+0x6b0>
    800040dc:	0001f517          	auipc	a0,0x1f
    800040e0:	82450513          	addi	a0,a0,-2012 # 80022900 <ftable>
    800040e4:	a6bfc0ef          	jal	80000b4e <initlock>
}
    800040e8:	60a2                	ld	ra,8(sp)
    800040ea:	6402                	ld	s0,0(sp)
    800040ec:	0141                	addi	sp,sp,16
    800040ee:	8082                	ret

00000000800040f0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800040f0:	1101                	addi	sp,sp,-32
    800040f2:	ec06                	sd	ra,24(sp)
    800040f4:	e822                	sd	s0,16(sp)
    800040f6:	e426                	sd	s1,8(sp)
    800040f8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800040fa:	0001f517          	auipc	a0,0x1f
    800040fe:	80650513          	addi	a0,a0,-2042 # 80022900 <ftable>
    80004102:	acdfc0ef          	jal	80000bce <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004106:	0001f497          	auipc	s1,0x1f
    8000410a:	81248493          	addi	s1,s1,-2030 # 80022918 <ftable+0x18>
    8000410e:	0001f717          	auipc	a4,0x1f
    80004112:	7aa70713          	addi	a4,a4,1962 # 800238b8 <disk>
    if(f->ref == 0){
    80004116:	40dc                	lw	a5,4(s1)
    80004118:	cf89                	beqz	a5,80004132 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000411a:	02848493          	addi	s1,s1,40
    8000411e:	fee49ce3          	bne	s1,a4,80004116 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004122:	0001e517          	auipc	a0,0x1e
    80004126:	7de50513          	addi	a0,a0,2014 # 80022900 <ftable>
    8000412a:	b3dfc0ef          	jal	80000c66 <release>
  return 0;
    8000412e:	4481                	li	s1,0
    80004130:	a809                	j	80004142 <filealloc+0x52>
      f->ref = 1;
    80004132:	4785                	li	a5,1
    80004134:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004136:	0001e517          	auipc	a0,0x1e
    8000413a:	7ca50513          	addi	a0,a0,1994 # 80022900 <ftable>
    8000413e:	b29fc0ef          	jal	80000c66 <release>
}
    80004142:	8526                	mv	a0,s1
    80004144:	60e2                	ld	ra,24(sp)
    80004146:	6442                	ld	s0,16(sp)
    80004148:	64a2                	ld	s1,8(sp)
    8000414a:	6105                	addi	sp,sp,32
    8000414c:	8082                	ret

000000008000414e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000414e:	1101                	addi	sp,sp,-32
    80004150:	ec06                	sd	ra,24(sp)
    80004152:	e822                	sd	s0,16(sp)
    80004154:	e426                	sd	s1,8(sp)
    80004156:	1000                	addi	s0,sp,32
    80004158:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000415a:	0001e517          	auipc	a0,0x1e
    8000415e:	7a650513          	addi	a0,a0,1958 # 80022900 <ftable>
    80004162:	a6dfc0ef          	jal	80000bce <acquire>
  if(f->ref < 1)
    80004166:	40dc                	lw	a5,4(s1)
    80004168:	02f05063          	blez	a5,80004188 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000416c:	2785                	addiw	a5,a5,1
    8000416e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004170:	0001e517          	auipc	a0,0x1e
    80004174:	79050513          	addi	a0,a0,1936 # 80022900 <ftable>
    80004178:	aeffc0ef          	jal	80000c66 <release>
  return f;
}
    8000417c:	8526                	mv	a0,s1
    8000417e:	60e2                	ld	ra,24(sp)
    80004180:	6442                	ld	s0,16(sp)
    80004182:	64a2                	ld	s1,8(sp)
    80004184:	6105                	addi	sp,sp,32
    80004186:	8082                	ret
    panic("filedup");
    80004188:	00003517          	auipc	a0,0x3
    8000418c:	53050513          	addi	a0,a0,1328 # 800076b8 <etext+0x6b8>
    80004190:	e50fc0ef          	jal	800007e0 <panic>

0000000080004194 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004194:	7139                	addi	sp,sp,-64
    80004196:	fc06                	sd	ra,56(sp)
    80004198:	f822                	sd	s0,48(sp)
    8000419a:	f426                	sd	s1,40(sp)
    8000419c:	0080                	addi	s0,sp,64
    8000419e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800041a0:	0001e517          	auipc	a0,0x1e
    800041a4:	76050513          	addi	a0,a0,1888 # 80022900 <ftable>
    800041a8:	a27fc0ef          	jal	80000bce <acquire>
  if(f->ref < 1)
    800041ac:	40dc                	lw	a5,4(s1)
    800041ae:	04f05a63          	blez	a5,80004202 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800041b2:	37fd                	addiw	a5,a5,-1
    800041b4:	0007871b          	sext.w	a4,a5
    800041b8:	c0dc                	sw	a5,4(s1)
    800041ba:	04e04e63          	bgtz	a4,80004216 <fileclose+0x82>
    800041be:	f04a                	sd	s2,32(sp)
    800041c0:	ec4e                	sd	s3,24(sp)
    800041c2:	e852                	sd	s4,16(sp)
    800041c4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800041c6:	0004a903          	lw	s2,0(s1)
    800041ca:	0094ca83          	lbu	s5,9(s1)
    800041ce:	0104ba03          	ld	s4,16(s1)
    800041d2:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800041d6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800041da:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800041de:	0001e517          	auipc	a0,0x1e
    800041e2:	72250513          	addi	a0,a0,1826 # 80022900 <ftable>
    800041e6:	a81fc0ef          	jal	80000c66 <release>

  if(ff.type == FD_PIPE){
    800041ea:	4785                	li	a5,1
    800041ec:	04f90063          	beq	s2,a5,8000422c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800041f0:	3979                	addiw	s2,s2,-2
    800041f2:	4785                	li	a5,1
    800041f4:	0527f563          	bgeu	a5,s2,8000423e <fileclose+0xaa>
    800041f8:	7902                	ld	s2,32(sp)
    800041fa:	69e2                	ld	s3,24(sp)
    800041fc:	6a42                	ld	s4,16(sp)
    800041fe:	6aa2                	ld	s5,8(sp)
    80004200:	a00d                	j	80004222 <fileclose+0x8e>
    80004202:	f04a                	sd	s2,32(sp)
    80004204:	ec4e                	sd	s3,24(sp)
    80004206:	e852                	sd	s4,16(sp)
    80004208:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000420a:	00003517          	auipc	a0,0x3
    8000420e:	4b650513          	addi	a0,a0,1206 # 800076c0 <etext+0x6c0>
    80004212:	dcefc0ef          	jal	800007e0 <panic>
    release(&ftable.lock);
    80004216:	0001e517          	auipc	a0,0x1e
    8000421a:	6ea50513          	addi	a0,a0,1770 # 80022900 <ftable>
    8000421e:	a49fc0ef          	jal	80000c66 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004222:	70e2                	ld	ra,56(sp)
    80004224:	7442                	ld	s0,48(sp)
    80004226:	74a2                	ld	s1,40(sp)
    80004228:	6121                	addi	sp,sp,64
    8000422a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000422c:	85d6                	mv	a1,s5
    8000422e:	8552                	mv	a0,s4
    80004230:	336000ef          	jal	80004566 <pipeclose>
    80004234:	7902                	ld	s2,32(sp)
    80004236:	69e2                	ld	s3,24(sp)
    80004238:	6a42                	ld	s4,16(sp)
    8000423a:	6aa2                	ld	s5,8(sp)
    8000423c:	b7dd                	j	80004222 <fileclose+0x8e>
    begin_op();
    8000423e:	b4bff0ef          	jal	80003d88 <begin_op>
    iput(ff.ip);
    80004242:	854e                	mv	a0,s3
    80004244:	adcff0ef          	jal	80003520 <iput>
    end_op();
    80004248:	babff0ef          	jal	80003df2 <end_op>
    8000424c:	7902                	ld	s2,32(sp)
    8000424e:	69e2                	ld	s3,24(sp)
    80004250:	6a42                	ld	s4,16(sp)
    80004252:	6aa2                	ld	s5,8(sp)
    80004254:	b7f9                	j	80004222 <fileclose+0x8e>

0000000080004256 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004256:	715d                	addi	sp,sp,-80
    80004258:	e486                	sd	ra,72(sp)
    8000425a:	e0a2                	sd	s0,64(sp)
    8000425c:	fc26                	sd	s1,56(sp)
    8000425e:	f44e                	sd	s3,40(sp)
    80004260:	0880                	addi	s0,sp,80
    80004262:	84aa                	mv	s1,a0
    80004264:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004266:	e68fd0ef          	jal	800018ce <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000426a:	409c                	lw	a5,0(s1)
    8000426c:	37f9                	addiw	a5,a5,-2
    8000426e:	4705                	li	a4,1
    80004270:	04f76063          	bltu	a4,a5,800042b0 <filestat+0x5a>
    80004274:	f84a                	sd	s2,48(sp)
    80004276:	892a                	mv	s2,a0
    ilock(f->ip);
    80004278:	6c88                	ld	a0,24(s1)
    8000427a:	924ff0ef          	jal	8000339e <ilock>
    stati(f->ip, &st);
    8000427e:	fb840593          	addi	a1,s0,-72
    80004282:	6c88                	ld	a0,24(s1)
    80004284:	c80ff0ef          	jal	80003704 <stati>
    iunlock(f->ip);
    80004288:	6c88                	ld	a0,24(s1)
    8000428a:	9c2ff0ef          	jal	8000344c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000428e:	46e1                	li	a3,24
    80004290:	fb840613          	addi	a2,s0,-72
    80004294:	85ce                	mv	a1,s3
    80004296:	05893503          	ld	a0,88(s2)
    8000429a:	b48fd0ef          	jal	800015e2 <copyout>
    8000429e:	41f5551b          	sraiw	a0,a0,0x1f
    800042a2:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800042a4:	60a6                	ld	ra,72(sp)
    800042a6:	6406                	ld	s0,64(sp)
    800042a8:	74e2                	ld	s1,56(sp)
    800042aa:	79a2                	ld	s3,40(sp)
    800042ac:	6161                	addi	sp,sp,80
    800042ae:	8082                	ret
  return -1;
    800042b0:	557d                	li	a0,-1
    800042b2:	bfcd                	j	800042a4 <filestat+0x4e>

00000000800042b4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800042b4:	7179                	addi	sp,sp,-48
    800042b6:	f406                	sd	ra,40(sp)
    800042b8:	f022                	sd	s0,32(sp)
    800042ba:	e84a                	sd	s2,16(sp)
    800042bc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800042be:	00854783          	lbu	a5,8(a0)
    800042c2:	cfd1                	beqz	a5,8000435e <fileread+0xaa>
    800042c4:	ec26                	sd	s1,24(sp)
    800042c6:	e44e                	sd	s3,8(sp)
    800042c8:	84aa                	mv	s1,a0
    800042ca:	89ae                	mv	s3,a1
    800042cc:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800042ce:	411c                	lw	a5,0(a0)
    800042d0:	4705                	li	a4,1
    800042d2:	04e78363          	beq	a5,a4,80004318 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800042d6:	470d                	li	a4,3
    800042d8:	04e78763          	beq	a5,a4,80004326 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800042dc:	4709                	li	a4,2
    800042de:	06e79a63          	bne	a5,a4,80004352 <fileread+0x9e>
    ilock(f->ip);
    800042e2:	6d08                	ld	a0,24(a0)
    800042e4:	8baff0ef          	jal	8000339e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800042e8:	874a                	mv	a4,s2
    800042ea:	5094                	lw	a3,32(s1)
    800042ec:	864e                	mv	a2,s3
    800042ee:	4585                	li	a1,1
    800042f0:	6c88                	ld	a0,24(s1)
    800042f2:	c3cff0ef          	jal	8000372e <readi>
    800042f6:	892a                	mv	s2,a0
    800042f8:	00a05563          	blez	a0,80004302 <fileread+0x4e>
      f->off += r;
    800042fc:	509c                	lw	a5,32(s1)
    800042fe:	9fa9                	addw	a5,a5,a0
    80004300:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004302:	6c88                	ld	a0,24(s1)
    80004304:	948ff0ef          	jal	8000344c <iunlock>
    80004308:	64e2                	ld	s1,24(sp)
    8000430a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000430c:	854a                	mv	a0,s2
    8000430e:	70a2                	ld	ra,40(sp)
    80004310:	7402                	ld	s0,32(sp)
    80004312:	6942                	ld	s2,16(sp)
    80004314:	6145                	addi	sp,sp,48
    80004316:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004318:	6908                	ld	a0,16(a0)
    8000431a:	388000ef          	jal	800046a2 <piperead>
    8000431e:	892a                	mv	s2,a0
    80004320:	64e2                	ld	s1,24(sp)
    80004322:	69a2                	ld	s3,8(sp)
    80004324:	b7e5                	j	8000430c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004326:	02451783          	lh	a5,36(a0)
    8000432a:	03079693          	slli	a3,a5,0x30
    8000432e:	92c1                	srli	a3,a3,0x30
    80004330:	4725                	li	a4,9
    80004332:	02d76863          	bltu	a4,a3,80004362 <fileread+0xae>
    80004336:	0792                	slli	a5,a5,0x4
    80004338:	0001e717          	auipc	a4,0x1e
    8000433c:	52870713          	addi	a4,a4,1320 # 80022860 <devsw>
    80004340:	97ba                	add	a5,a5,a4
    80004342:	639c                	ld	a5,0(a5)
    80004344:	c39d                	beqz	a5,8000436a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004346:	4505                	li	a0,1
    80004348:	9782                	jalr	a5
    8000434a:	892a                	mv	s2,a0
    8000434c:	64e2                	ld	s1,24(sp)
    8000434e:	69a2                	ld	s3,8(sp)
    80004350:	bf75                	j	8000430c <fileread+0x58>
    panic("fileread");
    80004352:	00003517          	auipc	a0,0x3
    80004356:	37e50513          	addi	a0,a0,894 # 800076d0 <etext+0x6d0>
    8000435a:	c86fc0ef          	jal	800007e0 <panic>
    return -1;
    8000435e:	597d                	li	s2,-1
    80004360:	b775                	j	8000430c <fileread+0x58>
      return -1;
    80004362:	597d                	li	s2,-1
    80004364:	64e2                	ld	s1,24(sp)
    80004366:	69a2                	ld	s3,8(sp)
    80004368:	b755                	j	8000430c <fileread+0x58>
    8000436a:	597d                	li	s2,-1
    8000436c:	64e2                	ld	s1,24(sp)
    8000436e:	69a2                	ld	s3,8(sp)
    80004370:	bf71                	j	8000430c <fileread+0x58>

0000000080004372 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004372:	00954783          	lbu	a5,9(a0)
    80004376:	10078b63          	beqz	a5,8000448c <filewrite+0x11a>
{
    8000437a:	715d                	addi	sp,sp,-80
    8000437c:	e486                	sd	ra,72(sp)
    8000437e:	e0a2                	sd	s0,64(sp)
    80004380:	f84a                	sd	s2,48(sp)
    80004382:	f052                	sd	s4,32(sp)
    80004384:	e85a                	sd	s6,16(sp)
    80004386:	0880                	addi	s0,sp,80
    80004388:	892a                	mv	s2,a0
    8000438a:	8b2e                	mv	s6,a1
    8000438c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    8000438e:	411c                	lw	a5,0(a0)
    80004390:	4705                	li	a4,1
    80004392:	02e78763          	beq	a5,a4,800043c0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004396:	470d                	li	a4,3
    80004398:	02e78863          	beq	a5,a4,800043c8 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000439c:	4709                	li	a4,2
    8000439e:	0ce79c63          	bne	a5,a4,80004476 <filewrite+0x104>
    800043a2:	f44e                	sd	s3,40(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800043a4:	0ac05863          	blez	a2,80004454 <filewrite+0xe2>
    800043a8:	fc26                	sd	s1,56(sp)
    800043aa:	ec56                	sd	s5,24(sp)
    800043ac:	e45e                	sd	s7,8(sp)
    800043ae:	e062                	sd	s8,0(sp)
    int i = 0;
    800043b0:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800043b2:	6b85                	lui	s7,0x1
    800043b4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800043b8:	6c05                	lui	s8,0x1
    800043ba:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800043be:	a8b5                	j	8000443a <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800043c0:	6908                	ld	a0,16(a0)
    800043c2:	1fc000ef          	jal	800045be <pipewrite>
    800043c6:	a04d                	j	80004468 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800043c8:	02451783          	lh	a5,36(a0)
    800043cc:	03079693          	slli	a3,a5,0x30
    800043d0:	92c1                	srli	a3,a3,0x30
    800043d2:	4725                	li	a4,9
    800043d4:	0ad76e63          	bltu	a4,a3,80004490 <filewrite+0x11e>
    800043d8:	0792                	slli	a5,a5,0x4
    800043da:	0001e717          	auipc	a4,0x1e
    800043de:	48670713          	addi	a4,a4,1158 # 80022860 <devsw>
    800043e2:	97ba                	add	a5,a5,a4
    800043e4:	679c                	ld	a5,8(a5)
    800043e6:	c7dd                	beqz	a5,80004494 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800043e8:	4505                	li	a0,1
    800043ea:	9782                	jalr	a5
    800043ec:	a8b5                	j	80004468 <filewrite+0xf6>
      if(n1 > max)
    800043ee:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800043f2:	997ff0ef          	jal	80003d88 <begin_op>
      ilock(f->ip);
    800043f6:	01893503          	ld	a0,24(s2)
    800043fa:	fa5fe0ef          	jal	8000339e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800043fe:	8756                	mv	a4,s5
    80004400:	02092683          	lw	a3,32(s2)
    80004404:	01698633          	add	a2,s3,s6
    80004408:	4585                	li	a1,1
    8000440a:	01893503          	ld	a0,24(s2)
    8000440e:	c1cff0ef          	jal	8000382a <writei>
    80004412:	84aa                	mv	s1,a0
    80004414:	00a05763          	blez	a0,80004422 <filewrite+0xb0>
        f->off += r;
    80004418:	02092783          	lw	a5,32(s2)
    8000441c:	9fa9                	addw	a5,a5,a0
    8000441e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004422:	01893503          	ld	a0,24(s2)
    80004426:	826ff0ef          	jal	8000344c <iunlock>
      end_op();
    8000442a:	9c9ff0ef          	jal	80003df2 <end_op>

      if(r != n1){
    8000442e:	029a9563          	bne	s5,s1,80004458 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004432:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004436:	0149da63          	bge	s3,s4,8000444a <filewrite+0xd8>
      int n1 = n - i;
    8000443a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000443e:	0004879b          	sext.w	a5,s1
    80004442:	fafbd6e3          	bge	s7,a5,800043ee <filewrite+0x7c>
    80004446:	84e2                	mv	s1,s8
    80004448:	b75d                	j	800043ee <filewrite+0x7c>
    8000444a:	74e2                	ld	s1,56(sp)
    8000444c:	6ae2                	ld	s5,24(sp)
    8000444e:	6ba2                	ld	s7,8(sp)
    80004450:	6c02                	ld	s8,0(sp)
    80004452:	a039                	j	80004460 <filewrite+0xee>
    int i = 0;
    80004454:	4981                	li	s3,0
    80004456:	a029                	j	80004460 <filewrite+0xee>
    80004458:	74e2                	ld	s1,56(sp)
    8000445a:	6ae2                	ld	s5,24(sp)
    8000445c:	6ba2                	ld	s7,8(sp)
    8000445e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004460:	033a1c63          	bne	s4,s3,80004498 <filewrite+0x126>
    80004464:	8552                	mv	a0,s4
    80004466:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004468:	60a6                	ld	ra,72(sp)
    8000446a:	6406                	ld	s0,64(sp)
    8000446c:	7942                	ld	s2,48(sp)
    8000446e:	7a02                	ld	s4,32(sp)
    80004470:	6b42                	ld	s6,16(sp)
    80004472:	6161                	addi	sp,sp,80
    80004474:	8082                	ret
    80004476:	fc26                	sd	s1,56(sp)
    80004478:	f44e                	sd	s3,40(sp)
    8000447a:	ec56                	sd	s5,24(sp)
    8000447c:	e45e                	sd	s7,8(sp)
    8000447e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004480:	00003517          	auipc	a0,0x3
    80004484:	26050513          	addi	a0,a0,608 # 800076e0 <etext+0x6e0>
    80004488:	b58fc0ef          	jal	800007e0 <panic>
    return -1;
    8000448c:	557d                	li	a0,-1
}
    8000448e:	8082                	ret
      return -1;
    80004490:	557d                	li	a0,-1
    80004492:	bfd9                	j	80004468 <filewrite+0xf6>
    80004494:	557d                	li	a0,-1
    80004496:	bfc9                	j	80004468 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004498:	557d                	li	a0,-1
    8000449a:	79a2                	ld	s3,40(sp)
    8000449c:	b7f1                	j	80004468 <filewrite+0xf6>

000000008000449e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000449e:	7179                	addi	sp,sp,-48
    800044a0:	f406                	sd	ra,40(sp)
    800044a2:	f022                	sd	s0,32(sp)
    800044a4:	ec26                	sd	s1,24(sp)
    800044a6:	e052                	sd	s4,0(sp)
    800044a8:	1800                	addi	s0,sp,48
    800044aa:	84aa                	mv	s1,a0
    800044ac:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800044ae:	0005b023          	sd	zero,0(a1)
    800044b2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800044b6:	c3bff0ef          	jal	800040f0 <filealloc>
    800044ba:	e088                	sd	a0,0(s1)
    800044bc:	c549                	beqz	a0,80004546 <pipealloc+0xa8>
    800044be:	c33ff0ef          	jal	800040f0 <filealloc>
    800044c2:	00aa3023          	sd	a0,0(s4)
    800044c6:	cd25                	beqz	a0,8000453e <pipealloc+0xa0>
    800044c8:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800044ca:	e34fc0ef          	jal	80000afe <kalloc>
    800044ce:	892a                	mv	s2,a0
    800044d0:	c12d                	beqz	a0,80004532 <pipealloc+0x94>
    800044d2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800044d4:	4985                	li	s3,1
    800044d6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800044da:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800044de:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800044e2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800044e6:	00003597          	auipc	a1,0x3
    800044ea:	f5258593          	addi	a1,a1,-174 # 80007438 <etext+0x438>
    800044ee:	e60fc0ef          	jal	80000b4e <initlock>
  (*f0)->type = FD_PIPE;
    800044f2:	609c                	ld	a5,0(s1)
    800044f4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800044f8:	609c                	ld	a5,0(s1)
    800044fa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800044fe:	609c                	ld	a5,0(s1)
    80004500:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004504:	609c                	ld	a5,0(s1)
    80004506:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000450a:	000a3783          	ld	a5,0(s4)
    8000450e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004512:	000a3783          	ld	a5,0(s4)
    80004516:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000451a:	000a3783          	ld	a5,0(s4)
    8000451e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004522:	000a3783          	ld	a5,0(s4)
    80004526:	0127b823          	sd	s2,16(a5)
  return 0;
    8000452a:	4501                	li	a0,0
    8000452c:	6942                	ld	s2,16(sp)
    8000452e:	69a2                	ld	s3,8(sp)
    80004530:	a01d                	j	80004556 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004532:	6088                	ld	a0,0(s1)
    80004534:	c119                	beqz	a0,8000453a <pipealloc+0x9c>
    80004536:	6942                	ld	s2,16(sp)
    80004538:	a029                	j	80004542 <pipealloc+0xa4>
    8000453a:	6942                	ld	s2,16(sp)
    8000453c:	a029                	j	80004546 <pipealloc+0xa8>
    8000453e:	6088                	ld	a0,0(s1)
    80004540:	c10d                	beqz	a0,80004562 <pipealloc+0xc4>
    fileclose(*f0);
    80004542:	c53ff0ef          	jal	80004194 <fileclose>
  if(*f1)
    80004546:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000454a:	557d                	li	a0,-1
  if(*f1)
    8000454c:	c789                	beqz	a5,80004556 <pipealloc+0xb8>
    fileclose(*f1);
    8000454e:	853e                	mv	a0,a5
    80004550:	c45ff0ef          	jal	80004194 <fileclose>
  return -1;
    80004554:	557d                	li	a0,-1
}
    80004556:	70a2                	ld	ra,40(sp)
    80004558:	7402                	ld	s0,32(sp)
    8000455a:	64e2                	ld	s1,24(sp)
    8000455c:	6a02                	ld	s4,0(sp)
    8000455e:	6145                	addi	sp,sp,48
    80004560:	8082                	ret
  return -1;
    80004562:	557d                	li	a0,-1
    80004564:	bfcd                	j	80004556 <pipealloc+0xb8>

0000000080004566 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004566:	1101                	addi	sp,sp,-32
    80004568:	ec06                	sd	ra,24(sp)
    8000456a:	e822                	sd	s0,16(sp)
    8000456c:	e426                	sd	s1,8(sp)
    8000456e:	e04a                	sd	s2,0(sp)
    80004570:	1000                	addi	s0,sp,32
    80004572:	84aa                	mv	s1,a0
    80004574:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004576:	e58fc0ef          	jal	80000bce <acquire>
  if(writable){
    8000457a:	02090763          	beqz	s2,800045a8 <pipeclose+0x42>
    pi->writeopen = 0;
    8000457e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004582:	21848513          	addi	a0,s1,536
    80004586:	a7ffd0ef          	jal	80002004 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000458a:	2204b783          	ld	a5,544(s1)
    8000458e:	e785                	bnez	a5,800045b6 <pipeclose+0x50>
    release(&pi->lock);
    80004590:	8526                	mv	a0,s1
    80004592:	ed4fc0ef          	jal	80000c66 <release>
    kfree((char*)pi);
    80004596:	8526                	mv	a0,s1
    80004598:	c84fc0ef          	jal	80000a1c <kfree>
  } else
    release(&pi->lock);
}
    8000459c:	60e2                	ld	ra,24(sp)
    8000459e:	6442                	ld	s0,16(sp)
    800045a0:	64a2                	ld	s1,8(sp)
    800045a2:	6902                	ld	s2,0(sp)
    800045a4:	6105                	addi	sp,sp,32
    800045a6:	8082                	ret
    pi->readopen = 0;
    800045a8:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800045ac:	21c48513          	addi	a0,s1,540
    800045b0:	a55fd0ef          	jal	80002004 <wakeup>
    800045b4:	bfd9                	j	8000458a <pipeclose+0x24>
    release(&pi->lock);
    800045b6:	8526                	mv	a0,s1
    800045b8:	eaefc0ef          	jal	80000c66 <release>
}
    800045bc:	b7c5                	j	8000459c <pipeclose+0x36>

00000000800045be <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800045be:	711d                	addi	sp,sp,-96
    800045c0:	ec86                	sd	ra,88(sp)
    800045c2:	e8a2                	sd	s0,80(sp)
    800045c4:	e4a6                	sd	s1,72(sp)
    800045c6:	e0ca                	sd	s2,64(sp)
    800045c8:	fc4e                	sd	s3,56(sp)
    800045ca:	f852                	sd	s4,48(sp)
    800045cc:	f456                	sd	s5,40(sp)
    800045ce:	1080                	addi	s0,sp,96
    800045d0:	84aa                	mv	s1,a0
    800045d2:	8aae                	mv	s5,a1
    800045d4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800045d6:	af8fd0ef          	jal	800018ce <myproc>
    800045da:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800045dc:	8526                	mv	a0,s1
    800045de:	df0fc0ef          	jal	80000bce <acquire>
  while(i < n){
    800045e2:	0b405a63          	blez	s4,80004696 <pipewrite+0xd8>
    800045e6:	f05a                	sd	s6,32(sp)
    800045e8:	ec5e                	sd	s7,24(sp)
    800045ea:	e862                	sd	s8,16(sp)
  int i = 0;
    800045ec:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800045ee:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800045f0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800045f4:	21c48b93          	addi	s7,s1,540
    800045f8:	a81d                	j	8000462e <pipewrite+0x70>
      release(&pi->lock);
    800045fa:	8526                	mv	a0,s1
    800045fc:	e6afc0ef          	jal	80000c66 <release>
      return -1;
    80004600:	597d                	li	s2,-1
    80004602:	7b02                	ld	s6,32(sp)
    80004604:	6be2                	ld	s7,24(sp)
    80004606:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004608:	854a                	mv	a0,s2
    8000460a:	60e6                	ld	ra,88(sp)
    8000460c:	6446                	ld	s0,80(sp)
    8000460e:	64a6                	ld	s1,72(sp)
    80004610:	6906                	ld	s2,64(sp)
    80004612:	79e2                	ld	s3,56(sp)
    80004614:	7a42                	ld	s4,48(sp)
    80004616:	7aa2                	ld	s5,40(sp)
    80004618:	6125                	addi	sp,sp,96
    8000461a:	8082                	ret
      wakeup(&pi->nread);
    8000461c:	8562                	mv	a0,s8
    8000461e:	9e7fd0ef          	jal	80002004 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004622:	85a6                	mv	a1,s1
    80004624:	855e                	mv	a0,s7
    80004626:	993fd0ef          	jal	80001fb8 <sleep>
  while(i < n){
    8000462a:	05495b63          	bge	s2,s4,80004680 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    8000462e:	2204a783          	lw	a5,544(s1)
    80004632:	d7e1                	beqz	a5,800045fa <pipewrite+0x3c>
    80004634:	854e                	mv	a0,s3
    80004636:	bbbfd0ef          	jal	800021f0 <killed>
    8000463a:	f161                	bnez	a0,800045fa <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000463c:	2184a783          	lw	a5,536(s1)
    80004640:	21c4a703          	lw	a4,540(s1)
    80004644:	2007879b          	addiw	a5,a5,512
    80004648:	fcf70ae3          	beq	a4,a5,8000461c <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000464c:	4685                	li	a3,1
    8000464e:	01590633          	add	a2,s2,s5
    80004652:	faf40593          	addi	a1,s0,-81
    80004656:	0589b503          	ld	a0,88(s3)
    8000465a:	86cfd0ef          	jal	800016c6 <copyin>
    8000465e:	03650e63          	beq	a0,s6,8000469a <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004662:	21c4a783          	lw	a5,540(s1)
    80004666:	0017871b          	addiw	a4,a5,1
    8000466a:	20e4ae23          	sw	a4,540(s1)
    8000466e:	1ff7f793          	andi	a5,a5,511
    80004672:	97a6                	add	a5,a5,s1
    80004674:	faf44703          	lbu	a4,-81(s0)
    80004678:	00e78c23          	sb	a4,24(a5)
      i++;
    8000467c:	2905                	addiw	s2,s2,1
    8000467e:	b775                	j	8000462a <pipewrite+0x6c>
    80004680:	7b02                	ld	s6,32(sp)
    80004682:	6be2                	ld	s7,24(sp)
    80004684:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004686:	21848513          	addi	a0,s1,536
    8000468a:	97bfd0ef          	jal	80002004 <wakeup>
  release(&pi->lock);
    8000468e:	8526                	mv	a0,s1
    80004690:	dd6fc0ef          	jal	80000c66 <release>
  return i;
    80004694:	bf95                	j	80004608 <pipewrite+0x4a>
  int i = 0;
    80004696:	4901                	li	s2,0
    80004698:	b7fd                	j	80004686 <pipewrite+0xc8>
    8000469a:	7b02                	ld	s6,32(sp)
    8000469c:	6be2                	ld	s7,24(sp)
    8000469e:	6c42                	ld	s8,16(sp)
    800046a0:	b7dd                	j	80004686 <pipewrite+0xc8>

00000000800046a2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800046a2:	715d                	addi	sp,sp,-80
    800046a4:	e486                	sd	ra,72(sp)
    800046a6:	e0a2                	sd	s0,64(sp)
    800046a8:	fc26                	sd	s1,56(sp)
    800046aa:	f84a                	sd	s2,48(sp)
    800046ac:	f44e                	sd	s3,40(sp)
    800046ae:	f052                	sd	s4,32(sp)
    800046b0:	ec56                	sd	s5,24(sp)
    800046b2:	0880                	addi	s0,sp,80
    800046b4:	84aa                	mv	s1,a0
    800046b6:	892e                	mv	s2,a1
    800046b8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800046ba:	a14fd0ef          	jal	800018ce <myproc>
    800046be:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800046c0:	8526                	mv	a0,s1
    800046c2:	d0cfc0ef          	jal	80000bce <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046c6:	2184a703          	lw	a4,536(s1)
    800046ca:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046ce:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046d2:	02f71563          	bne	a4,a5,800046fc <piperead+0x5a>
    800046d6:	2244a783          	lw	a5,548(s1)
    800046da:	cb85                	beqz	a5,8000470a <piperead+0x68>
    if(killed(pr)){
    800046dc:	8552                	mv	a0,s4
    800046de:	b13fd0ef          	jal	800021f0 <killed>
    800046e2:	ed19                	bnez	a0,80004700 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800046e4:	85a6                	mv	a1,s1
    800046e6:	854e                	mv	a0,s3
    800046e8:	8d1fd0ef          	jal	80001fb8 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800046ec:	2184a703          	lw	a4,536(s1)
    800046f0:	21c4a783          	lw	a5,540(s1)
    800046f4:	fef701e3          	beq	a4,a5,800046d6 <piperead+0x34>
    800046f8:	e85a                	sd	s6,16(sp)
    800046fa:	a809                	j	8000470c <piperead+0x6a>
    800046fc:	e85a                	sd	s6,16(sp)
    800046fe:	a039                	j	8000470c <piperead+0x6a>
      release(&pi->lock);
    80004700:	8526                	mv	a0,s1
    80004702:	d64fc0ef          	jal	80000c66 <release>
      return -1;
    80004706:	59fd                	li	s3,-1
    80004708:	a8b1                	j	80004764 <piperead+0xc2>
    8000470a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000470c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000470e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004710:	05505263          	blez	s5,80004754 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004714:	2184a783          	lw	a5,536(s1)
    80004718:	21c4a703          	lw	a4,540(s1)
    8000471c:	02f70c63          	beq	a4,a5,80004754 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004720:	0017871b          	addiw	a4,a5,1
    80004724:	20e4ac23          	sw	a4,536(s1)
    80004728:	1ff7f793          	andi	a5,a5,511
    8000472c:	97a6                	add	a5,a5,s1
    8000472e:	0187c783          	lbu	a5,24(a5)
    80004732:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004736:	4685                	li	a3,1
    80004738:	fbf40613          	addi	a2,s0,-65
    8000473c:	85ca                	mv	a1,s2
    8000473e:	058a3503          	ld	a0,88(s4)
    80004742:	ea1fc0ef          	jal	800015e2 <copyout>
    80004746:	01650763          	beq	a0,s6,80004754 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000474a:	2985                	addiw	s3,s3,1
    8000474c:	0905                	addi	s2,s2,1
    8000474e:	fd3a93e3          	bne	s5,s3,80004714 <piperead+0x72>
    80004752:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004754:	21c48513          	addi	a0,s1,540
    80004758:	8adfd0ef          	jal	80002004 <wakeup>
  release(&pi->lock);
    8000475c:	8526                	mv	a0,s1
    8000475e:	d08fc0ef          	jal	80000c66 <release>
    80004762:	6b42                	ld	s6,16(sp)
  return i;
}
    80004764:	854e                	mv	a0,s3
    80004766:	60a6                	ld	ra,72(sp)
    80004768:	6406                	ld	s0,64(sp)
    8000476a:	74e2                	ld	s1,56(sp)
    8000476c:	7942                	ld	s2,48(sp)
    8000476e:	79a2                	ld	s3,40(sp)
    80004770:	7a02                	ld	s4,32(sp)
    80004772:	6ae2                	ld	s5,24(sp)
    80004774:	6161                	addi	sp,sp,80
    80004776:	8082                	ret

0000000080004778 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004778:	1141                	addi	sp,sp,-16
    8000477a:	e422                	sd	s0,8(sp)
    8000477c:	0800                	addi	s0,sp,16
    8000477e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004780:	8905                	andi	a0,a0,1
    80004782:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004784:	8b89                	andi	a5,a5,2
    80004786:	c399                	beqz	a5,8000478c <flags2perm+0x14>
      perm |= PTE_W;
    80004788:	00456513          	ori	a0,a0,4
    return perm;
}
    8000478c:	6422                	ld	s0,8(sp)
    8000478e:	0141                	addi	sp,sp,16
    80004790:	8082                	ret

0000000080004792 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004792:	df010113          	addi	sp,sp,-528
    80004796:	20113423          	sd	ra,520(sp)
    8000479a:	20813023          	sd	s0,512(sp)
    8000479e:	ffa6                	sd	s1,504(sp)
    800047a0:	fbca                	sd	s2,496(sp)
    800047a2:	0c00                	addi	s0,sp,528
    800047a4:	892a                	mv	s2,a0
    800047a6:	dea43c23          	sd	a0,-520(s0)
    800047aa:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800047ae:	920fd0ef          	jal	800018ce <myproc>
    800047b2:	84aa                	mv	s1,a0

  begin_op();
    800047b4:	dd4ff0ef          	jal	80003d88 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800047b8:	854a                	mv	a0,s2
    800047ba:	bfaff0ef          	jal	80003bb4 <namei>
    800047be:	c931                	beqz	a0,80004812 <kexec+0x80>
    800047c0:	f3d2                	sd	s4,480(sp)
    800047c2:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800047c4:	bdbfe0ef          	jal	8000339e <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800047c8:	04000713          	li	a4,64
    800047cc:	4681                	li	a3,0
    800047ce:	e5040613          	addi	a2,s0,-432
    800047d2:	4581                	li	a1,0
    800047d4:	8552                	mv	a0,s4
    800047d6:	f59fe0ef          	jal	8000372e <readi>
    800047da:	04000793          	li	a5,64
    800047de:	00f51a63          	bne	a0,a5,800047f2 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    800047e2:	e5042703          	lw	a4,-432(s0)
    800047e6:	464c47b7          	lui	a5,0x464c4
    800047ea:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800047ee:	02f70663          	beq	a4,a5,8000481a <kexec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800047f2:	8552                	mv	a0,s4
    800047f4:	db5fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    800047f8:	dfaff0ef          	jal	80003df2 <end_op>
  }
  return -1;
    800047fc:	557d                	li	a0,-1
    800047fe:	7a1e                	ld	s4,480(sp)
}
    80004800:	20813083          	ld	ra,520(sp)
    80004804:	20013403          	ld	s0,512(sp)
    80004808:	74fe                	ld	s1,504(sp)
    8000480a:	795e                	ld	s2,496(sp)
    8000480c:	21010113          	addi	sp,sp,528
    80004810:	8082                	ret
    end_op();
    80004812:	de0ff0ef          	jal	80003df2 <end_op>
    return -1;
    80004816:	557d                	li	a0,-1
    80004818:	b7e5                	j	80004800 <kexec+0x6e>
    8000481a:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000481c:	8526                	mv	a0,s1
    8000481e:	a9afd0ef          	jal	80001ab8 <proc_pagetable>
    80004822:	8b2a                	mv	s6,a0
    80004824:	2c050b63          	beqz	a0,80004afa <kexec+0x368>
    80004828:	f7ce                	sd	s3,488(sp)
    8000482a:	efd6                	sd	s5,472(sp)
    8000482c:	e7de                	sd	s7,456(sp)
    8000482e:	e3e2                	sd	s8,448(sp)
    80004830:	ff66                	sd	s9,440(sp)
    80004832:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004834:	e7042d03          	lw	s10,-400(s0)
    80004838:	e8845783          	lhu	a5,-376(s0)
    8000483c:	12078963          	beqz	a5,8000496e <kexec+0x1dc>
    80004840:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004842:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004844:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004846:	6c85                	lui	s9,0x1
    80004848:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000484c:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004850:	6a85                	lui	s5,0x1
    80004852:	a085                	j	800048b2 <kexec+0x120>
      panic("loadseg: address should exist");
    80004854:	00003517          	auipc	a0,0x3
    80004858:	e9c50513          	addi	a0,a0,-356 # 800076f0 <etext+0x6f0>
    8000485c:	f85fb0ef          	jal	800007e0 <panic>
    if(sz - i < PGSIZE)
    80004860:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004862:	8726                	mv	a4,s1
    80004864:	012c06bb          	addw	a3,s8,s2
    80004868:	4581                	li	a1,0
    8000486a:	8552                	mv	a0,s4
    8000486c:	ec3fe0ef          	jal	8000372e <readi>
    80004870:	2501                	sext.w	a0,a0
    80004872:	24a49a63          	bne	s1,a0,80004ac6 <kexec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004876:	012a893b          	addw	s2,s5,s2
    8000487a:	03397363          	bgeu	s2,s3,800048a0 <kexec+0x10e>
    pa = walkaddr(pagetable, va + i);
    8000487e:	02091593          	slli	a1,s2,0x20
    80004882:	9181                	srli	a1,a1,0x20
    80004884:	95de                	add	a1,a1,s7
    80004886:	855a                	mv	a0,s6
    80004888:	f28fc0ef          	jal	80000fb0 <walkaddr>
    8000488c:	862a                	mv	a2,a0
    if(pa == 0)
    8000488e:	d179                	beqz	a0,80004854 <kexec+0xc2>
    if(sz - i < PGSIZE)
    80004890:	412984bb          	subw	s1,s3,s2
    80004894:	0004879b          	sext.w	a5,s1
    80004898:	fcfcf4e3          	bgeu	s9,a5,80004860 <kexec+0xce>
    8000489c:	84d6                	mv	s1,s5
    8000489e:	b7c9                	j	80004860 <kexec+0xce>
    sz = sz1;
    800048a0:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048a4:	2d85                	addiw	s11,s11,1
    800048a6:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    800048aa:	e8845783          	lhu	a5,-376(s0)
    800048ae:	08fdd063          	bge	s11,a5,8000492e <kexec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800048b2:	2d01                	sext.w	s10,s10
    800048b4:	03800713          	li	a4,56
    800048b8:	86ea                	mv	a3,s10
    800048ba:	e1840613          	addi	a2,s0,-488
    800048be:	4581                	li	a1,0
    800048c0:	8552                	mv	a0,s4
    800048c2:	e6dfe0ef          	jal	8000372e <readi>
    800048c6:	03800793          	li	a5,56
    800048ca:	1cf51663          	bne	a0,a5,80004a96 <kexec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    800048ce:	e1842783          	lw	a5,-488(s0)
    800048d2:	4705                	li	a4,1
    800048d4:	fce798e3          	bne	a5,a4,800048a4 <kexec+0x112>
    if(ph.memsz < ph.filesz)
    800048d8:	e4043483          	ld	s1,-448(s0)
    800048dc:	e3843783          	ld	a5,-456(s0)
    800048e0:	1af4ef63          	bltu	s1,a5,80004a9e <kexec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800048e4:	e2843783          	ld	a5,-472(s0)
    800048e8:	94be                	add	s1,s1,a5
    800048ea:	1af4ee63          	bltu	s1,a5,80004aa6 <kexec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800048ee:	df043703          	ld	a4,-528(s0)
    800048f2:	8ff9                	and	a5,a5,a4
    800048f4:	1a079d63          	bnez	a5,80004aae <kexec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800048f8:	e1c42503          	lw	a0,-484(s0)
    800048fc:	e7dff0ef          	jal	80004778 <flags2perm>
    80004900:	86aa                	mv	a3,a0
    80004902:	8626                	mv	a2,s1
    80004904:	85ca                	mv	a1,s2
    80004906:	855a                	mv	a0,s6
    80004908:	981fc0ef          	jal	80001288 <uvmalloc>
    8000490c:	e0a43423          	sd	a0,-504(s0)
    80004910:	1a050363          	beqz	a0,80004ab6 <kexec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004914:	e2843b83          	ld	s7,-472(s0)
    80004918:	e2042c03          	lw	s8,-480(s0)
    8000491c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004920:	00098463          	beqz	s3,80004928 <kexec+0x196>
    80004924:	4901                	li	s2,0
    80004926:	bfa1                	j	8000487e <kexec+0xec>
    sz = sz1;
    80004928:	e0843903          	ld	s2,-504(s0)
    8000492c:	bfa5                	j	800048a4 <kexec+0x112>
    8000492e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004930:	8552                	mv	a0,s4
    80004932:	c77fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80004936:	cbcff0ef          	jal	80003df2 <end_op>
  p = myproc();
    8000493a:	f95fc0ef          	jal	800018ce <myproc>
    8000493e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004940:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    80004944:	6985                	lui	s3,0x1
    80004946:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004948:	99ca                	add	s3,s3,s2
    8000494a:	77fd                	lui	a5,0xfffff
    8000494c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004950:	4691                	li	a3,4
    80004952:	6609                	lui	a2,0x2
    80004954:	964e                	add	a2,a2,s3
    80004956:	85ce                	mv	a1,s3
    80004958:	855a                	mv	a0,s6
    8000495a:	92ffc0ef          	jal	80001288 <uvmalloc>
    8000495e:	892a                	mv	s2,a0
    80004960:	e0a43423          	sd	a0,-504(s0)
    80004964:	e519                	bnez	a0,80004972 <kexec+0x1e0>
  if(pagetable)
    80004966:	e1343423          	sd	s3,-504(s0)
    8000496a:	4a01                	li	s4,0
    8000496c:	aab1                	j	80004ac8 <kexec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000496e:	4901                	li	s2,0
    80004970:	b7c1                	j	80004930 <kexec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004972:	75f9                	lui	a1,0xffffe
    80004974:	95aa                	add	a1,a1,a0
    80004976:	855a                	mv	a0,s6
    80004978:	ae7fc0ef          	jal	8000145e <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000497c:	7bfd                	lui	s7,0xfffff
    8000497e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004980:	e0043783          	ld	a5,-512(s0)
    80004984:	6388                	ld	a0,0(a5)
    80004986:	cd39                	beqz	a0,800049e4 <kexec+0x252>
    80004988:	e9040993          	addi	s3,s0,-368
    8000498c:	f9040c13          	addi	s8,s0,-112
    80004990:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004992:	c80fc0ef          	jal	80000e12 <strlen>
    80004996:	0015079b          	addiw	a5,a0,1
    8000499a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000499e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800049a2:	11796e63          	bltu	s2,s7,80004abe <kexec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800049a6:	e0043d03          	ld	s10,-512(s0)
    800049aa:	000d3a03          	ld	s4,0(s10)
    800049ae:	8552                	mv	a0,s4
    800049b0:	c62fc0ef          	jal	80000e12 <strlen>
    800049b4:	0015069b          	addiw	a3,a0,1
    800049b8:	8652                	mv	a2,s4
    800049ba:	85ca                	mv	a1,s2
    800049bc:	855a                	mv	a0,s6
    800049be:	c25fc0ef          	jal	800015e2 <copyout>
    800049c2:	10054063          	bltz	a0,80004ac2 <kexec+0x330>
    ustack[argc] = sp;
    800049c6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800049ca:	0485                	addi	s1,s1,1
    800049cc:	008d0793          	addi	a5,s10,8
    800049d0:	e0f43023          	sd	a5,-512(s0)
    800049d4:	008d3503          	ld	a0,8(s10)
    800049d8:	c909                	beqz	a0,800049ea <kexec+0x258>
    if(argc >= MAXARG)
    800049da:	09a1                	addi	s3,s3,8
    800049dc:	fb899be3          	bne	s3,s8,80004992 <kexec+0x200>
  ip = 0;
    800049e0:	4a01                	li	s4,0
    800049e2:	a0dd                	j	80004ac8 <kexec+0x336>
  sp = sz;
    800049e4:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800049e8:	4481                	li	s1,0
  ustack[argc] = 0;
    800049ea:	00349793          	slli	a5,s1,0x3
    800049ee:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdb598>
    800049f2:	97a2                	add	a5,a5,s0
    800049f4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800049f8:	00148693          	addi	a3,s1,1
    800049fc:	068e                	slli	a3,a3,0x3
    800049fe:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004a02:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004a06:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004a0a:	f5796ee3          	bltu	s2,s7,80004966 <kexec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004a0e:	e9040613          	addi	a2,s0,-368
    80004a12:	85ca                	mv	a1,s2
    80004a14:	855a                	mv	a0,s6
    80004a16:	bcdfc0ef          	jal	800015e2 <copyout>
    80004a1a:	0e054263          	bltz	a0,80004afe <kexec+0x36c>
  p->trapframe->a1 = sp;
    80004a1e:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80004a22:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004a26:	df843783          	ld	a5,-520(s0)
    80004a2a:	0007c703          	lbu	a4,0(a5)
    80004a2e:	cf11                	beqz	a4,80004a4a <kexec+0x2b8>
    80004a30:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004a32:	02f00693          	li	a3,47
    80004a36:	a039                	j	80004a44 <kexec+0x2b2>
      last = s+1;
    80004a38:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004a3c:	0785                	addi	a5,a5,1
    80004a3e:	fff7c703          	lbu	a4,-1(a5)
    80004a42:	c701                	beqz	a4,80004a4a <kexec+0x2b8>
    if(*s == '/')
    80004a44:	fed71ce3          	bne	a4,a3,80004a3c <kexec+0x2aa>
    80004a48:	bfc5                	j	80004a38 <kexec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004a4a:	4641                	li	a2,16
    80004a4c:	df843583          	ld	a1,-520(s0)
    80004a50:	160a8513          	addi	a0,s5,352
    80004a54:	b8cfc0ef          	jal	80000de0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004a58:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80004a5c:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80004a60:	e0843783          	ld	a5,-504(s0)
    80004a64:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004a68:	060ab783          	ld	a5,96(s5)
    80004a6c:	e6843703          	ld	a4,-408(s0)
    80004a70:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004a72:	060ab783          	ld	a5,96(s5)
    80004a76:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004a7a:	85e6                	mv	a1,s9
    80004a7c:	8c0fd0ef          	jal	80001b3c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004a80:	0004851b          	sext.w	a0,s1
    80004a84:	79be                	ld	s3,488(sp)
    80004a86:	7a1e                	ld	s4,480(sp)
    80004a88:	6afe                	ld	s5,472(sp)
    80004a8a:	6b5e                	ld	s6,464(sp)
    80004a8c:	6bbe                	ld	s7,456(sp)
    80004a8e:	6c1e                	ld	s8,448(sp)
    80004a90:	7cfa                	ld	s9,440(sp)
    80004a92:	7d5a                	ld	s10,432(sp)
    80004a94:	b3b5                	j	80004800 <kexec+0x6e>
    80004a96:	e1243423          	sd	s2,-504(s0)
    80004a9a:	7dba                	ld	s11,424(sp)
    80004a9c:	a035                	j	80004ac8 <kexec+0x336>
    80004a9e:	e1243423          	sd	s2,-504(s0)
    80004aa2:	7dba                	ld	s11,424(sp)
    80004aa4:	a015                	j	80004ac8 <kexec+0x336>
    80004aa6:	e1243423          	sd	s2,-504(s0)
    80004aaa:	7dba                	ld	s11,424(sp)
    80004aac:	a831                	j	80004ac8 <kexec+0x336>
    80004aae:	e1243423          	sd	s2,-504(s0)
    80004ab2:	7dba                	ld	s11,424(sp)
    80004ab4:	a811                	j	80004ac8 <kexec+0x336>
    80004ab6:	e1243423          	sd	s2,-504(s0)
    80004aba:	7dba                	ld	s11,424(sp)
    80004abc:	a031                	j	80004ac8 <kexec+0x336>
  ip = 0;
    80004abe:	4a01                	li	s4,0
    80004ac0:	a021                	j	80004ac8 <kexec+0x336>
    80004ac2:	4a01                	li	s4,0
  if(pagetable)
    80004ac4:	a011                	j	80004ac8 <kexec+0x336>
    80004ac6:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004ac8:	e0843583          	ld	a1,-504(s0)
    80004acc:	855a                	mv	a0,s6
    80004ace:	86efd0ef          	jal	80001b3c <proc_freepagetable>
  return -1;
    80004ad2:	557d                	li	a0,-1
  if(ip){
    80004ad4:	000a1b63          	bnez	s4,80004aea <kexec+0x358>
    80004ad8:	79be                	ld	s3,488(sp)
    80004ada:	7a1e                	ld	s4,480(sp)
    80004adc:	6afe                	ld	s5,472(sp)
    80004ade:	6b5e                	ld	s6,464(sp)
    80004ae0:	6bbe                	ld	s7,456(sp)
    80004ae2:	6c1e                	ld	s8,448(sp)
    80004ae4:	7cfa                	ld	s9,440(sp)
    80004ae6:	7d5a                	ld	s10,432(sp)
    80004ae8:	bb21                	j	80004800 <kexec+0x6e>
    80004aea:	79be                	ld	s3,488(sp)
    80004aec:	6afe                	ld	s5,472(sp)
    80004aee:	6b5e                	ld	s6,464(sp)
    80004af0:	6bbe                	ld	s7,456(sp)
    80004af2:	6c1e                	ld	s8,448(sp)
    80004af4:	7cfa                	ld	s9,440(sp)
    80004af6:	7d5a                	ld	s10,432(sp)
    80004af8:	b9ed                	j	800047f2 <kexec+0x60>
    80004afa:	6b5e                	ld	s6,464(sp)
    80004afc:	b9dd                	j	800047f2 <kexec+0x60>
  sz = sz1;
    80004afe:	e0843983          	ld	s3,-504(s0)
    80004b02:	b595                	j	80004966 <kexec+0x1d4>

0000000080004b04 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004b04:	7179                	addi	sp,sp,-48
    80004b06:	f406                	sd	ra,40(sp)
    80004b08:	f022                	sd	s0,32(sp)
    80004b0a:	ec26                	sd	s1,24(sp)
    80004b0c:	e84a                	sd	s2,16(sp)
    80004b0e:	1800                	addi	s0,sp,48
    80004b10:	892e                	mv	s2,a1
    80004b12:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004b14:	fdc40593          	addi	a1,s0,-36
    80004b18:	da5fd0ef          	jal	800028bc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004b1c:	fdc42703          	lw	a4,-36(s0)
    80004b20:	47bd                	li	a5,15
    80004b22:	02e7e963          	bltu	a5,a4,80004b54 <argfd+0x50>
    80004b26:	da9fc0ef          	jal	800018ce <myproc>
    80004b2a:	fdc42703          	lw	a4,-36(s0)
    80004b2e:	01a70793          	addi	a5,a4,26
    80004b32:	078e                	slli	a5,a5,0x3
    80004b34:	953e                	add	a0,a0,a5
    80004b36:	651c                	ld	a5,8(a0)
    80004b38:	c385                	beqz	a5,80004b58 <argfd+0x54>
    return -1;
  if(pfd)
    80004b3a:	00090463          	beqz	s2,80004b42 <argfd+0x3e>
    *pfd = fd;
    80004b3e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004b42:	4501                	li	a0,0
  if(pf)
    80004b44:	c091                	beqz	s1,80004b48 <argfd+0x44>
    *pf = f;
    80004b46:	e09c                	sd	a5,0(s1)
}
    80004b48:	70a2                	ld	ra,40(sp)
    80004b4a:	7402                	ld	s0,32(sp)
    80004b4c:	64e2                	ld	s1,24(sp)
    80004b4e:	6942                	ld	s2,16(sp)
    80004b50:	6145                	addi	sp,sp,48
    80004b52:	8082                	ret
    return -1;
    80004b54:	557d                	li	a0,-1
    80004b56:	bfcd                	j	80004b48 <argfd+0x44>
    80004b58:	557d                	li	a0,-1
    80004b5a:	b7fd                	j	80004b48 <argfd+0x44>

0000000080004b5c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004b5c:	1101                	addi	sp,sp,-32
    80004b5e:	ec06                	sd	ra,24(sp)
    80004b60:	e822                	sd	s0,16(sp)
    80004b62:	e426                	sd	s1,8(sp)
    80004b64:	1000                	addi	s0,sp,32
    80004b66:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004b68:	d67fc0ef          	jal	800018ce <myproc>
    80004b6c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004b6e:	0d850793          	addi	a5,a0,216
    80004b72:	4501                	li	a0,0
    80004b74:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004b76:	6398                	ld	a4,0(a5)
    80004b78:	cb19                	beqz	a4,80004b8e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004b7a:	2505                	addiw	a0,a0,1
    80004b7c:	07a1                	addi	a5,a5,8
    80004b7e:	fed51ce3          	bne	a0,a3,80004b76 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004b82:	557d                	li	a0,-1
}
    80004b84:	60e2                	ld	ra,24(sp)
    80004b86:	6442                	ld	s0,16(sp)
    80004b88:	64a2                	ld	s1,8(sp)
    80004b8a:	6105                	addi	sp,sp,32
    80004b8c:	8082                	ret
      p->ofile[fd] = f;
    80004b8e:	01a50793          	addi	a5,a0,26
    80004b92:	078e                	slli	a5,a5,0x3
    80004b94:	963e                	add	a2,a2,a5
    80004b96:	e604                	sd	s1,8(a2)
      return fd;
    80004b98:	b7f5                	j	80004b84 <fdalloc+0x28>

0000000080004b9a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004b9a:	715d                	addi	sp,sp,-80
    80004b9c:	e486                	sd	ra,72(sp)
    80004b9e:	e0a2                	sd	s0,64(sp)
    80004ba0:	fc26                	sd	s1,56(sp)
    80004ba2:	f84a                	sd	s2,48(sp)
    80004ba4:	f44e                	sd	s3,40(sp)
    80004ba6:	ec56                	sd	s5,24(sp)
    80004ba8:	e85a                	sd	s6,16(sp)
    80004baa:	0880                	addi	s0,sp,80
    80004bac:	8b2e                	mv	s6,a1
    80004bae:	89b2                	mv	s3,a2
    80004bb0:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004bb2:	fb040593          	addi	a1,s0,-80
    80004bb6:	818ff0ef          	jal	80003bce <nameiparent>
    80004bba:	84aa                	mv	s1,a0
    80004bbc:	10050a63          	beqz	a0,80004cd0 <create+0x136>
    return 0;

  ilock(dp);
    80004bc0:	fdefe0ef          	jal	8000339e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004bc4:	4601                	li	a2,0
    80004bc6:	fb040593          	addi	a1,s0,-80
    80004bca:	8526                	mv	a0,s1
    80004bcc:	d83fe0ef          	jal	8000394e <dirlookup>
    80004bd0:	8aaa                	mv	s5,a0
    80004bd2:	c129                	beqz	a0,80004c14 <create+0x7a>
    iunlockput(dp);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	9d3fe0ef          	jal	800035a8 <iunlockput>
    ilock(ip);
    80004bda:	8556                	mv	a0,s5
    80004bdc:	fc2fe0ef          	jal	8000339e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004be0:	4789                	li	a5,2
    80004be2:	02fb1463          	bne	s6,a5,80004c0a <create+0x70>
    80004be6:	044ad783          	lhu	a5,68(s5)
    80004bea:	37f9                	addiw	a5,a5,-2
    80004bec:	17c2                	slli	a5,a5,0x30
    80004bee:	93c1                	srli	a5,a5,0x30
    80004bf0:	4705                	li	a4,1
    80004bf2:	00f76c63          	bltu	a4,a5,80004c0a <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004bf6:	8556                	mv	a0,s5
    80004bf8:	60a6                	ld	ra,72(sp)
    80004bfa:	6406                	ld	s0,64(sp)
    80004bfc:	74e2                	ld	s1,56(sp)
    80004bfe:	7942                	ld	s2,48(sp)
    80004c00:	79a2                	ld	s3,40(sp)
    80004c02:	6ae2                	ld	s5,24(sp)
    80004c04:	6b42                	ld	s6,16(sp)
    80004c06:	6161                	addi	sp,sp,80
    80004c08:	8082                	ret
    iunlockput(ip);
    80004c0a:	8556                	mv	a0,s5
    80004c0c:	99dfe0ef          	jal	800035a8 <iunlockput>
    return 0;
    80004c10:	4a81                	li	s5,0
    80004c12:	b7d5                	j	80004bf6 <create+0x5c>
    80004c14:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004c16:	85da                	mv	a1,s6
    80004c18:	4088                	lw	a0,0(s1)
    80004c1a:	e14fe0ef          	jal	8000322e <ialloc>
    80004c1e:	8a2a                	mv	s4,a0
    80004c20:	cd15                	beqz	a0,80004c5c <create+0xc2>
  ilock(ip);
    80004c22:	f7cfe0ef          	jal	8000339e <ilock>
  ip->major = major;
    80004c26:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004c2a:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004c2e:	4905                	li	s2,1
    80004c30:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004c34:	8552                	mv	a0,s4
    80004c36:	eb4fe0ef          	jal	800032ea <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004c3a:	032b0763          	beq	s6,s2,80004c68 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c3e:	004a2603          	lw	a2,4(s4)
    80004c42:	fb040593          	addi	a1,s0,-80
    80004c46:	8526                	mv	a0,s1
    80004c48:	ed3fe0ef          	jal	80003b1a <dirlink>
    80004c4c:	06054563          	bltz	a0,80004cb6 <create+0x11c>
  iunlockput(dp);
    80004c50:	8526                	mv	a0,s1
    80004c52:	957fe0ef          	jal	800035a8 <iunlockput>
  return ip;
    80004c56:	8ad2                	mv	s5,s4
    80004c58:	7a02                	ld	s4,32(sp)
    80004c5a:	bf71                	j	80004bf6 <create+0x5c>
    iunlockput(dp);
    80004c5c:	8526                	mv	a0,s1
    80004c5e:	94bfe0ef          	jal	800035a8 <iunlockput>
    return 0;
    80004c62:	8ad2                	mv	s5,s4
    80004c64:	7a02                	ld	s4,32(sp)
    80004c66:	bf41                	j	80004bf6 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004c68:	004a2603          	lw	a2,4(s4)
    80004c6c:	00003597          	auipc	a1,0x3
    80004c70:	aa458593          	addi	a1,a1,-1372 # 80007710 <etext+0x710>
    80004c74:	8552                	mv	a0,s4
    80004c76:	ea5fe0ef          	jal	80003b1a <dirlink>
    80004c7a:	02054e63          	bltz	a0,80004cb6 <create+0x11c>
    80004c7e:	40d0                	lw	a2,4(s1)
    80004c80:	00003597          	auipc	a1,0x3
    80004c84:	a9858593          	addi	a1,a1,-1384 # 80007718 <etext+0x718>
    80004c88:	8552                	mv	a0,s4
    80004c8a:	e91fe0ef          	jal	80003b1a <dirlink>
    80004c8e:	02054463          	bltz	a0,80004cb6 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004c92:	004a2603          	lw	a2,4(s4)
    80004c96:	fb040593          	addi	a1,s0,-80
    80004c9a:	8526                	mv	a0,s1
    80004c9c:	e7ffe0ef          	jal	80003b1a <dirlink>
    80004ca0:	00054b63          	bltz	a0,80004cb6 <create+0x11c>
    dp->nlink++;  // for ".."
    80004ca4:	04a4d783          	lhu	a5,74(s1)
    80004ca8:	2785                	addiw	a5,a5,1
    80004caa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cae:	8526                	mv	a0,s1
    80004cb0:	e3afe0ef          	jal	800032ea <iupdate>
    80004cb4:	bf71                	j	80004c50 <create+0xb6>
  ip->nlink = 0;
    80004cb6:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004cba:	8552                	mv	a0,s4
    80004cbc:	e2efe0ef          	jal	800032ea <iupdate>
  iunlockput(ip);
    80004cc0:	8552                	mv	a0,s4
    80004cc2:	8e7fe0ef          	jal	800035a8 <iunlockput>
  iunlockput(dp);
    80004cc6:	8526                	mv	a0,s1
    80004cc8:	8e1fe0ef          	jal	800035a8 <iunlockput>
  return 0;
    80004ccc:	7a02                	ld	s4,32(sp)
    80004cce:	b725                	j	80004bf6 <create+0x5c>
    return 0;
    80004cd0:	8aaa                	mv	s5,a0
    80004cd2:	b715                	j	80004bf6 <create+0x5c>

0000000080004cd4 <sys_dup>:
{
    80004cd4:	7179                	addi	sp,sp,-48
    80004cd6:	f406                	sd	ra,40(sp)
    80004cd8:	f022                	sd	s0,32(sp)
    80004cda:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004cdc:	fd840613          	addi	a2,s0,-40
    80004ce0:	4581                	li	a1,0
    80004ce2:	4501                	li	a0,0
    80004ce4:	e21ff0ef          	jal	80004b04 <argfd>
    return -1;
    80004ce8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004cea:	02054363          	bltz	a0,80004d10 <sys_dup+0x3c>
    80004cee:	ec26                	sd	s1,24(sp)
    80004cf0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004cf2:	fd843903          	ld	s2,-40(s0)
    80004cf6:	854a                	mv	a0,s2
    80004cf8:	e65ff0ef          	jal	80004b5c <fdalloc>
    80004cfc:	84aa                	mv	s1,a0
    return -1;
    80004cfe:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004d00:	00054d63          	bltz	a0,80004d1a <sys_dup+0x46>
  filedup(f);
    80004d04:	854a                	mv	a0,s2
    80004d06:	c48ff0ef          	jal	8000414e <filedup>
  return fd;
    80004d0a:	87a6                	mv	a5,s1
    80004d0c:	64e2                	ld	s1,24(sp)
    80004d0e:	6942                	ld	s2,16(sp)
}
    80004d10:	853e                	mv	a0,a5
    80004d12:	70a2                	ld	ra,40(sp)
    80004d14:	7402                	ld	s0,32(sp)
    80004d16:	6145                	addi	sp,sp,48
    80004d18:	8082                	ret
    80004d1a:	64e2                	ld	s1,24(sp)
    80004d1c:	6942                	ld	s2,16(sp)
    80004d1e:	bfcd                	j	80004d10 <sys_dup+0x3c>

0000000080004d20 <sys_read>:
{
    80004d20:	7179                	addi	sp,sp,-48
    80004d22:	f406                	sd	ra,40(sp)
    80004d24:	f022                	sd	s0,32(sp)
    80004d26:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d28:	fd840593          	addi	a1,s0,-40
    80004d2c:	4505                	li	a0,1
    80004d2e:	babfd0ef          	jal	800028d8 <argaddr>
  argint(2, &n);
    80004d32:	fe440593          	addi	a1,s0,-28
    80004d36:	4509                	li	a0,2
    80004d38:	b85fd0ef          	jal	800028bc <argint>
  if(argfd(0, 0, &f) < 0)
    80004d3c:	fe840613          	addi	a2,s0,-24
    80004d40:	4581                	li	a1,0
    80004d42:	4501                	li	a0,0
    80004d44:	dc1ff0ef          	jal	80004b04 <argfd>
    80004d48:	87aa                	mv	a5,a0
    return -1;
    80004d4a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d4c:	0007ca63          	bltz	a5,80004d60 <sys_read+0x40>
  return fileread(f, p, n);
    80004d50:	fe442603          	lw	a2,-28(s0)
    80004d54:	fd843583          	ld	a1,-40(s0)
    80004d58:	fe843503          	ld	a0,-24(s0)
    80004d5c:	d58ff0ef          	jal	800042b4 <fileread>
}
    80004d60:	70a2                	ld	ra,40(sp)
    80004d62:	7402                	ld	s0,32(sp)
    80004d64:	6145                	addi	sp,sp,48
    80004d66:	8082                	ret

0000000080004d68 <sys_write>:
{
    80004d68:	7179                	addi	sp,sp,-48
    80004d6a:	f406                	sd	ra,40(sp)
    80004d6c:	f022                	sd	s0,32(sp)
    80004d6e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004d70:	fd840593          	addi	a1,s0,-40
    80004d74:	4505                	li	a0,1
    80004d76:	b63fd0ef          	jal	800028d8 <argaddr>
  argint(2, &n);
    80004d7a:	fe440593          	addi	a1,s0,-28
    80004d7e:	4509                	li	a0,2
    80004d80:	b3dfd0ef          	jal	800028bc <argint>
  if(argfd(0, 0, &f) < 0)
    80004d84:	fe840613          	addi	a2,s0,-24
    80004d88:	4581                	li	a1,0
    80004d8a:	4501                	li	a0,0
    80004d8c:	d79ff0ef          	jal	80004b04 <argfd>
    80004d90:	87aa                	mv	a5,a0
    return -1;
    80004d92:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004d94:	0007ca63          	bltz	a5,80004da8 <sys_write+0x40>
  return filewrite(f, p, n);
    80004d98:	fe442603          	lw	a2,-28(s0)
    80004d9c:	fd843583          	ld	a1,-40(s0)
    80004da0:	fe843503          	ld	a0,-24(s0)
    80004da4:	dceff0ef          	jal	80004372 <filewrite>
}
    80004da8:	70a2                	ld	ra,40(sp)
    80004daa:	7402                	ld	s0,32(sp)
    80004dac:	6145                	addi	sp,sp,48
    80004dae:	8082                	ret

0000000080004db0 <sys_close>:
{
    80004db0:	1101                	addi	sp,sp,-32
    80004db2:	ec06                	sd	ra,24(sp)
    80004db4:	e822                	sd	s0,16(sp)
    80004db6:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004db8:	fe040613          	addi	a2,s0,-32
    80004dbc:	fec40593          	addi	a1,s0,-20
    80004dc0:	4501                	li	a0,0
    80004dc2:	d43ff0ef          	jal	80004b04 <argfd>
    return -1;
    80004dc6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004dc8:	02054063          	bltz	a0,80004de8 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004dcc:	b03fc0ef          	jal	800018ce <myproc>
    80004dd0:	fec42783          	lw	a5,-20(s0)
    80004dd4:	07e9                	addi	a5,a5,26
    80004dd6:	078e                	slli	a5,a5,0x3
    80004dd8:	953e                	add	a0,a0,a5
    80004dda:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004dde:	fe043503          	ld	a0,-32(s0)
    80004de2:	bb2ff0ef          	jal	80004194 <fileclose>
  return 0;
    80004de6:	4781                	li	a5,0
}
    80004de8:	853e                	mv	a0,a5
    80004dea:	60e2                	ld	ra,24(sp)
    80004dec:	6442                	ld	s0,16(sp)
    80004dee:	6105                	addi	sp,sp,32
    80004df0:	8082                	ret

0000000080004df2 <sys_fstat>:
{
    80004df2:	1101                	addi	sp,sp,-32
    80004df4:	ec06                	sd	ra,24(sp)
    80004df6:	e822                	sd	s0,16(sp)
    80004df8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004dfa:	fe040593          	addi	a1,s0,-32
    80004dfe:	4505                	li	a0,1
    80004e00:	ad9fd0ef          	jal	800028d8 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004e04:	fe840613          	addi	a2,s0,-24
    80004e08:	4581                	li	a1,0
    80004e0a:	4501                	li	a0,0
    80004e0c:	cf9ff0ef          	jal	80004b04 <argfd>
    80004e10:	87aa                	mv	a5,a0
    return -1;
    80004e12:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e14:	0007c863          	bltz	a5,80004e24 <sys_fstat+0x32>
  return filestat(f, st);
    80004e18:	fe043583          	ld	a1,-32(s0)
    80004e1c:	fe843503          	ld	a0,-24(s0)
    80004e20:	c36ff0ef          	jal	80004256 <filestat>
}
    80004e24:	60e2                	ld	ra,24(sp)
    80004e26:	6442                	ld	s0,16(sp)
    80004e28:	6105                	addi	sp,sp,32
    80004e2a:	8082                	ret

0000000080004e2c <sys_link>:
{
    80004e2c:	7169                	addi	sp,sp,-304
    80004e2e:	f606                	sd	ra,296(sp)
    80004e30:	f222                	sd	s0,288(sp)
    80004e32:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e34:	08000613          	li	a2,128
    80004e38:	ed040593          	addi	a1,s0,-304
    80004e3c:	4501                	li	a0,0
    80004e3e:	ab7fd0ef          	jal	800028f4 <argstr>
    return -1;
    80004e42:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e44:	0c054e63          	bltz	a0,80004f20 <sys_link+0xf4>
    80004e48:	08000613          	li	a2,128
    80004e4c:	f5040593          	addi	a1,s0,-176
    80004e50:	4505                	li	a0,1
    80004e52:	aa3fd0ef          	jal	800028f4 <argstr>
    return -1;
    80004e56:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004e58:	0c054463          	bltz	a0,80004f20 <sys_link+0xf4>
    80004e5c:	ee26                	sd	s1,280(sp)
  begin_op();
    80004e5e:	f2bfe0ef          	jal	80003d88 <begin_op>
  if((ip = namei(old)) == 0){
    80004e62:	ed040513          	addi	a0,s0,-304
    80004e66:	d4ffe0ef          	jal	80003bb4 <namei>
    80004e6a:	84aa                	mv	s1,a0
    80004e6c:	c53d                	beqz	a0,80004eda <sys_link+0xae>
  ilock(ip);
    80004e6e:	d30fe0ef          	jal	8000339e <ilock>
  if(ip->type == T_DIR){
    80004e72:	04449703          	lh	a4,68(s1)
    80004e76:	4785                	li	a5,1
    80004e78:	06f70663          	beq	a4,a5,80004ee4 <sys_link+0xb8>
    80004e7c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004e7e:	04a4d783          	lhu	a5,74(s1)
    80004e82:	2785                	addiw	a5,a5,1
    80004e84:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e88:	8526                	mv	a0,s1
    80004e8a:	c60fe0ef          	jal	800032ea <iupdate>
  iunlock(ip);
    80004e8e:	8526                	mv	a0,s1
    80004e90:	dbcfe0ef          	jal	8000344c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004e94:	fd040593          	addi	a1,s0,-48
    80004e98:	f5040513          	addi	a0,s0,-176
    80004e9c:	d33fe0ef          	jal	80003bce <nameiparent>
    80004ea0:	892a                	mv	s2,a0
    80004ea2:	cd21                	beqz	a0,80004efa <sys_link+0xce>
  ilock(dp);
    80004ea4:	cfafe0ef          	jal	8000339e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004ea8:	00092703          	lw	a4,0(s2)
    80004eac:	409c                	lw	a5,0(s1)
    80004eae:	04f71363          	bne	a4,a5,80004ef4 <sys_link+0xc8>
    80004eb2:	40d0                	lw	a2,4(s1)
    80004eb4:	fd040593          	addi	a1,s0,-48
    80004eb8:	854a                	mv	a0,s2
    80004eba:	c61fe0ef          	jal	80003b1a <dirlink>
    80004ebe:	02054b63          	bltz	a0,80004ef4 <sys_link+0xc8>
  iunlockput(dp);
    80004ec2:	854a                	mv	a0,s2
    80004ec4:	ee4fe0ef          	jal	800035a8 <iunlockput>
  iput(ip);
    80004ec8:	8526                	mv	a0,s1
    80004eca:	e56fe0ef          	jal	80003520 <iput>
  end_op();
    80004ece:	f25fe0ef          	jal	80003df2 <end_op>
  return 0;
    80004ed2:	4781                	li	a5,0
    80004ed4:	64f2                	ld	s1,280(sp)
    80004ed6:	6952                	ld	s2,272(sp)
    80004ed8:	a0a1                	j	80004f20 <sys_link+0xf4>
    end_op();
    80004eda:	f19fe0ef          	jal	80003df2 <end_op>
    return -1;
    80004ede:	57fd                	li	a5,-1
    80004ee0:	64f2                	ld	s1,280(sp)
    80004ee2:	a83d                	j	80004f20 <sys_link+0xf4>
    iunlockput(ip);
    80004ee4:	8526                	mv	a0,s1
    80004ee6:	ec2fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    80004eea:	f09fe0ef          	jal	80003df2 <end_op>
    return -1;
    80004eee:	57fd                	li	a5,-1
    80004ef0:	64f2                	ld	s1,280(sp)
    80004ef2:	a03d                	j	80004f20 <sys_link+0xf4>
    iunlockput(dp);
    80004ef4:	854a                	mv	a0,s2
    80004ef6:	eb2fe0ef          	jal	800035a8 <iunlockput>
  ilock(ip);
    80004efa:	8526                	mv	a0,s1
    80004efc:	ca2fe0ef          	jal	8000339e <ilock>
  ip->nlink--;
    80004f00:	04a4d783          	lhu	a5,74(s1)
    80004f04:	37fd                	addiw	a5,a5,-1
    80004f06:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f0a:	8526                	mv	a0,s1
    80004f0c:	bdefe0ef          	jal	800032ea <iupdate>
  iunlockput(ip);
    80004f10:	8526                	mv	a0,s1
    80004f12:	e96fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80004f16:	eddfe0ef          	jal	80003df2 <end_op>
  return -1;
    80004f1a:	57fd                	li	a5,-1
    80004f1c:	64f2                	ld	s1,280(sp)
    80004f1e:	6952                	ld	s2,272(sp)
}
    80004f20:	853e                	mv	a0,a5
    80004f22:	70b2                	ld	ra,296(sp)
    80004f24:	7412                	ld	s0,288(sp)
    80004f26:	6155                	addi	sp,sp,304
    80004f28:	8082                	ret

0000000080004f2a <sys_unlink>:
{
    80004f2a:	7151                	addi	sp,sp,-240
    80004f2c:	f586                	sd	ra,232(sp)
    80004f2e:	f1a2                	sd	s0,224(sp)
    80004f30:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004f32:	08000613          	li	a2,128
    80004f36:	f3040593          	addi	a1,s0,-208
    80004f3a:	4501                	li	a0,0
    80004f3c:	9b9fd0ef          	jal	800028f4 <argstr>
    80004f40:	16054063          	bltz	a0,800050a0 <sys_unlink+0x176>
    80004f44:	eda6                	sd	s1,216(sp)
  begin_op();
    80004f46:	e43fe0ef          	jal	80003d88 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004f4a:	fb040593          	addi	a1,s0,-80
    80004f4e:	f3040513          	addi	a0,s0,-208
    80004f52:	c7dfe0ef          	jal	80003bce <nameiparent>
    80004f56:	84aa                	mv	s1,a0
    80004f58:	c945                	beqz	a0,80005008 <sys_unlink+0xde>
  ilock(dp);
    80004f5a:	c44fe0ef          	jal	8000339e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004f5e:	00002597          	auipc	a1,0x2
    80004f62:	7b258593          	addi	a1,a1,1970 # 80007710 <etext+0x710>
    80004f66:	fb040513          	addi	a0,s0,-80
    80004f6a:	9cffe0ef          	jal	80003938 <namecmp>
    80004f6e:	10050e63          	beqz	a0,8000508a <sys_unlink+0x160>
    80004f72:	00002597          	auipc	a1,0x2
    80004f76:	7a658593          	addi	a1,a1,1958 # 80007718 <etext+0x718>
    80004f7a:	fb040513          	addi	a0,s0,-80
    80004f7e:	9bbfe0ef          	jal	80003938 <namecmp>
    80004f82:	10050463          	beqz	a0,8000508a <sys_unlink+0x160>
    80004f86:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004f88:	f2c40613          	addi	a2,s0,-212
    80004f8c:	fb040593          	addi	a1,s0,-80
    80004f90:	8526                	mv	a0,s1
    80004f92:	9bdfe0ef          	jal	8000394e <dirlookup>
    80004f96:	892a                	mv	s2,a0
    80004f98:	0e050863          	beqz	a0,80005088 <sys_unlink+0x15e>
  ilock(ip);
    80004f9c:	c02fe0ef          	jal	8000339e <ilock>
  if(ip->nlink < 1)
    80004fa0:	04a91783          	lh	a5,74(s2)
    80004fa4:	06f05763          	blez	a5,80005012 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004fa8:	04491703          	lh	a4,68(s2)
    80004fac:	4785                	li	a5,1
    80004fae:	06f70963          	beq	a4,a5,80005020 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004fb2:	4641                	li	a2,16
    80004fb4:	4581                	li	a1,0
    80004fb6:	fc040513          	addi	a0,s0,-64
    80004fba:	ce9fb0ef          	jal	80000ca2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004fbe:	4741                	li	a4,16
    80004fc0:	f2c42683          	lw	a3,-212(s0)
    80004fc4:	fc040613          	addi	a2,s0,-64
    80004fc8:	4581                	li	a1,0
    80004fca:	8526                	mv	a0,s1
    80004fcc:	85ffe0ef          	jal	8000382a <writei>
    80004fd0:	47c1                	li	a5,16
    80004fd2:	08f51b63          	bne	a0,a5,80005068 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80004fd6:	04491703          	lh	a4,68(s2)
    80004fda:	4785                	li	a5,1
    80004fdc:	08f70d63          	beq	a4,a5,80005076 <sys_unlink+0x14c>
  iunlockput(dp);
    80004fe0:	8526                	mv	a0,s1
    80004fe2:	dc6fe0ef          	jal	800035a8 <iunlockput>
  ip->nlink--;
    80004fe6:	04a95783          	lhu	a5,74(s2)
    80004fea:	37fd                	addiw	a5,a5,-1
    80004fec:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ff0:	854a                	mv	a0,s2
    80004ff2:	af8fe0ef          	jal	800032ea <iupdate>
  iunlockput(ip);
    80004ff6:	854a                	mv	a0,s2
    80004ff8:	db0fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80004ffc:	df7fe0ef          	jal	80003df2 <end_op>
  return 0;
    80005000:	4501                	li	a0,0
    80005002:	64ee                	ld	s1,216(sp)
    80005004:	694e                	ld	s2,208(sp)
    80005006:	a849                	j	80005098 <sys_unlink+0x16e>
    end_op();
    80005008:	debfe0ef          	jal	80003df2 <end_op>
    return -1;
    8000500c:	557d                	li	a0,-1
    8000500e:	64ee                	ld	s1,216(sp)
    80005010:	a061                	j	80005098 <sys_unlink+0x16e>
    80005012:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005014:	00002517          	auipc	a0,0x2
    80005018:	70c50513          	addi	a0,a0,1804 # 80007720 <etext+0x720>
    8000501c:	fc4fb0ef          	jal	800007e0 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005020:	04c92703          	lw	a4,76(s2)
    80005024:	02000793          	li	a5,32
    80005028:	f8e7f5e3          	bgeu	a5,a4,80004fb2 <sys_unlink+0x88>
    8000502c:	e5ce                	sd	s3,200(sp)
    8000502e:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005032:	4741                	li	a4,16
    80005034:	86ce                	mv	a3,s3
    80005036:	f1840613          	addi	a2,s0,-232
    8000503a:	4581                	li	a1,0
    8000503c:	854a                	mv	a0,s2
    8000503e:	ef0fe0ef          	jal	8000372e <readi>
    80005042:	47c1                	li	a5,16
    80005044:	00f51c63          	bne	a0,a5,8000505c <sys_unlink+0x132>
    if(de.inum != 0)
    80005048:	f1845783          	lhu	a5,-232(s0)
    8000504c:	efa1                	bnez	a5,800050a4 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000504e:	29c1                	addiw	s3,s3,16
    80005050:	04c92783          	lw	a5,76(s2)
    80005054:	fcf9efe3          	bltu	s3,a5,80005032 <sys_unlink+0x108>
    80005058:	69ae                	ld	s3,200(sp)
    8000505a:	bfa1                	j	80004fb2 <sys_unlink+0x88>
      panic("isdirempty: readi");
    8000505c:	00002517          	auipc	a0,0x2
    80005060:	6dc50513          	addi	a0,a0,1756 # 80007738 <etext+0x738>
    80005064:	f7cfb0ef          	jal	800007e0 <panic>
    80005068:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000506a:	00002517          	auipc	a0,0x2
    8000506e:	6e650513          	addi	a0,a0,1766 # 80007750 <etext+0x750>
    80005072:	f6efb0ef          	jal	800007e0 <panic>
    dp->nlink--;
    80005076:	04a4d783          	lhu	a5,74(s1)
    8000507a:	37fd                	addiw	a5,a5,-1
    8000507c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005080:	8526                	mv	a0,s1
    80005082:	a68fe0ef          	jal	800032ea <iupdate>
    80005086:	bfa9                	j	80004fe0 <sys_unlink+0xb6>
    80005088:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000508a:	8526                	mv	a0,s1
    8000508c:	d1cfe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80005090:	d63fe0ef          	jal	80003df2 <end_op>
  return -1;
    80005094:	557d                	li	a0,-1
    80005096:	64ee                	ld	s1,216(sp)
}
    80005098:	70ae                	ld	ra,232(sp)
    8000509a:	740e                	ld	s0,224(sp)
    8000509c:	616d                	addi	sp,sp,240
    8000509e:	8082                	ret
    return -1;
    800050a0:	557d                	li	a0,-1
    800050a2:	bfdd                	j	80005098 <sys_unlink+0x16e>
    iunlockput(ip);
    800050a4:	854a                	mv	a0,s2
    800050a6:	d02fe0ef          	jal	800035a8 <iunlockput>
    goto bad;
    800050aa:	694e                	ld	s2,208(sp)
    800050ac:	69ae                	ld	s3,200(sp)
    800050ae:	bff1                	j	8000508a <sys_unlink+0x160>

00000000800050b0 <sys_open>:

uint64
sys_open(void)
{
    800050b0:	7131                	addi	sp,sp,-192
    800050b2:	fd06                	sd	ra,184(sp)
    800050b4:	f922                	sd	s0,176(sp)
    800050b6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800050b8:	f4c40593          	addi	a1,s0,-180
    800050bc:	4505                	li	a0,1
    800050be:	ffefd0ef          	jal	800028bc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800050c2:	08000613          	li	a2,128
    800050c6:	f5040593          	addi	a1,s0,-176
    800050ca:	4501                	li	a0,0
    800050cc:	829fd0ef          	jal	800028f4 <argstr>
    800050d0:	87aa                	mv	a5,a0
    return -1;
    800050d2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800050d4:	0a07c263          	bltz	a5,80005178 <sys_open+0xc8>
    800050d8:	f526                	sd	s1,168(sp)

  begin_op();
    800050da:	caffe0ef          	jal	80003d88 <begin_op>

  if(omode & O_CREATE){
    800050de:	f4c42783          	lw	a5,-180(s0)
    800050e2:	2007f793          	andi	a5,a5,512
    800050e6:	c3d5                	beqz	a5,8000518a <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800050e8:	4681                	li	a3,0
    800050ea:	4601                	li	a2,0
    800050ec:	4589                	li	a1,2
    800050ee:	f5040513          	addi	a0,s0,-176
    800050f2:	aa9ff0ef          	jal	80004b9a <create>
    800050f6:	84aa                	mv	s1,a0
    if(ip == 0){
    800050f8:	c541                	beqz	a0,80005180 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800050fa:	04449703          	lh	a4,68(s1)
    800050fe:	478d                	li	a5,3
    80005100:	00f71763          	bne	a4,a5,8000510e <sys_open+0x5e>
    80005104:	0464d703          	lhu	a4,70(s1)
    80005108:	47a5                	li	a5,9
    8000510a:	0ae7ed63          	bltu	a5,a4,800051c4 <sys_open+0x114>
    8000510e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005110:	fe1fe0ef          	jal	800040f0 <filealloc>
    80005114:	892a                	mv	s2,a0
    80005116:	c179                	beqz	a0,800051dc <sys_open+0x12c>
    80005118:	ed4e                	sd	s3,152(sp)
    8000511a:	a43ff0ef          	jal	80004b5c <fdalloc>
    8000511e:	89aa                	mv	s3,a0
    80005120:	0a054a63          	bltz	a0,800051d4 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005124:	04449703          	lh	a4,68(s1)
    80005128:	478d                	li	a5,3
    8000512a:	0cf70263          	beq	a4,a5,800051ee <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000512e:	4789                	li	a5,2
    80005130:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005134:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005138:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000513c:	f4c42783          	lw	a5,-180(s0)
    80005140:	0017c713          	xori	a4,a5,1
    80005144:	8b05                	andi	a4,a4,1
    80005146:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000514a:	0037f713          	andi	a4,a5,3
    8000514e:	00e03733          	snez	a4,a4
    80005152:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005156:	4007f793          	andi	a5,a5,1024
    8000515a:	c791                	beqz	a5,80005166 <sys_open+0xb6>
    8000515c:	04449703          	lh	a4,68(s1)
    80005160:	4789                	li	a5,2
    80005162:	08f70d63          	beq	a4,a5,800051fc <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005166:	8526                	mv	a0,s1
    80005168:	ae4fe0ef          	jal	8000344c <iunlock>
  end_op();
    8000516c:	c87fe0ef          	jal	80003df2 <end_op>

  return fd;
    80005170:	854e                	mv	a0,s3
    80005172:	74aa                	ld	s1,168(sp)
    80005174:	790a                	ld	s2,160(sp)
    80005176:	69ea                	ld	s3,152(sp)
}
    80005178:	70ea                	ld	ra,184(sp)
    8000517a:	744a                	ld	s0,176(sp)
    8000517c:	6129                	addi	sp,sp,192
    8000517e:	8082                	ret
      end_op();
    80005180:	c73fe0ef          	jal	80003df2 <end_op>
      return -1;
    80005184:	557d                	li	a0,-1
    80005186:	74aa                	ld	s1,168(sp)
    80005188:	bfc5                	j	80005178 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    8000518a:	f5040513          	addi	a0,s0,-176
    8000518e:	a27fe0ef          	jal	80003bb4 <namei>
    80005192:	84aa                	mv	s1,a0
    80005194:	c11d                	beqz	a0,800051ba <sys_open+0x10a>
    ilock(ip);
    80005196:	a08fe0ef          	jal	8000339e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000519a:	04449703          	lh	a4,68(s1)
    8000519e:	4785                	li	a5,1
    800051a0:	f4f71de3          	bne	a4,a5,800050fa <sys_open+0x4a>
    800051a4:	f4c42783          	lw	a5,-180(s0)
    800051a8:	d3bd                	beqz	a5,8000510e <sys_open+0x5e>
      iunlockput(ip);
    800051aa:	8526                	mv	a0,s1
    800051ac:	bfcfe0ef          	jal	800035a8 <iunlockput>
      end_op();
    800051b0:	c43fe0ef          	jal	80003df2 <end_op>
      return -1;
    800051b4:	557d                	li	a0,-1
    800051b6:	74aa                	ld	s1,168(sp)
    800051b8:	b7c1                	j	80005178 <sys_open+0xc8>
      end_op();
    800051ba:	c39fe0ef          	jal	80003df2 <end_op>
      return -1;
    800051be:	557d                	li	a0,-1
    800051c0:	74aa                	ld	s1,168(sp)
    800051c2:	bf5d                	j	80005178 <sys_open+0xc8>
    iunlockput(ip);
    800051c4:	8526                	mv	a0,s1
    800051c6:	be2fe0ef          	jal	800035a8 <iunlockput>
    end_op();
    800051ca:	c29fe0ef          	jal	80003df2 <end_op>
    return -1;
    800051ce:	557d                	li	a0,-1
    800051d0:	74aa                	ld	s1,168(sp)
    800051d2:	b75d                	j	80005178 <sys_open+0xc8>
      fileclose(f);
    800051d4:	854a                	mv	a0,s2
    800051d6:	fbffe0ef          	jal	80004194 <fileclose>
    800051da:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800051dc:	8526                	mv	a0,s1
    800051de:	bcafe0ef          	jal	800035a8 <iunlockput>
    end_op();
    800051e2:	c11fe0ef          	jal	80003df2 <end_op>
    return -1;
    800051e6:	557d                	li	a0,-1
    800051e8:	74aa                	ld	s1,168(sp)
    800051ea:	790a                	ld	s2,160(sp)
    800051ec:	b771                	j	80005178 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800051ee:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800051f2:	04649783          	lh	a5,70(s1)
    800051f6:	02f91223          	sh	a5,36(s2)
    800051fa:	bf3d                	j	80005138 <sys_open+0x88>
    itrunc(ip);
    800051fc:	8526                	mv	a0,s1
    800051fe:	a8efe0ef          	jal	8000348c <itrunc>
    80005202:	b795                	j	80005166 <sys_open+0xb6>

0000000080005204 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005204:	7175                	addi	sp,sp,-144
    80005206:	e506                	sd	ra,136(sp)
    80005208:	e122                	sd	s0,128(sp)
    8000520a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000520c:	b7dfe0ef          	jal	80003d88 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005210:	08000613          	li	a2,128
    80005214:	f7040593          	addi	a1,s0,-144
    80005218:	4501                	li	a0,0
    8000521a:	edafd0ef          	jal	800028f4 <argstr>
    8000521e:	02054363          	bltz	a0,80005244 <sys_mkdir+0x40>
    80005222:	4681                	li	a3,0
    80005224:	4601                	li	a2,0
    80005226:	4585                	li	a1,1
    80005228:	f7040513          	addi	a0,s0,-144
    8000522c:	96fff0ef          	jal	80004b9a <create>
    80005230:	c911                	beqz	a0,80005244 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005232:	b76fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80005236:	bbdfe0ef          	jal	80003df2 <end_op>
  return 0;
    8000523a:	4501                	li	a0,0
}
    8000523c:	60aa                	ld	ra,136(sp)
    8000523e:	640a                	ld	s0,128(sp)
    80005240:	6149                	addi	sp,sp,144
    80005242:	8082                	ret
    end_op();
    80005244:	baffe0ef          	jal	80003df2 <end_op>
    return -1;
    80005248:	557d                	li	a0,-1
    8000524a:	bfcd                	j	8000523c <sys_mkdir+0x38>

000000008000524c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000524c:	7135                	addi	sp,sp,-160
    8000524e:	ed06                	sd	ra,152(sp)
    80005250:	e922                	sd	s0,144(sp)
    80005252:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005254:	b35fe0ef          	jal	80003d88 <begin_op>
  argint(1, &major);
    80005258:	f6c40593          	addi	a1,s0,-148
    8000525c:	4505                	li	a0,1
    8000525e:	e5efd0ef          	jal	800028bc <argint>
  argint(2, &minor);
    80005262:	f6840593          	addi	a1,s0,-152
    80005266:	4509                	li	a0,2
    80005268:	e54fd0ef          	jal	800028bc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000526c:	08000613          	li	a2,128
    80005270:	f7040593          	addi	a1,s0,-144
    80005274:	4501                	li	a0,0
    80005276:	e7efd0ef          	jal	800028f4 <argstr>
    8000527a:	02054563          	bltz	a0,800052a4 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000527e:	f6841683          	lh	a3,-152(s0)
    80005282:	f6c41603          	lh	a2,-148(s0)
    80005286:	458d                	li	a1,3
    80005288:	f7040513          	addi	a0,s0,-144
    8000528c:	90fff0ef          	jal	80004b9a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005290:	c911                	beqz	a0,800052a4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005292:	b16fe0ef          	jal	800035a8 <iunlockput>
  end_op();
    80005296:	b5dfe0ef          	jal	80003df2 <end_op>
  return 0;
    8000529a:	4501                	li	a0,0
}
    8000529c:	60ea                	ld	ra,152(sp)
    8000529e:	644a                	ld	s0,144(sp)
    800052a0:	610d                	addi	sp,sp,160
    800052a2:	8082                	ret
    end_op();
    800052a4:	b4ffe0ef          	jal	80003df2 <end_op>
    return -1;
    800052a8:	557d                	li	a0,-1
    800052aa:	bfcd                	j	8000529c <sys_mknod+0x50>

00000000800052ac <sys_chdir>:

uint64
sys_chdir(void)
{
    800052ac:	7135                	addi	sp,sp,-160
    800052ae:	ed06                	sd	ra,152(sp)
    800052b0:	e922                	sd	s0,144(sp)
    800052b2:	e14a                	sd	s2,128(sp)
    800052b4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800052b6:	e18fc0ef          	jal	800018ce <myproc>
    800052ba:	892a                	mv	s2,a0
  
  begin_op();
    800052bc:	acdfe0ef          	jal	80003d88 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800052c0:	08000613          	li	a2,128
    800052c4:	f6040593          	addi	a1,s0,-160
    800052c8:	4501                	li	a0,0
    800052ca:	e2afd0ef          	jal	800028f4 <argstr>
    800052ce:	04054363          	bltz	a0,80005314 <sys_chdir+0x68>
    800052d2:	e526                	sd	s1,136(sp)
    800052d4:	f6040513          	addi	a0,s0,-160
    800052d8:	8ddfe0ef          	jal	80003bb4 <namei>
    800052dc:	84aa                	mv	s1,a0
    800052de:	c915                	beqz	a0,80005312 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800052e0:	8befe0ef          	jal	8000339e <ilock>
  if(ip->type != T_DIR){
    800052e4:	04449703          	lh	a4,68(s1)
    800052e8:	4785                	li	a5,1
    800052ea:	02f71963          	bne	a4,a5,8000531c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800052ee:	8526                	mv	a0,s1
    800052f0:	95cfe0ef          	jal	8000344c <iunlock>
  iput(p->cwd);
    800052f4:	15893503          	ld	a0,344(s2)
    800052f8:	a28fe0ef          	jal	80003520 <iput>
  end_op();
    800052fc:	af7fe0ef          	jal	80003df2 <end_op>
  p->cwd = ip;
    80005300:	14993c23          	sd	s1,344(s2)
  return 0;
    80005304:	4501                	li	a0,0
    80005306:	64aa                	ld	s1,136(sp)
}
    80005308:	60ea                	ld	ra,152(sp)
    8000530a:	644a                	ld	s0,144(sp)
    8000530c:	690a                	ld	s2,128(sp)
    8000530e:	610d                	addi	sp,sp,160
    80005310:	8082                	ret
    80005312:	64aa                	ld	s1,136(sp)
    end_op();
    80005314:	adffe0ef          	jal	80003df2 <end_op>
    return -1;
    80005318:	557d                	li	a0,-1
    8000531a:	b7fd                	j	80005308 <sys_chdir+0x5c>
    iunlockput(ip);
    8000531c:	8526                	mv	a0,s1
    8000531e:	a8afe0ef          	jal	800035a8 <iunlockput>
    end_op();
    80005322:	ad1fe0ef          	jal	80003df2 <end_op>
    return -1;
    80005326:	557d                	li	a0,-1
    80005328:	64aa                	ld	s1,136(sp)
    8000532a:	bff9                	j	80005308 <sys_chdir+0x5c>

000000008000532c <sys_exec>:

uint64
sys_exec(void)
{
    8000532c:	7121                	addi	sp,sp,-448
    8000532e:	ff06                	sd	ra,440(sp)
    80005330:	fb22                	sd	s0,432(sp)
    80005332:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005334:	e4840593          	addi	a1,s0,-440
    80005338:	4505                	li	a0,1
    8000533a:	d9efd0ef          	jal	800028d8 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000533e:	08000613          	li	a2,128
    80005342:	f5040593          	addi	a1,s0,-176
    80005346:	4501                	li	a0,0
    80005348:	dacfd0ef          	jal	800028f4 <argstr>
    8000534c:	87aa                	mv	a5,a0
    return -1;
    8000534e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005350:	0c07c463          	bltz	a5,80005418 <sys_exec+0xec>
    80005354:	f726                	sd	s1,424(sp)
    80005356:	f34a                	sd	s2,416(sp)
    80005358:	ef4e                	sd	s3,408(sp)
    8000535a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000535c:	10000613          	li	a2,256
    80005360:	4581                	li	a1,0
    80005362:	e5040513          	addi	a0,s0,-432
    80005366:	93dfb0ef          	jal	80000ca2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000536a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000536e:	89a6                	mv	s3,s1
    80005370:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005372:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005376:	00391513          	slli	a0,s2,0x3
    8000537a:	e4040593          	addi	a1,s0,-448
    8000537e:	e4843783          	ld	a5,-440(s0)
    80005382:	953e                	add	a0,a0,a5
    80005384:	caefd0ef          	jal	80002832 <fetchaddr>
    80005388:	02054663          	bltz	a0,800053b4 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000538c:	e4043783          	ld	a5,-448(s0)
    80005390:	c3a9                	beqz	a5,800053d2 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005392:	f6cfb0ef          	jal	80000afe <kalloc>
    80005396:	85aa                	mv	a1,a0
    80005398:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000539c:	cd01                	beqz	a0,800053b4 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000539e:	6605                	lui	a2,0x1
    800053a0:	e4043503          	ld	a0,-448(s0)
    800053a4:	cd8fd0ef          	jal	8000287c <fetchstr>
    800053a8:	00054663          	bltz	a0,800053b4 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800053ac:	0905                	addi	s2,s2,1
    800053ae:	09a1                	addi	s3,s3,8
    800053b0:	fd4913e3          	bne	s2,s4,80005376 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053b4:	f5040913          	addi	s2,s0,-176
    800053b8:	6088                	ld	a0,0(s1)
    800053ba:	c931                	beqz	a0,8000540e <sys_exec+0xe2>
    kfree(argv[i]);
    800053bc:	e60fb0ef          	jal	80000a1c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053c0:	04a1                	addi	s1,s1,8
    800053c2:	ff249be3          	bne	s1,s2,800053b8 <sys_exec+0x8c>
  return -1;
    800053c6:	557d                	li	a0,-1
    800053c8:	74ba                	ld	s1,424(sp)
    800053ca:	791a                	ld	s2,416(sp)
    800053cc:	69fa                	ld	s3,408(sp)
    800053ce:	6a5a                	ld	s4,400(sp)
    800053d0:	a0a1                	j	80005418 <sys_exec+0xec>
      argv[i] = 0;
    800053d2:	0009079b          	sext.w	a5,s2
    800053d6:	078e                	slli	a5,a5,0x3
    800053d8:	fd078793          	addi	a5,a5,-48
    800053dc:	97a2                	add	a5,a5,s0
    800053de:	e807b023          	sd	zero,-384(a5)
  int ret = kexec(path, argv);
    800053e2:	e5040593          	addi	a1,s0,-432
    800053e6:	f5040513          	addi	a0,s0,-176
    800053ea:	ba8ff0ef          	jal	80004792 <kexec>
    800053ee:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053f0:	f5040993          	addi	s3,s0,-176
    800053f4:	6088                	ld	a0,0(s1)
    800053f6:	c511                	beqz	a0,80005402 <sys_exec+0xd6>
    kfree(argv[i]);
    800053f8:	e24fb0ef          	jal	80000a1c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800053fc:	04a1                	addi	s1,s1,8
    800053fe:	ff349be3          	bne	s1,s3,800053f4 <sys_exec+0xc8>
  return ret;
    80005402:	854a                	mv	a0,s2
    80005404:	74ba                	ld	s1,424(sp)
    80005406:	791a                	ld	s2,416(sp)
    80005408:	69fa                	ld	s3,408(sp)
    8000540a:	6a5a                	ld	s4,400(sp)
    8000540c:	a031                	j	80005418 <sys_exec+0xec>
  return -1;
    8000540e:	557d                	li	a0,-1
    80005410:	74ba                	ld	s1,424(sp)
    80005412:	791a                	ld	s2,416(sp)
    80005414:	69fa                	ld	s3,408(sp)
    80005416:	6a5a                	ld	s4,400(sp)
}
    80005418:	70fa                	ld	ra,440(sp)
    8000541a:	745a                	ld	s0,432(sp)
    8000541c:	6139                	addi	sp,sp,448
    8000541e:	8082                	ret

0000000080005420 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005420:	7139                	addi	sp,sp,-64
    80005422:	fc06                	sd	ra,56(sp)
    80005424:	f822                	sd	s0,48(sp)
    80005426:	f426                	sd	s1,40(sp)
    80005428:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000542a:	ca4fc0ef          	jal	800018ce <myproc>
    8000542e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005430:	fd840593          	addi	a1,s0,-40
    80005434:	4501                	li	a0,0
    80005436:	ca2fd0ef          	jal	800028d8 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000543a:	fc840593          	addi	a1,s0,-56
    8000543e:	fd040513          	addi	a0,s0,-48
    80005442:	85cff0ef          	jal	8000449e <pipealloc>
    return -1;
    80005446:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005448:	0a054463          	bltz	a0,800054f0 <sys_pipe+0xd0>
  fd0 = -1;
    8000544c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005450:	fd043503          	ld	a0,-48(s0)
    80005454:	f08ff0ef          	jal	80004b5c <fdalloc>
    80005458:	fca42223          	sw	a0,-60(s0)
    8000545c:	08054163          	bltz	a0,800054de <sys_pipe+0xbe>
    80005460:	fc843503          	ld	a0,-56(s0)
    80005464:	ef8ff0ef          	jal	80004b5c <fdalloc>
    80005468:	fca42023          	sw	a0,-64(s0)
    8000546c:	06054063          	bltz	a0,800054cc <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005470:	4691                	li	a3,4
    80005472:	fc440613          	addi	a2,s0,-60
    80005476:	fd843583          	ld	a1,-40(s0)
    8000547a:	6ca8                	ld	a0,88(s1)
    8000547c:	966fc0ef          	jal	800015e2 <copyout>
    80005480:	00054e63          	bltz	a0,8000549c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005484:	4691                	li	a3,4
    80005486:	fc040613          	addi	a2,s0,-64
    8000548a:	fd843583          	ld	a1,-40(s0)
    8000548e:	0591                	addi	a1,a1,4
    80005490:	6ca8                	ld	a0,88(s1)
    80005492:	950fc0ef          	jal	800015e2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005496:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005498:	04055c63          	bgez	a0,800054f0 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000549c:	fc442783          	lw	a5,-60(s0)
    800054a0:	07e9                	addi	a5,a5,26
    800054a2:	078e                	slli	a5,a5,0x3
    800054a4:	97a6                	add	a5,a5,s1
    800054a6:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800054aa:	fc042783          	lw	a5,-64(s0)
    800054ae:	07e9                	addi	a5,a5,26
    800054b0:	078e                	slli	a5,a5,0x3
    800054b2:	94be                	add	s1,s1,a5
    800054b4:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800054b8:	fd043503          	ld	a0,-48(s0)
    800054bc:	cd9fe0ef          	jal	80004194 <fileclose>
    fileclose(wf);
    800054c0:	fc843503          	ld	a0,-56(s0)
    800054c4:	cd1fe0ef          	jal	80004194 <fileclose>
    return -1;
    800054c8:	57fd                	li	a5,-1
    800054ca:	a01d                	j	800054f0 <sys_pipe+0xd0>
    if(fd0 >= 0)
    800054cc:	fc442783          	lw	a5,-60(s0)
    800054d0:	0007c763          	bltz	a5,800054de <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800054d4:	07e9                	addi	a5,a5,26
    800054d6:	078e                	slli	a5,a5,0x3
    800054d8:	97a6                	add	a5,a5,s1
    800054da:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800054de:	fd043503          	ld	a0,-48(s0)
    800054e2:	cb3fe0ef          	jal	80004194 <fileclose>
    fileclose(wf);
    800054e6:	fc843503          	ld	a0,-56(s0)
    800054ea:	cabfe0ef          	jal	80004194 <fileclose>
    return -1;
    800054ee:	57fd                	li	a5,-1
}
    800054f0:	853e                	mv	a0,a5
    800054f2:	70e2                	ld	ra,56(sp)
    800054f4:	7442                	ld	s0,48(sp)
    800054f6:	74a2                	ld	s1,40(sp)
    800054f8:	6121                	addi	sp,sp,64
    800054fa:	8082                	ret
    800054fc:	0000                	unimp
	...

0000000080005500 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005500:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005502:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005504:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80005506:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80005508:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000550a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000550c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000550e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80005510:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005512:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005514:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005516:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005518:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000551a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000551c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000551e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80005520:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005522:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005524:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005526:	a1cfd0ef          	jal	80002742 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000552a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000552c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000552e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80005530:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005532:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005534:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005536:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005538:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000553a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000553c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000553e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80005540:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005542:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005544:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005546:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005548:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000554a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000554c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000554e:	10200073          	sret
	...

000000008000555e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000555e:	1141                	addi	sp,sp,-16
    80005560:	e422                	sd	s0,8(sp)
    80005562:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005564:	0c0007b7          	lui	a5,0xc000
    80005568:	4705                	li	a4,1
    8000556a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000556c:	0c0007b7          	lui	a5,0xc000
    80005570:	c3d8                	sw	a4,4(a5)
}
    80005572:	6422                	ld	s0,8(sp)
    80005574:	0141                	addi	sp,sp,16
    80005576:	8082                	ret

0000000080005578 <plicinithart>:

void
plicinithart(void)
{
    80005578:	1141                	addi	sp,sp,-16
    8000557a:	e406                	sd	ra,8(sp)
    8000557c:	e022                	sd	s0,0(sp)
    8000557e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005580:	b22fc0ef          	jal	800018a2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005584:	0085171b          	slliw	a4,a0,0x8
    80005588:	0c0027b7          	lui	a5,0xc002
    8000558c:	97ba                	add	a5,a5,a4
    8000558e:	40200713          	li	a4,1026
    80005592:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005596:	00d5151b          	slliw	a0,a0,0xd
    8000559a:	0c2017b7          	lui	a5,0xc201
    8000559e:	97aa                	add	a5,a5,a0
    800055a0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800055a4:	60a2                	ld	ra,8(sp)
    800055a6:	6402                	ld	s0,0(sp)
    800055a8:	0141                	addi	sp,sp,16
    800055aa:	8082                	ret

00000000800055ac <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800055ac:	1141                	addi	sp,sp,-16
    800055ae:	e406                	sd	ra,8(sp)
    800055b0:	e022                	sd	s0,0(sp)
    800055b2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055b4:	aeefc0ef          	jal	800018a2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800055b8:	00d5151b          	slliw	a0,a0,0xd
    800055bc:	0c2017b7          	lui	a5,0xc201
    800055c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800055c2:	43c8                	lw	a0,4(a5)
    800055c4:	60a2                	ld	ra,8(sp)
    800055c6:	6402                	ld	s0,0(sp)
    800055c8:	0141                	addi	sp,sp,16
    800055ca:	8082                	ret

00000000800055cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055cc:	1101                	addi	sp,sp,-32
    800055ce:	ec06                	sd	ra,24(sp)
    800055d0:	e822                	sd	s0,16(sp)
    800055d2:	e426                	sd	s1,8(sp)
    800055d4:	1000                	addi	s0,sp,32
    800055d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055d8:	acafc0ef          	jal	800018a2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800055dc:	00d5151b          	slliw	a0,a0,0xd
    800055e0:	0c2017b7          	lui	a5,0xc201
    800055e4:	97aa                	add	a5,a5,a0
    800055e6:	c3c4                	sw	s1,4(a5)
}
    800055e8:	60e2                	ld	ra,24(sp)
    800055ea:	6442                	ld	s0,16(sp)
    800055ec:	64a2                	ld	s1,8(sp)
    800055ee:	6105                	addi	sp,sp,32
    800055f0:	8082                	ret

00000000800055f2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055f2:	1141                	addi	sp,sp,-16
    800055f4:	e406                	sd	ra,8(sp)
    800055f6:	e022                	sd	s0,0(sp)
    800055f8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055fa:	479d                	li	a5,7
    800055fc:	04a7ca63          	blt	a5,a0,80005650 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005600:	0001e797          	auipc	a5,0x1e
    80005604:	2b878793          	addi	a5,a5,696 # 800238b8 <disk>
    80005608:	97aa                	add	a5,a5,a0
    8000560a:	0187c783          	lbu	a5,24(a5)
    8000560e:	e7b9                	bnez	a5,8000565c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005610:	00451693          	slli	a3,a0,0x4
    80005614:	0001e797          	auipc	a5,0x1e
    80005618:	2a478793          	addi	a5,a5,676 # 800238b8 <disk>
    8000561c:	6398                	ld	a4,0(a5)
    8000561e:	9736                	add	a4,a4,a3
    80005620:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005624:	6398                	ld	a4,0(a5)
    80005626:	9736                	add	a4,a4,a3
    80005628:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000562c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005630:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005634:	97aa                	add	a5,a5,a0
    80005636:	4705                	li	a4,1
    80005638:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000563c:	0001e517          	auipc	a0,0x1e
    80005640:	29450513          	addi	a0,a0,660 # 800238d0 <disk+0x18>
    80005644:	9c1fc0ef          	jal	80002004 <wakeup>
}
    80005648:	60a2                	ld	ra,8(sp)
    8000564a:	6402                	ld	s0,0(sp)
    8000564c:	0141                	addi	sp,sp,16
    8000564e:	8082                	ret
    panic("free_desc 1");
    80005650:	00002517          	auipc	a0,0x2
    80005654:	11050513          	addi	a0,a0,272 # 80007760 <etext+0x760>
    80005658:	988fb0ef          	jal	800007e0 <panic>
    panic("free_desc 2");
    8000565c:	00002517          	auipc	a0,0x2
    80005660:	11450513          	addi	a0,a0,276 # 80007770 <etext+0x770>
    80005664:	97cfb0ef          	jal	800007e0 <panic>

0000000080005668 <virtio_disk_init>:
{
    80005668:	1101                	addi	sp,sp,-32
    8000566a:	ec06                	sd	ra,24(sp)
    8000566c:	e822                	sd	s0,16(sp)
    8000566e:	e426                	sd	s1,8(sp)
    80005670:	e04a                	sd	s2,0(sp)
    80005672:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005674:	00002597          	auipc	a1,0x2
    80005678:	10c58593          	addi	a1,a1,268 # 80007780 <etext+0x780>
    8000567c:	0001e517          	auipc	a0,0x1e
    80005680:	36450513          	addi	a0,a0,868 # 800239e0 <disk+0x128>
    80005684:	ccafb0ef          	jal	80000b4e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005688:	100017b7          	lui	a5,0x10001
    8000568c:	4398                	lw	a4,0(a5)
    8000568e:	2701                	sext.w	a4,a4
    80005690:	747277b7          	lui	a5,0x74727
    80005694:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005698:	18f71063          	bne	a4,a5,80005818 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000569c:	100017b7          	lui	a5,0x10001
    800056a0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800056a2:	439c                	lw	a5,0(a5)
    800056a4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056a6:	4709                	li	a4,2
    800056a8:	16e79863          	bne	a5,a4,80005818 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056ac:	100017b7          	lui	a5,0x10001
    800056b0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800056b2:	439c                	lw	a5,0(a5)
    800056b4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056b6:	16e79163          	bne	a5,a4,80005818 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800056ba:	100017b7          	lui	a5,0x10001
    800056be:	47d8                	lw	a4,12(a5)
    800056c0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056c2:	554d47b7          	lui	a5,0x554d4
    800056c6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056ca:	14f71763          	bne	a4,a5,80005818 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ce:	100017b7          	lui	a5,0x10001
    800056d2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056d6:	4705                	li	a4,1
    800056d8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056da:	470d                	li	a4,3
    800056dc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056de:	10001737          	lui	a4,0x10001
    800056e2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056e4:	c7ffe737          	lui	a4,0xc7ffe
    800056e8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdad67>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056ec:	8ef9                	and	a3,a3,a4
    800056ee:	10001737          	lui	a4,0x10001
    800056f2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f4:	472d                	li	a4,11
    800056f6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056f8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800056fc:	439c                	lw	a5,0(a5)
    800056fe:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005702:	8ba1                	andi	a5,a5,8
    80005704:	12078063          	beqz	a5,80005824 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005708:	100017b7          	lui	a5,0x10001
    8000570c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005710:	100017b7          	lui	a5,0x10001
    80005714:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005718:	439c                	lw	a5,0(a5)
    8000571a:	2781                	sext.w	a5,a5
    8000571c:	10079a63          	bnez	a5,80005830 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005728:	439c                	lw	a5,0(a5)
    8000572a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000572c:	10078863          	beqz	a5,8000583c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005730:	471d                	li	a4,7
    80005732:	10f77b63          	bgeu	a4,a5,80005848 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005736:	bc8fb0ef          	jal	80000afe <kalloc>
    8000573a:	0001e497          	auipc	s1,0x1e
    8000573e:	17e48493          	addi	s1,s1,382 # 800238b8 <disk>
    80005742:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005744:	bbafb0ef          	jal	80000afe <kalloc>
    80005748:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000574a:	bb4fb0ef          	jal	80000afe <kalloc>
    8000574e:	87aa                	mv	a5,a0
    80005750:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005752:	6088                	ld	a0,0(s1)
    80005754:	10050063          	beqz	a0,80005854 <virtio_disk_init+0x1ec>
    80005758:	0001e717          	auipc	a4,0x1e
    8000575c:	16873703          	ld	a4,360(a4) # 800238c0 <disk+0x8>
    80005760:	0e070a63          	beqz	a4,80005854 <virtio_disk_init+0x1ec>
    80005764:	0e078863          	beqz	a5,80005854 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005768:	6605                	lui	a2,0x1
    8000576a:	4581                	li	a1,0
    8000576c:	d36fb0ef          	jal	80000ca2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005770:	0001e497          	auipc	s1,0x1e
    80005774:	14848493          	addi	s1,s1,328 # 800238b8 <disk>
    80005778:	6605                	lui	a2,0x1
    8000577a:	4581                	li	a1,0
    8000577c:	6488                	ld	a0,8(s1)
    8000577e:	d24fb0ef          	jal	80000ca2 <memset>
  memset(disk.used, 0, PGSIZE);
    80005782:	6605                	lui	a2,0x1
    80005784:	4581                	li	a1,0
    80005786:	6888                	ld	a0,16(s1)
    80005788:	d1afb0ef          	jal	80000ca2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000578c:	100017b7          	lui	a5,0x10001
    80005790:	4721                	li	a4,8
    80005792:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005794:	4098                	lw	a4,0(s1)
    80005796:	100017b7          	lui	a5,0x10001
    8000579a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000579e:	40d8                	lw	a4,4(s1)
    800057a0:	100017b7          	lui	a5,0x10001
    800057a4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057a8:	649c                	ld	a5,8(s1)
    800057aa:	0007869b          	sext.w	a3,a5
    800057ae:	10001737          	lui	a4,0x10001
    800057b2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800057b6:	9781                	srai	a5,a5,0x20
    800057b8:	10001737          	lui	a4,0x10001
    800057bc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800057c0:	689c                	ld	a5,16(s1)
    800057c2:	0007869b          	sext.w	a3,a5
    800057c6:	10001737          	lui	a4,0x10001
    800057ca:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800057ce:	9781                	srai	a5,a5,0x20
    800057d0:	10001737          	lui	a4,0x10001
    800057d4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800057d8:	10001737          	lui	a4,0x10001
    800057dc:	4785                	li	a5,1
    800057de:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800057e0:	00f48c23          	sb	a5,24(s1)
    800057e4:	00f48ca3          	sb	a5,25(s1)
    800057e8:	00f48d23          	sb	a5,26(s1)
    800057ec:	00f48da3          	sb	a5,27(s1)
    800057f0:	00f48e23          	sb	a5,28(s1)
    800057f4:	00f48ea3          	sb	a5,29(s1)
    800057f8:	00f48f23          	sb	a5,30(s1)
    800057fc:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005800:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005804:	100017b7          	lui	a5,0x10001
    80005808:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000580c:	60e2                	ld	ra,24(sp)
    8000580e:	6442                	ld	s0,16(sp)
    80005810:	64a2                	ld	s1,8(sp)
    80005812:	6902                	ld	s2,0(sp)
    80005814:	6105                	addi	sp,sp,32
    80005816:	8082                	ret
    panic("could not find virtio disk");
    80005818:	00002517          	auipc	a0,0x2
    8000581c:	f7850513          	addi	a0,a0,-136 # 80007790 <etext+0x790>
    80005820:	fc1fa0ef          	jal	800007e0 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005824:	00002517          	auipc	a0,0x2
    80005828:	f8c50513          	addi	a0,a0,-116 # 800077b0 <etext+0x7b0>
    8000582c:	fb5fa0ef          	jal	800007e0 <panic>
    panic("virtio disk should not be ready");
    80005830:	00002517          	auipc	a0,0x2
    80005834:	fa050513          	addi	a0,a0,-96 # 800077d0 <etext+0x7d0>
    80005838:	fa9fa0ef          	jal	800007e0 <panic>
    panic("virtio disk has no queue 0");
    8000583c:	00002517          	auipc	a0,0x2
    80005840:	fb450513          	addi	a0,a0,-76 # 800077f0 <etext+0x7f0>
    80005844:	f9dfa0ef          	jal	800007e0 <panic>
    panic("virtio disk max queue too short");
    80005848:	00002517          	auipc	a0,0x2
    8000584c:	fc850513          	addi	a0,a0,-56 # 80007810 <etext+0x810>
    80005850:	f91fa0ef          	jal	800007e0 <panic>
    panic("virtio disk kalloc");
    80005854:	00002517          	auipc	a0,0x2
    80005858:	fdc50513          	addi	a0,a0,-36 # 80007830 <etext+0x830>
    8000585c:	f85fa0ef          	jal	800007e0 <panic>

0000000080005860 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005860:	7159                	addi	sp,sp,-112
    80005862:	f486                	sd	ra,104(sp)
    80005864:	f0a2                	sd	s0,96(sp)
    80005866:	eca6                	sd	s1,88(sp)
    80005868:	e8ca                	sd	s2,80(sp)
    8000586a:	e4ce                	sd	s3,72(sp)
    8000586c:	e0d2                	sd	s4,64(sp)
    8000586e:	fc56                	sd	s5,56(sp)
    80005870:	f85a                	sd	s6,48(sp)
    80005872:	f45e                	sd	s7,40(sp)
    80005874:	f062                	sd	s8,32(sp)
    80005876:	ec66                	sd	s9,24(sp)
    80005878:	1880                	addi	s0,sp,112
    8000587a:	8a2a                	mv	s4,a0
    8000587c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000587e:	00c52c83          	lw	s9,12(a0)
    80005882:	001c9c9b          	slliw	s9,s9,0x1
    80005886:	1c82                	slli	s9,s9,0x20
    80005888:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000588c:	0001e517          	auipc	a0,0x1e
    80005890:	15450513          	addi	a0,a0,340 # 800239e0 <disk+0x128>
    80005894:	b3afb0ef          	jal	80000bce <acquire>
  for(int i = 0; i < 3; i++){
    80005898:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000589a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000589c:	0001eb17          	auipc	s6,0x1e
    800058a0:	01cb0b13          	addi	s6,s6,28 # 800238b8 <disk>
  for(int i = 0; i < 3; i++){
    800058a4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058a6:	0001ec17          	auipc	s8,0x1e
    800058aa:	13ac0c13          	addi	s8,s8,314 # 800239e0 <disk+0x128>
    800058ae:	a8b9                	j	8000590c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    800058b0:	00fb0733          	add	a4,s6,a5
    800058b4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    800058b8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800058ba:	0207c563          	bltz	a5,800058e4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800058be:	2905                	addiw	s2,s2,1
    800058c0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800058c2:	05590963          	beq	s2,s5,80005914 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    800058c6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800058c8:	0001e717          	auipc	a4,0x1e
    800058cc:	ff070713          	addi	a4,a4,-16 # 800238b8 <disk>
    800058d0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800058d2:	01874683          	lbu	a3,24(a4)
    800058d6:	fee9                	bnez	a3,800058b0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    800058d8:	2785                	addiw	a5,a5,1
    800058da:	0705                	addi	a4,a4,1
    800058dc:	fe979be3          	bne	a5,s1,800058d2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800058e0:	57fd                	li	a5,-1
    800058e2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800058e4:	01205d63          	blez	s2,800058fe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800058e8:	f9042503          	lw	a0,-112(s0)
    800058ec:	d07ff0ef          	jal	800055f2 <free_desc>
      for(int j = 0; j < i; j++)
    800058f0:	4785                	li	a5,1
    800058f2:	0127d663          	bge	a5,s2,800058fe <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800058f6:	f9442503          	lw	a0,-108(s0)
    800058fa:	cf9ff0ef          	jal	800055f2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058fe:	85e2                	mv	a1,s8
    80005900:	0001e517          	auipc	a0,0x1e
    80005904:	fd050513          	addi	a0,a0,-48 # 800238d0 <disk+0x18>
    80005908:	eb0fc0ef          	jal	80001fb8 <sleep>
  for(int i = 0; i < 3; i++){
    8000590c:	f9040613          	addi	a2,s0,-112
    80005910:	894e                	mv	s2,s3
    80005912:	bf55                	j	800058c6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005914:	f9042503          	lw	a0,-112(s0)
    80005918:	00451693          	slli	a3,a0,0x4

  if(write)
    8000591c:	0001e797          	auipc	a5,0x1e
    80005920:	f9c78793          	addi	a5,a5,-100 # 800238b8 <disk>
    80005924:	00a50713          	addi	a4,a0,10
    80005928:	0712                	slli	a4,a4,0x4
    8000592a:	973e                	add	a4,a4,a5
    8000592c:	01703633          	snez	a2,s7
    80005930:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005932:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005936:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    8000593a:	6398                	ld	a4,0(a5)
    8000593c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000593e:	0a868613          	addi	a2,a3,168
    80005942:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005944:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005946:	6390                	ld	a2,0(a5)
    80005948:	00d605b3          	add	a1,a2,a3
    8000594c:	4741                	li	a4,16
    8000594e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005950:	4805                	li	a6,1
    80005952:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005956:	f9442703          	lw	a4,-108(s0)
    8000595a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000595e:	0712                	slli	a4,a4,0x4
    80005960:	963a                	add	a2,a2,a4
    80005962:	058a0593          	addi	a1,s4,88
    80005966:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005968:	0007b883          	ld	a7,0(a5)
    8000596c:	9746                	add	a4,a4,a7
    8000596e:	40000613          	li	a2,1024
    80005972:	c710                	sw	a2,8(a4)
  if(write)
    80005974:	001bb613          	seqz	a2,s7
    80005978:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000597c:	00166613          	ori	a2,a2,1
    80005980:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005984:	f9842583          	lw	a1,-104(s0)
    80005988:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000598c:	00250613          	addi	a2,a0,2
    80005990:	0612                	slli	a2,a2,0x4
    80005992:	963e                	add	a2,a2,a5
    80005994:	577d                	li	a4,-1
    80005996:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000599a:	0592                	slli	a1,a1,0x4
    8000599c:	98ae                	add	a7,a7,a1
    8000599e:	03068713          	addi	a4,a3,48
    800059a2:	973e                	add	a4,a4,a5
    800059a4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800059a8:	6398                	ld	a4,0(a5)
    800059aa:	972e                	add	a4,a4,a1
    800059ac:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059b0:	4689                	li	a3,2
    800059b2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800059b6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059ba:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    800059be:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059c2:	6794                	ld	a3,8(a5)
    800059c4:	0026d703          	lhu	a4,2(a3)
    800059c8:	8b1d                	andi	a4,a4,7
    800059ca:	0706                	slli	a4,a4,0x1
    800059cc:	96ba                	add	a3,a3,a4
    800059ce:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800059d2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800059d6:	6798                	ld	a4,8(a5)
    800059d8:	00275783          	lhu	a5,2(a4)
    800059dc:	2785                	addiw	a5,a5,1
    800059de:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800059e2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059e6:	100017b7          	lui	a5,0x10001
    800059ea:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800059ee:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800059f2:	0001e917          	auipc	s2,0x1e
    800059f6:	fee90913          	addi	s2,s2,-18 # 800239e0 <disk+0x128>
  while(b->disk == 1) {
    800059fa:	4485                	li	s1,1
    800059fc:	01079a63          	bne	a5,a6,80005a10 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005a00:	85ca                	mv	a1,s2
    80005a02:	8552                	mv	a0,s4
    80005a04:	db4fc0ef          	jal	80001fb8 <sleep>
  while(b->disk == 1) {
    80005a08:	004a2783          	lw	a5,4(s4)
    80005a0c:	fe978ae3          	beq	a5,s1,80005a00 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005a10:	f9042903          	lw	s2,-112(s0)
    80005a14:	00290713          	addi	a4,s2,2
    80005a18:	0712                	slli	a4,a4,0x4
    80005a1a:	0001e797          	auipc	a5,0x1e
    80005a1e:	e9e78793          	addi	a5,a5,-354 # 800238b8 <disk>
    80005a22:	97ba                	add	a5,a5,a4
    80005a24:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a28:	0001e997          	auipc	s3,0x1e
    80005a2c:	e9098993          	addi	s3,s3,-368 # 800238b8 <disk>
    80005a30:	00491713          	slli	a4,s2,0x4
    80005a34:	0009b783          	ld	a5,0(s3)
    80005a38:	97ba                	add	a5,a5,a4
    80005a3a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a3e:	854a                	mv	a0,s2
    80005a40:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a44:	bafff0ef          	jal	800055f2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a48:	8885                	andi	s1,s1,1
    80005a4a:	f0fd                	bnez	s1,80005a30 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a4c:	0001e517          	auipc	a0,0x1e
    80005a50:	f9450513          	addi	a0,a0,-108 # 800239e0 <disk+0x128>
    80005a54:	a12fb0ef          	jal	80000c66 <release>
}
    80005a58:	70a6                	ld	ra,104(sp)
    80005a5a:	7406                	ld	s0,96(sp)
    80005a5c:	64e6                	ld	s1,88(sp)
    80005a5e:	6946                	ld	s2,80(sp)
    80005a60:	69a6                	ld	s3,72(sp)
    80005a62:	6a06                	ld	s4,64(sp)
    80005a64:	7ae2                	ld	s5,56(sp)
    80005a66:	7b42                	ld	s6,48(sp)
    80005a68:	7ba2                	ld	s7,40(sp)
    80005a6a:	7c02                	ld	s8,32(sp)
    80005a6c:	6ce2                	ld	s9,24(sp)
    80005a6e:	6165                	addi	sp,sp,112
    80005a70:	8082                	ret

0000000080005a72 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a72:	1101                	addi	sp,sp,-32
    80005a74:	ec06                	sd	ra,24(sp)
    80005a76:	e822                	sd	s0,16(sp)
    80005a78:	e426                	sd	s1,8(sp)
    80005a7a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a7c:	0001e497          	auipc	s1,0x1e
    80005a80:	e3c48493          	addi	s1,s1,-452 # 800238b8 <disk>
    80005a84:	0001e517          	auipc	a0,0x1e
    80005a88:	f5c50513          	addi	a0,a0,-164 # 800239e0 <disk+0x128>
    80005a8c:	942fb0ef          	jal	80000bce <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a90:	100017b7          	lui	a5,0x10001
    80005a94:	53b8                	lw	a4,96(a5)
    80005a96:	8b0d                	andi	a4,a4,3
    80005a98:	100017b7          	lui	a5,0x10001
    80005a9c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005a9e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005aa2:	689c                	ld	a5,16(s1)
    80005aa4:	0204d703          	lhu	a4,32(s1)
    80005aa8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005aac:	04f70663          	beq	a4,a5,80005af8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005ab0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ab4:	6898                	ld	a4,16(s1)
    80005ab6:	0204d783          	lhu	a5,32(s1)
    80005aba:	8b9d                	andi	a5,a5,7
    80005abc:	078e                	slli	a5,a5,0x3
    80005abe:	97ba                	add	a5,a5,a4
    80005ac0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005ac2:	00278713          	addi	a4,a5,2
    80005ac6:	0712                	slli	a4,a4,0x4
    80005ac8:	9726                	add	a4,a4,s1
    80005aca:	01074703          	lbu	a4,16(a4)
    80005ace:	e321                	bnez	a4,80005b0e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ad0:	0789                	addi	a5,a5,2
    80005ad2:	0792                	slli	a5,a5,0x4
    80005ad4:	97a6                	add	a5,a5,s1
    80005ad6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005ad8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005adc:	d28fc0ef          	jal	80002004 <wakeup>

    disk.used_idx += 1;
    80005ae0:	0204d783          	lhu	a5,32(s1)
    80005ae4:	2785                	addiw	a5,a5,1
    80005ae6:	17c2                	slli	a5,a5,0x30
    80005ae8:	93c1                	srli	a5,a5,0x30
    80005aea:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005aee:	6898                	ld	a4,16(s1)
    80005af0:	00275703          	lhu	a4,2(a4)
    80005af4:	faf71ee3          	bne	a4,a5,80005ab0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005af8:	0001e517          	auipc	a0,0x1e
    80005afc:	ee850513          	addi	a0,a0,-280 # 800239e0 <disk+0x128>
    80005b00:	966fb0ef          	jal	80000c66 <release>
}
    80005b04:	60e2                	ld	ra,24(sp)
    80005b06:	6442                	ld	s0,16(sp)
    80005b08:	64a2                	ld	s1,8(sp)
    80005b0a:	6105                	addi	sp,sp,32
    80005b0c:	8082                	ret
      panic("virtio_disk_intr status");
    80005b0e:	00002517          	auipc	a0,0x2
    80005b12:	d3a50513          	addi	a0,a0,-710 # 80007848 <etext+0x848>
    80005b16:	ccbfa0ef          	jal	800007e0 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
