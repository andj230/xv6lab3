
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2c4000ef          	jal	2cc <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2c2000ef          	jal	2d4 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	34c000ef          	jal	364 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	2a8000ef          	jal	2d4 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	1d2000ef          	jal	2ec <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	1ae000ef          	jal	314 <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	1b8000ef          	jal	32c <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	180000ef          	jal	2fc <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <sbrk>:

char *
sbrk(int n) {
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 288:	4585                	li	a1,1
 28a:	0d2000ef          	jal	35c <sys_sbrk>
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <sbrklazy>:

char *
sbrklazy(int n) {
 296:	1141                	addi	sp,sp,-16
 298:	e406                	sd	ra,8(sp)
 29a:	e022                	sd	s0,0(sp)
 29c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 29e:	4589                	li	a1,2
 2a0:	0bc000ef          	jal	35c <sys_sbrk>
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret

00000000000002ac <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 2ac:	48e5                	li	a7,25
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 2b4:	48e1                	li	a7,24
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 2bc:	48dd                	li	a7,23
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 2c4:	48d9                	li	a7,22
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <fork>:
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pause>:
.global pause
pause:
 li a7, SYS_pause
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 374:	1101                	addi	sp,sp,-32
 376:	ec06                	sd	ra,24(sp)
 378:	e822                	sd	s0,16(sp)
 37a:	1000                	addi	s0,sp,32
 37c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 380:	4605                	li	a2,1
 382:	fef40593          	addi	a1,s0,-17
 386:	f6fff0ef          	jal	2f4 <write>
}
 38a:	60e2                	ld	ra,24(sp)
 38c:	6442                	ld	s0,16(sp)
 38e:	6105                	addi	sp,sp,32
 390:	8082                	ret

0000000000000392 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 392:	715d                	addi	sp,sp,-80
 394:	e486                	sd	ra,72(sp)
 396:	e0a2                	sd	s0,64(sp)
 398:	fc26                	sd	s1,56(sp)
 39a:	0880                	addi	s0,sp,80
 39c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39e:	c299                	beqz	a3,3a4 <printint+0x12>
 3a0:	0805c963          	bltz	a1,432 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a4:	2581                	sext.w	a1,a1
  neg = 0;
 3a6:	4881                	li	a7,0
 3a8:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3ac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ae:	2601                	sext.w	a2,a2
 3b0:	00000517          	auipc	a0,0x0
 3b4:	51850513          	addi	a0,a0,1304 # 8c8 <digits>
 3b8:	883a                	mv	a6,a4
 3ba:	2705                	addiw	a4,a4,1
 3bc:	02c5f7bb          	remuw	a5,a1,a2
 3c0:	1782                	slli	a5,a5,0x20
 3c2:	9381                	srli	a5,a5,0x20
 3c4:	97aa                	add	a5,a5,a0
 3c6:	0007c783          	lbu	a5,0(a5)
 3ca:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ce:	0005879b          	sext.w	a5,a1
 3d2:	02c5d5bb          	divuw	a1,a1,a2
 3d6:	0685                	addi	a3,a3,1
 3d8:	fec7f0e3          	bgeu	a5,a2,3b8 <printint+0x26>
  if(neg)
 3dc:	00088c63          	beqz	a7,3f4 <printint+0x62>
    buf[i++] = '-';
 3e0:	fd070793          	addi	a5,a4,-48
 3e4:	00878733          	add	a4,a5,s0
 3e8:	02d00793          	li	a5,45
 3ec:	fef70423          	sb	a5,-24(a4)
 3f0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f4:	02e05a63          	blez	a4,428 <printint+0x96>
 3f8:	f84a                	sd	s2,48(sp)
 3fa:	f44e                	sd	s3,40(sp)
 3fc:	fb840793          	addi	a5,s0,-72
 400:	00e78933          	add	s2,a5,a4
 404:	fff78993          	addi	s3,a5,-1
 408:	99ba                	add	s3,s3,a4
 40a:	377d                	addiw	a4,a4,-1
 40c:	1702                	slli	a4,a4,0x20
 40e:	9301                	srli	a4,a4,0x20
 410:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 414:	fff94583          	lbu	a1,-1(s2)
 418:	8526                	mv	a0,s1
 41a:	f5bff0ef          	jal	374 <putc>
  while(--i >= 0)
 41e:	197d                	addi	s2,s2,-1
 420:	ff391ae3          	bne	s2,s3,414 <printint+0x82>
 424:	7942                	ld	s2,48(sp)
 426:	79a2                	ld	s3,40(sp)
}
 428:	60a6                	ld	ra,72(sp)
 42a:	6406                	ld	s0,64(sp)
 42c:	74e2                	ld	s1,56(sp)
 42e:	6161                	addi	sp,sp,80
 430:	8082                	ret
    x = -xx;
 432:	40b005bb          	negw	a1,a1
    neg = 1;
 436:	4885                	li	a7,1
    x = -xx;
 438:	bf85                	j	3a8 <printint+0x16>

000000000000043a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43a:	711d                	addi	sp,sp,-96
 43c:	ec86                	sd	ra,88(sp)
 43e:	e8a2                	sd	s0,80(sp)
 440:	e0ca                	sd	s2,64(sp)
 442:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 444:	0005c903          	lbu	s2,0(a1)
 448:	28090663          	beqz	s2,6d4 <vprintf+0x29a>
 44c:	e4a6                	sd	s1,72(sp)
 44e:	fc4e                	sd	s3,56(sp)
 450:	f852                	sd	s4,48(sp)
 452:	f456                	sd	s5,40(sp)
 454:	f05a                	sd	s6,32(sp)
 456:	ec5e                	sd	s7,24(sp)
 458:	e862                	sd	s8,16(sp)
 45a:	e466                	sd	s9,8(sp)
 45c:	8b2a                	mv	s6,a0
 45e:	8a2e                	mv	s4,a1
 460:	8bb2                	mv	s7,a2
  state = 0;
 462:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 464:	4481                	li	s1,0
 466:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 468:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 46c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 470:	06c00c93          	li	s9,108
 474:	a005                	j	494 <vprintf+0x5a>
        putc(fd, c0);
 476:	85ca                	mv	a1,s2
 478:	855a                	mv	a0,s6
 47a:	efbff0ef          	jal	374 <putc>
 47e:	a019                	j	484 <vprintf+0x4a>
    } else if(state == '%'){
 480:	03598263          	beq	s3,s5,4a4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 484:	2485                	addiw	s1,s1,1
 486:	8726                	mv	a4,s1
 488:	009a07b3          	add	a5,s4,s1
 48c:	0007c903          	lbu	s2,0(a5)
 490:	22090a63          	beqz	s2,6c4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 494:	0009079b          	sext.w	a5,s2
    if(state == 0){
 498:	fe0994e3          	bnez	s3,480 <vprintf+0x46>
      if(c0 == '%'){
 49c:	fd579de3          	bne	a5,s5,476 <vprintf+0x3c>
        state = '%';
 4a0:	89be                	mv	s3,a5
 4a2:	b7cd                	j	484 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a4:	00ea06b3          	add	a3,s4,a4
 4a8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4ac:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ae:	c681                	beqz	a3,4b6 <vprintf+0x7c>
 4b0:	9752                	add	a4,a4,s4
 4b2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4b6:	05878363          	beq	a5,s8,4fc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4ba:	05978d63          	beq	a5,s9,514 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4be:	07500713          	li	a4,117
 4c2:	0ee78763          	beq	a5,a4,5b0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4c6:	07800713          	li	a4,120
 4ca:	12e78963          	beq	a5,a4,5fc <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ce:	07000713          	li	a4,112
 4d2:	14e78e63          	beq	a5,a4,62e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 4d6:	06300713          	li	a4,99
 4da:	18e78e63          	beq	a5,a4,676 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 4de:	07300713          	li	a4,115
 4e2:	1ae78463          	beq	a5,a4,68a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e6:	02500713          	li	a4,37
 4ea:	04e79563          	bne	a5,a4,534 <vprintf+0xfa>
        putc(fd, '%');
 4ee:	02500593          	li	a1,37
 4f2:	855a                	mv	a0,s6
 4f4:	e81ff0ef          	jal	374 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b769                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4685                	li	a3,1
 502:	4629                	li	a2,10
 504:	000ba583          	lw	a1,0(s7)
 508:	855a                	mv	a0,s6
 50a:	e89ff0ef          	jal	392 <printint>
 50e:	8bca                	mv	s7,s2
      state = 0;
 510:	4981                	li	s3,0
 512:	bf8d                	j	484 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 514:	06400793          	li	a5,100
 518:	02f68963          	beq	a3,a5,54a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 51c:	06c00793          	li	a5,108
 520:	04f68263          	beq	a3,a5,564 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 524:	07500793          	li	a5,117
 528:	0af68063          	beq	a3,a5,5c8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 52c:	07800793          	li	a5,120
 530:	0ef68263          	beq	a3,a5,614 <vprintf+0x1da>
        putc(fd, '%');
 534:	02500593          	li	a1,37
 538:	855a                	mv	a0,s6
 53a:	e3bff0ef          	jal	374 <putc>
        putc(fd, c0);
 53e:	85ca                	mv	a1,s2
 540:	855a                	mv	a0,s6
 542:	e33ff0ef          	jal	374 <putc>
      state = 0;
 546:	4981                	li	s3,0
 548:	bf35                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000bb583          	ld	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	e3bff0ef          	jal	392 <printint>
        i += 1;
 55c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
        i += 1;
 562:	b70d                	j	484 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	06400793          	li	a5,100
 568:	02f60763          	beq	a2,a5,596 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 56c:	07500793          	li	a5,117
 570:	06f60963          	beq	a2,a5,5e2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 574:	07800793          	li	a5,120
 578:	faf61ee3          	bne	a2,a5,534 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4641                	li	a2,16
 584:	000bb583          	ld	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	e09ff0ef          	jal	392 <printint>
        i += 2;
 58e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 2;
 594:	bdc5                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	008b8913          	addi	s2,s7,8
 59a:	4685                	li	a3,1
 59c:	4629                	li	a2,10
 59e:	000bb583          	ld	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	defff0ef          	jal	392 <printint>
        i += 2;
 5a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
        i += 2;
 5ae:	bdd9                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4629                	li	a2,10
 5b8:	000be583          	lwu	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	dd5ff0ef          	jal	392 <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bd7d                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	dbdff0ef          	jal	392 <printint>
        i += 1;
 5da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 1;
 5e0:	b555                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	008b8913          	addi	s2,s7,8
 5e6:	4681                	li	a3,0
 5e8:	4629                	li	a2,10
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	da3ff0ef          	jal	392 <printint>
        i += 2;
 5f4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f6:	8bca                	mv	s7,s2
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	b569                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5fc:	008b8913          	addi	s2,s7,8
 600:	4681                	li	a3,0
 602:	4641                	li	a2,16
 604:	000be583          	lwu	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	d89ff0ef          	jal	392 <printint>
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	bd8d                	j	484 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	008b8913          	addi	s2,s7,8
 618:	4681                	li	a3,0
 61a:	4641                	li	a2,16
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	d71ff0ef          	jal	392 <printint>
        i += 1;
 626:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 628:	8bca                	mv	s7,s2
      state = 0;
 62a:	4981                	li	s3,0
        i += 1;
 62c:	bda1                	j	484 <vprintf+0x4a>
 62e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 630:	008b8d13          	addi	s10,s7,8
 634:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 638:	03000593          	li	a1,48
 63c:	855a                	mv	a0,s6
 63e:	d37ff0ef          	jal	374 <putc>
  putc(fd, 'x');
 642:	07800593          	li	a1,120
 646:	855a                	mv	a0,s6
 648:	d2dff0ef          	jal	374 <putc>
 64c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64e:	00000b97          	auipc	s7,0x0
 652:	27ab8b93          	addi	s7,s7,634 # 8c8 <digits>
 656:	03c9d793          	srli	a5,s3,0x3c
 65a:	97de                	add	a5,a5,s7
 65c:	0007c583          	lbu	a1,0(a5)
 660:	855a                	mv	a0,s6
 662:	d13ff0ef          	jal	374 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 666:	0992                	slli	s3,s3,0x4
 668:	397d                	addiw	s2,s2,-1
 66a:	fe0916e3          	bnez	s2,656 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 66e:	8bea                	mv	s7,s10
      state = 0;
 670:	4981                	li	s3,0
 672:	6d02                	ld	s10,0(sp)
 674:	bd01                	j	484 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 676:	008b8913          	addi	s2,s7,8
 67a:	000bc583          	lbu	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	cf5ff0ef          	jal	374 <putc>
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
 688:	bbf5                	j	484 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 68a:	008b8993          	addi	s3,s7,8
 68e:	000bb903          	ld	s2,0(s7)
 692:	00090f63          	beqz	s2,6b0 <vprintf+0x276>
        for(; *s; s++)
 696:	00094583          	lbu	a1,0(s2)
 69a:	c195                	beqz	a1,6be <vprintf+0x284>
          putc(fd, *s);
 69c:	855a                	mv	a0,s6
 69e:	cd7ff0ef          	jal	374 <putc>
        for(; *s; s++)
 6a2:	0905                	addi	s2,s2,1
 6a4:	00094583          	lbu	a1,0(s2)
 6a8:	f9f5                	bnez	a1,69c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6aa:	8bce                	mv	s7,s3
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bbd9                	j	484 <vprintf+0x4a>
          s = "(null)";
 6b0:	00000917          	auipc	s2,0x0
 6b4:	21090913          	addi	s2,s2,528 # 8c0 <malloc+0x104>
        for(; *s; s++)
 6b8:	02800593          	li	a1,40
 6bc:	b7c5                	j	69c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6be:	8bce                	mv	s7,s3
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b3c9                	j	484 <vprintf+0x4a>
 6c4:	64a6                	ld	s1,72(sp)
 6c6:	79e2                	ld	s3,56(sp)
 6c8:	7a42                	ld	s4,48(sp)
 6ca:	7aa2                	ld	s5,40(sp)
 6cc:	7b02                	ld	s6,32(sp)
 6ce:	6be2                	ld	s7,24(sp)
 6d0:	6c42                	ld	s8,16(sp)
 6d2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6d4:	60e6                	ld	ra,88(sp)
 6d6:	6446                	ld	s0,80(sp)
 6d8:	6906                	ld	s2,64(sp)
 6da:	6125                	addi	sp,sp,96
 6dc:	8082                	ret

00000000000006de <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6de:	715d                	addi	sp,sp,-80
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e010                	sd	a2,0(s0)
 6e8:	e414                	sd	a3,8(s0)
 6ea:	e818                	sd	a4,16(s0)
 6ec:	ec1c                	sd	a5,24(s0)
 6ee:	03043023          	sd	a6,32(s0)
 6f2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6fa:	8622                	mv	a2,s0
 6fc:	d3fff0ef          	jal	43a <vprintf>
}
 700:	60e2                	ld	ra,24(sp)
 702:	6442                	ld	s0,16(sp)
 704:	6161                	addi	sp,sp,80
 706:	8082                	ret

0000000000000708 <printf>:

void
printf(const char *fmt, ...)
{
 708:	711d                	addi	sp,sp,-96
 70a:	ec06                	sd	ra,24(sp)
 70c:	e822                	sd	s0,16(sp)
 70e:	1000                	addi	s0,sp,32
 710:	e40c                	sd	a1,8(s0)
 712:	e810                	sd	a2,16(s0)
 714:	ec14                	sd	a3,24(s0)
 716:	f018                	sd	a4,32(s0)
 718:	f41c                	sd	a5,40(s0)
 71a:	03043823          	sd	a6,48(s0)
 71e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 722:	00840613          	addi	a2,s0,8
 726:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 72a:	85aa                	mv	a1,a0
 72c:	4505                	li	a0,1
 72e:	d0dff0ef          	jal	43a <vprintf>
}
 732:	60e2                	ld	ra,24(sp)
 734:	6442                	ld	s0,16(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret

000000000000073a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 73a:	1141                	addi	sp,sp,-16
 73c:	e422                	sd	s0,8(sp)
 73e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 740:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 744:	00001797          	auipc	a5,0x1
 748:	8bc7b783          	ld	a5,-1860(a5) # 1000 <freep>
 74c:	a02d                	j	776 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74e:	4618                	lw	a4,8(a2)
 750:	9f2d                	addw	a4,a4,a1
 752:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	6398                	ld	a4,0(a5)
 758:	6310                	ld	a2,0(a4)
 75a:	a83d                	j	798 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75c:	ff852703          	lw	a4,-8(a0)
 760:	9f31                	addw	a4,a4,a2
 762:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 764:	ff053683          	ld	a3,-16(a0)
 768:	a091                	j	7ac <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	6398                	ld	a4,0(a5)
 76c:	00e7e463          	bltu	a5,a4,774 <free+0x3a>
 770:	00e6ea63          	bltu	a3,a4,784 <free+0x4a>
{
 774:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 776:	fed7fae3          	bgeu	a5,a3,76a <free+0x30>
 77a:	6398                	ld	a4,0(a5)
 77c:	00e6e463          	bltu	a3,a4,784 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 780:	fee7eae3          	bltu	a5,a4,774 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 784:	ff852583          	lw	a1,-8(a0)
 788:	6390                	ld	a2,0(a5)
 78a:	02059813          	slli	a6,a1,0x20
 78e:	01c85713          	srli	a4,a6,0x1c
 792:	9736                	add	a4,a4,a3
 794:	fae60de3          	beq	a2,a4,74e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 798:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79c:	4790                	lw	a2,8(a5)
 79e:	02061593          	slli	a1,a2,0x20
 7a2:	01c5d713          	srli	a4,a1,0x1c
 7a6:	973e                	add	a4,a4,a5
 7a8:	fae68ae3          	beq	a3,a4,75c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ac:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ae:	00001717          	auipc	a4,0x1
 7b2:	84f73923          	sd	a5,-1966(a4) # 1000 <freep>
}
 7b6:	6422                	ld	s0,8(sp)
 7b8:	0141                	addi	sp,sp,16
 7ba:	8082                	ret

00000000000007bc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7bc:	7139                	addi	sp,sp,-64
 7be:	fc06                	sd	ra,56(sp)
 7c0:	f822                	sd	s0,48(sp)
 7c2:	f426                	sd	s1,40(sp)
 7c4:	ec4e                	sd	s3,24(sp)
 7c6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c8:	02051493          	slli	s1,a0,0x20
 7cc:	9081                	srli	s1,s1,0x20
 7ce:	04bd                	addi	s1,s1,15
 7d0:	8091                	srli	s1,s1,0x4
 7d2:	0014899b          	addiw	s3,s1,1
 7d6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7d8:	00001517          	auipc	a0,0x1
 7dc:	82853503          	ld	a0,-2008(a0) # 1000 <freep>
 7e0:	c915                	beqz	a0,814 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e4:	4798                	lw	a4,8(a5)
 7e6:	08977a63          	bgeu	a4,s1,87a <malloc+0xbe>
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	e852                	sd	s4,16(sp)
 7ee:	e456                	sd	s5,8(sp)
 7f0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7f2:	8a4e                	mv	s4,s3
 7f4:	0009871b          	sext.w	a4,s3
 7f8:	6685                	lui	a3,0x1
 7fa:	00d77363          	bgeu	a4,a3,800 <malloc+0x44>
 7fe:	6a05                	lui	s4,0x1
 800:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 804:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 808:	00000917          	auipc	s2,0x0
 80c:	7f890913          	addi	s2,s2,2040 # 1000 <freep>
  if(p == SBRK_ERROR)
 810:	5afd                	li	s5,-1
 812:	a081                	j	852 <malloc+0x96>
 814:	f04a                	sd	s2,32(sp)
 816:	e852                	sd	s4,16(sp)
 818:	e456                	sd	s5,8(sp)
 81a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 81c:	00000797          	auipc	a5,0x0
 820:	7f478793          	addi	a5,a5,2036 # 1010 <base>
 824:	00000717          	auipc	a4,0x0
 828:	7cf73e23          	sd	a5,2012(a4) # 1000 <freep>
 82c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 82e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 832:	b7c1                	j	7f2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	e118                	sd	a4,0(a0)
 838:	a8a9                	j	892 <malloc+0xd6>
  hp->s.size = nu;
 83a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 83e:	0541                	addi	a0,a0,16
 840:	efbff0ef          	jal	73a <free>
  return freep;
 844:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 848:	c12d                	beqz	a0,8aa <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 84c:	4798                	lw	a4,8(a5)
 84e:	02977263          	bgeu	a4,s1,872 <malloc+0xb6>
    if(p == freep)
 852:	00093703          	ld	a4,0(s2)
 856:	853e                	mv	a0,a5
 858:	fef719e3          	bne	a4,a5,84a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 85c:	8552                	mv	a0,s4
 85e:	a23ff0ef          	jal	280 <sbrk>
  if(p == SBRK_ERROR)
 862:	fd551ce3          	bne	a0,s5,83a <malloc+0x7e>
        return 0;
 866:	4501                	li	a0,0
 868:	7902                	ld	s2,32(sp)
 86a:	6a42                	ld	s4,16(sp)
 86c:	6aa2                	ld	s5,8(sp)
 86e:	6b02                	ld	s6,0(sp)
 870:	a03d                	j	89e <malloc+0xe2>
 872:	7902                	ld	s2,32(sp)
 874:	6a42                	ld	s4,16(sp)
 876:	6aa2                	ld	s5,8(sp)
 878:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 87a:	fae48de3          	beq	s1,a4,834 <malloc+0x78>
        p->s.size -= nunits;
 87e:	4137073b          	subw	a4,a4,s3
 882:	c798                	sw	a4,8(a5)
        p += p->s.size;
 884:	02071693          	slli	a3,a4,0x20
 888:	01c6d713          	srli	a4,a3,0x1c
 88c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 88e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 892:	00000717          	auipc	a4,0x0
 896:	76a73723          	sd	a0,1902(a4) # 1000 <freep>
      return (void*)(p + 1);
 89a:	01078513          	addi	a0,a5,16
  }
}
 89e:	70e2                	ld	ra,56(sp)
 8a0:	7442                	ld	s0,48(sp)
 8a2:	74a2                	ld	s1,40(sp)
 8a4:	69e2                	ld	s3,24(sp)
 8a6:	6121                	addi	sp,sp,64
 8a8:	8082                	ret
 8aa:	7902                	ld	s2,32(sp)
 8ac:	6a42                	ld	s4,16(sp)
 8ae:	6aa2                	ld	s5,8(sp)
 8b0:	6b02                	ld	s6,0(sp)
 8b2:	b7f5                	j	89e <malloc+0xe2>
