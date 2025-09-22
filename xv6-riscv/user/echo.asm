
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d063          	bge	a5,a0,74 <main+0x74>
  18:	00858493          	addi	s1,a1,8
  1c:	3579                	addiw	a0,a0,-2
  1e:	02051793          	slli	a5,a0,0x20
  22:	01d7d513          	srli	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	addi	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	8e0a8a93          	addi	s5,s5,-1824 # 910 <malloc+0xf8>
  38:	a809                	j	4a <main+0x4a>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	310000ef          	jal	350 <write>
  for(i = 1; i < argc; i++){
  44:	04a1                	addi	s1,s1,8
  46:	03348763          	beq	s1,s3,74 <main+0x74>
    write(1, argv[i], strlen(argv[i]));
  4a:	0004b903          	ld	s2,0(s1)
  4e:	854a                	mv	a0,s2
  50:	084000ef          	jal	d4 <strlen>
  54:	0005061b          	sext.w	a2,a0
  58:	85ca                	mv	a1,s2
  5a:	4505                	li	a0,1
  5c:	2f4000ef          	jal	350 <write>
    if(i + 1 < argc){
  60:	fd449de3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  64:	4605                	li	a2,1
  66:	00001597          	auipc	a1,0x1
  6a:	8b258593          	addi	a1,a1,-1870 # 918 <malloc+0x100>
  6e:	4505                	li	a0,1
  70:	2e0000ef          	jal	350 <write>
    }
  }
  exit(0);
  74:	4501                	li	a0,0
  76:	2ba000ef          	jal	330 <exit>

000000000000007a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  extern int main();
  main();
  82:	f7fff0ef          	jal	0 <main>
  exit(0);
  86:	4501                	li	a0,0
  88:	2a8000ef          	jal	330 <exit>

000000000000008c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  92:	87aa                	mv	a5,a0
  94:	0585                	addi	a1,a1,1
  96:	0785                	addi	a5,a5,1
  98:	fff5c703          	lbu	a4,-1(a1)
  9c:	fee78fa3          	sb	a4,-1(a5)
  a0:	fb75                	bnez	a4,94 <strcpy+0x8>
    ;
  return os;
}
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cb91                	beqz	a5,c6 <strcmp+0x1e>
  b4:	0005c703          	lbu	a4,0(a1)
  b8:	00f71763          	bne	a4,a5,c6 <strcmp+0x1e>
    p++, q++;
  bc:	0505                	addi	a0,a0,1
  be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c0:	00054783          	lbu	a5,0(a0)
  c4:	fbe5                	bnez	a5,b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c6:	0005c503          	lbu	a0,0(a1)
}
  ca:	40a7853b          	subw	a0,a5,a0
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  da:	00054783          	lbu	a5,0(a0)
  de:	cf91                	beqz	a5,fa <strlen+0x26>
  e0:	0505                	addi	a0,a0,1
  e2:	87aa                	mv	a5,a0
  e4:	86be                	mv	a3,a5
  e6:	0785                	addi	a5,a5,1
  e8:	fff7c703          	lbu	a4,-1(a5)
  ec:	ff65                	bnez	a4,e4 <strlen+0x10>
  ee:	40a6853b          	subw	a0,a3,a0
  f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret
  for(n = 0; s[n]; n++)
  fa:	4501                	li	a0,0
  fc:	bfe5                	j	f4 <strlen+0x20>

00000000000000fe <memset>:

void*
memset(void *dst, int c, uint n)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 104:	ca19                	beqz	a2,11a <memset+0x1c>
 106:	87aa                	mv	a5,a0
 108:	1602                	slli	a2,a2,0x20
 10a:	9201                	srli	a2,a2,0x20
 10c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 110:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 114:	0785                	addi	a5,a5,1
 116:	fee79de3          	bne	a5,a4,110 <memset+0x12>
  }
  return dst;
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret

0000000000000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	1141                	addi	sp,sp,-16
 122:	e422                	sd	s0,8(sp)
 124:	0800                	addi	s0,sp,16
  for(; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cb99                	beqz	a5,140 <strchr+0x20>
    if(*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1a>
  for(; *s; s++)
 130:	0505                	addi	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xc>
      return (char*)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret
  return 0;
 140:	4501                	li	a0,0
 142:	bfe5                	j	13a <strchr+0x1a>

0000000000000144 <gets>:

char*
gets(char *buf, int max)
{
 144:	711d                	addi	sp,sp,-96
 146:	ec86                	sd	ra,88(sp)
 148:	e8a2                	sd	s0,80(sp)
 14a:	e4a6                	sd	s1,72(sp)
 14c:	e0ca                	sd	s2,64(sp)
 14e:	fc4e                	sd	s3,56(sp)
 150:	f852                	sd	s4,48(sp)
 152:	f456                	sd	s5,40(sp)
 154:	f05a                	sd	s6,32(sp)
 156:	ec5e                	sd	s7,24(sp)
 158:	1080                	addi	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 162:	4aa9                	li	s5,10
 164:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 166:	89a6                	mv	s3,s1
 168:	2485                	addiw	s1,s1,1
 16a:	0344d663          	bge	s1,s4,196 <gets+0x52>
    cc = read(0, &c, 1);
 16e:	4605                	li	a2,1
 170:	faf40593          	addi	a1,s0,-81
 174:	4501                	li	a0,0
 176:	1d2000ef          	jal	348 <read>
    if(cc < 1)
 17a:	00a05e63          	blez	a0,196 <gets+0x52>
    buf[i++] = c;
 17e:	faf44783          	lbu	a5,-81(s0)
 182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 186:	01578763          	beq	a5,s5,194 <gets+0x50>
 18a:	0905                	addi	s2,s2,1
 18c:	fd679de3          	bne	a5,s6,166 <gets+0x22>
    buf[i++] = c;
 190:	89a6                	mv	s3,s1
 192:	a011                	j	196 <gets+0x52>
 194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 196:	99de                	add	s3,s3,s7
 198:	00098023          	sb	zero,0(s3)
  return buf;
}
 19c:	855e                	mv	a0,s7
 19e:	60e6                	ld	ra,88(sp)
 1a0:	6446                	ld	s0,80(sp)
 1a2:	64a6                	ld	s1,72(sp)
 1a4:	6906                	ld	s2,64(sp)
 1a6:	79e2                	ld	s3,56(sp)
 1a8:	7a42                	ld	s4,48(sp)
 1aa:	7aa2                	ld	s5,40(sp)
 1ac:	7b02                	ld	s6,32(sp)
 1ae:	6be2                	ld	s7,24(sp)
 1b0:	6125                	addi	sp,sp,96
 1b2:	8082                	ret

00000000000001b4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b4:	1101                	addi	sp,sp,-32
 1b6:	ec06                	sd	ra,24(sp)
 1b8:	e822                	sd	s0,16(sp)
 1ba:	e04a                	sd	s2,0(sp)
 1bc:	1000                	addi	s0,sp,32
 1be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c0:	4581                	li	a1,0
 1c2:	1ae000ef          	jal	370 <open>
  if(fd < 0)
 1c6:	02054263          	bltz	a0,1ea <stat+0x36>
 1ca:	e426                	sd	s1,8(sp)
 1cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ce:	85ca                	mv	a1,s2
 1d0:	1b8000ef          	jal	388 <fstat>
 1d4:	892a                	mv	s2,a0
  close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	180000ef          	jal	358 <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	addi	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x2a>

00000000000001ee <atoi>:

int
atoi(const char *s)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f4:	00054683          	lbu	a3,0(a0)
 1f8:	fd06879b          	addiw	a5,a3,-48
 1fc:	0ff7f793          	zext.b	a5,a5
 200:	4625                	li	a2,9
 202:	02f66863          	bltu	a2,a5,232 <atoi+0x44>
 206:	872a                	mv	a4,a0
  n = 0;
 208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20a:	0705                	addi	a4,a4,1
 20c:	0025179b          	slliw	a5,a0,0x2
 210:	9fa9                	addw	a5,a5,a0
 212:	0017979b          	slliw	a5,a5,0x1
 216:	9fb5                	addw	a5,a5,a3
 218:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21c:	00074683          	lbu	a3,0(a4)
 220:	fd06879b          	addiw	a5,a3,-48
 224:	0ff7f793          	zext.b	a5,a5
 228:	fef671e3          	bgeu	a2,a5,20a <atoi+0x1c>
  return n;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  n = 0;
 232:	4501                	li	a0,0
 234:	bfe5                	j	22c <atoi+0x3e>

0000000000000236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 236:	1141                	addi	sp,sp,-16
 238:	e422                	sd	s0,8(sp)
 23a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23c:	02b57463          	bgeu	a0,a1,264 <memmove+0x2e>
    while(n-- > 0)
 240:	00c05f63          	blez	a2,25e <memmove+0x28>
 244:	1602                	slli	a2,a2,0x20
 246:	9201                	srli	a2,a2,0x20
 248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24c:	872a                	mv	a4,a0
      *dst++ = *src++;
 24e:	0585                	addi	a1,a1,1
 250:	0705                	addi	a4,a4,1
 252:	fff5c683          	lbu	a3,-1(a1)
 256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25a:	fef71ae3          	bne	a4,a5,24e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    dst += n;
 264:	00c50733          	add	a4,a0,a2
    src += n;
 268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26a:	fec05ae3          	blez	a2,25e <memmove+0x28>
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fee79ae3          	bne	a5,a4,27c <memmove+0x46>
 28c:	bfc9                	j	25e <memmove+0x28>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e422                	sd	s0,8(sp)
 292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 294:	ca05                	beqz	a2,2c4 <memcmp+0x36>
 296:	fff6069b          	addiw	a3,a2,-1
 29a:	1682                	slli	a3,a3,0x20
 29c:	9281                	srli	a3,a3,0x20
 29e:	0685                	addi	a3,a3,1
 2a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	0005c703          	lbu	a4,0(a1)
 2aa:	00e79863          	bne	a5,a4,2ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2ae:	0505                	addi	a0,a0,1
    p2++;
 2b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b2:	fed518e3          	bne	a0,a3,2a2 <memcmp+0x14>
  }
  return 0;
 2b6:	4501                	li	a0,0
 2b8:	a019                	j	2be <memcmp+0x30>
      return *p1 - *p2;
 2ba:	40e7853b          	subw	a0,a5,a4
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfe5                	j	2be <memcmp+0x30>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	f67ff0ef          	jal	236 <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <sbrk>:

char *
sbrk(int n) {
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e4:	4585                	li	a1,1
 2e6:	0d2000ef          	jal	3b8 <sys_sbrk>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <sbrklazy>:

char *
sbrklazy(int n) {
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2fa:	4589                	li	a1,2
 2fc:	0bc000ef          	jal	3b8 <sys_sbrk>
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 308:	48e5                	li	a7,25
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 310:	48e1                	li	a7,24
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 318:	48dd                	li	a7,23
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <trace>:
.global trace
trace:
 li a7, SYS_trace
 320:	48d9                	li	a7,22
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <fork>:
.global fork
fork:
 li a7, SYS_fork
 328:	4885                	li	a7,1
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <exit>:
.global exit
exit:
 li a7, SYS_exit
 330:	4889                	li	a7,2
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <wait>:
.global wait
wait:
 li a7, SYS_wait
 338:	488d                	li	a7,3
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 340:	4891                	li	a7,4
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <read>:
.global read
read:
 li a7, SYS_read
 348:	4895                	li	a7,5
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <write>:
.global write
write:
 li a7, SYS_write
 350:	48c1                	li	a7,16
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <close>:
.global close
close:
 li a7, SYS_close
 358:	48d5                	li	a7,21
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <kill>:
.global kill
kill:
 li a7, SYS_kill
 360:	4899                	li	a7,6
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <exec>:
.global exec
exec:
 li a7, SYS_exec
 368:	489d                	li	a7,7
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <open>:
.global open
open:
 li a7, SYS_open
 370:	48bd                	li	a7,15
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 378:	48c5                	li	a7,17
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 380:	48c9                	li	a7,18
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 388:	48a1                	li	a7,8
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <link>:
.global link
link:
 li a7, SYS_link
 390:	48cd                	li	a7,19
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 398:	48d1                	li	a7,20
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a0:	48a5                	li	a7,9
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a8:	48a9                	li	a7,10
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b0:	48ad                	li	a7,11
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3b8:	48b1                	li	a7,12
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c0:	48b5                	li	a7,13
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c8:	48b9                	li	a7,14
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d0:	1101                	addi	sp,sp,-32
 3d2:	ec06                	sd	ra,24(sp)
 3d4:	e822                	sd	s0,16(sp)
 3d6:	1000                	addi	s0,sp,32
 3d8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3dc:	4605                	li	a2,1
 3de:	fef40593          	addi	a1,s0,-17
 3e2:	f6fff0ef          	jal	350 <write>
}
 3e6:	60e2                	ld	ra,24(sp)
 3e8:	6442                	ld	s0,16(sp)
 3ea:	6105                	addi	sp,sp,32
 3ec:	8082                	ret

00000000000003ee <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ee:	715d                	addi	sp,sp,-80
 3f0:	e486                	sd	ra,72(sp)
 3f2:	e0a2                	sd	s0,64(sp)
 3f4:	fc26                	sd	s1,56(sp)
 3f6:	0880                	addi	s0,sp,80
 3f8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fa:	c299                	beqz	a3,400 <printint+0x12>
 3fc:	0805c963          	bltz	a1,48e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 400:	2581                	sext.w	a1,a1
  neg = 0;
 402:	4881                	li	a7,0
 404:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 408:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 40a:	2601                	sext.w	a2,a2
 40c:	00000517          	auipc	a0,0x0
 410:	51c50513          	addi	a0,a0,1308 # 928 <digits>
 414:	883a                	mv	a6,a4
 416:	2705                	addiw	a4,a4,1
 418:	02c5f7bb          	remuw	a5,a1,a2
 41c:	1782                	slli	a5,a5,0x20
 41e:	9381                	srli	a5,a5,0x20
 420:	97aa                	add	a5,a5,a0
 422:	0007c783          	lbu	a5,0(a5)
 426:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 42a:	0005879b          	sext.w	a5,a1
 42e:	02c5d5bb          	divuw	a1,a1,a2
 432:	0685                	addi	a3,a3,1
 434:	fec7f0e3          	bgeu	a5,a2,414 <printint+0x26>
  if(neg)
 438:	00088c63          	beqz	a7,450 <printint+0x62>
    buf[i++] = '-';
 43c:	fd070793          	addi	a5,a4,-48
 440:	00878733          	add	a4,a5,s0
 444:	02d00793          	li	a5,45
 448:	fef70423          	sb	a5,-24(a4)
 44c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 450:	02e05a63          	blez	a4,484 <printint+0x96>
 454:	f84a                	sd	s2,48(sp)
 456:	f44e                	sd	s3,40(sp)
 458:	fb840793          	addi	a5,s0,-72
 45c:	00e78933          	add	s2,a5,a4
 460:	fff78993          	addi	s3,a5,-1
 464:	99ba                	add	s3,s3,a4
 466:	377d                	addiw	a4,a4,-1
 468:	1702                	slli	a4,a4,0x20
 46a:	9301                	srli	a4,a4,0x20
 46c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 470:	fff94583          	lbu	a1,-1(s2)
 474:	8526                	mv	a0,s1
 476:	f5bff0ef          	jal	3d0 <putc>
  while(--i >= 0)
 47a:	197d                	addi	s2,s2,-1
 47c:	ff391ae3          	bne	s2,s3,470 <printint+0x82>
 480:	7942                	ld	s2,48(sp)
 482:	79a2                	ld	s3,40(sp)
}
 484:	60a6                	ld	ra,72(sp)
 486:	6406                	ld	s0,64(sp)
 488:	74e2                	ld	s1,56(sp)
 48a:	6161                	addi	sp,sp,80
 48c:	8082                	ret
    x = -xx;
 48e:	40b005bb          	negw	a1,a1
    neg = 1;
 492:	4885                	li	a7,1
    x = -xx;
 494:	bf85                	j	404 <printint+0x16>

0000000000000496 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 496:	711d                	addi	sp,sp,-96
 498:	ec86                	sd	ra,88(sp)
 49a:	e8a2                	sd	s0,80(sp)
 49c:	e0ca                	sd	s2,64(sp)
 49e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c903          	lbu	s2,0(a1)
 4a4:	28090663          	beqz	s2,730 <vprintf+0x29a>
 4a8:	e4a6                	sd	s1,72(sp)
 4aa:	fc4e                	sd	s3,56(sp)
 4ac:	f852                	sd	s4,48(sp)
 4ae:	f456                	sd	s5,40(sp)
 4b0:	f05a                	sd	s6,32(sp)
 4b2:	ec5e                	sd	s7,24(sp)
 4b4:	e862                	sd	s8,16(sp)
 4b6:	e466                	sd	s9,8(sp)
 4b8:	8b2a                	mv	s6,a0
 4ba:	8a2e                	mv	s4,a1
 4bc:	8bb2                	mv	s7,a2
  state = 0;
 4be:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c0:	4481                	li	s1,0
 4c2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4cc:	06c00c93          	li	s9,108
 4d0:	a005                	j	4f0 <vprintf+0x5a>
        putc(fd, c0);
 4d2:	85ca                	mv	a1,s2
 4d4:	855a                	mv	a0,s6
 4d6:	efbff0ef          	jal	3d0 <putc>
 4da:	a019                	j	4e0 <vprintf+0x4a>
    } else if(state == '%'){
 4dc:	03598263          	beq	s3,s5,500 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4e0:	2485                	addiw	s1,s1,1
 4e2:	8726                	mv	a4,s1
 4e4:	009a07b3          	add	a5,s4,s1
 4e8:	0007c903          	lbu	s2,0(a5)
 4ec:	22090a63          	beqz	s2,720 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4f0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f4:	fe0994e3          	bnez	s3,4dc <vprintf+0x46>
      if(c0 == '%'){
 4f8:	fd579de3          	bne	a5,s5,4d2 <vprintf+0x3c>
        state = '%';
 4fc:	89be                	mv	s3,a5
 4fe:	b7cd                	j	4e0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 500:	00ea06b3          	add	a3,s4,a4
 504:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 508:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	c681                	beqz	a3,512 <vprintf+0x7c>
 50c:	9752                	add	a4,a4,s4
 50e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 512:	05878363          	beq	a5,s8,558 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 516:	05978d63          	beq	a5,s9,570 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 51a:	07500713          	li	a4,117
 51e:	0ee78763          	beq	a5,a4,60c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 522:	07800713          	li	a4,120
 526:	12e78963          	beq	a5,a4,658 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 52a:	07000713          	li	a4,112
 52e:	14e78e63          	beq	a5,a4,68a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 532:	06300713          	li	a4,99
 536:	18e78e63          	beq	a5,a4,6d2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 53a:	07300713          	li	a4,115
 53e:	1ae78463          	beq	a5,a4,6e6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 542:	02500713          	li	a4,37
 546:	04e79563          	bne	a5,a4,590 <vprintf+0xfa>
        putc(fd, '%');
 54a:	02500593          	li	a1,37
 54e:	855a                	mv	a0,s6
 550:	e81ff0ef          	jal	3d0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 554:	4981                	li	s3,0
 556:	b769                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 558:	008b8913          	addi	s2,s7,8
 55c:	4685                	li	a3,1
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e89ff0ef          	jal	3ee <printint>
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	bf8d                	j	4e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 570:	06400793          	li	a5,100
 574:	02f68963          	beq	a3,a5,5a6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 578:	06c00793          	li	a5,108
 57c:	04f68263          	beq	a3,a5,5c0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 580:	07500793          	li	a5,117
 584:	0af68063          	beq	a3,a5,624 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 588:	07800793          	li	a5,120
 58c:	0ef68263          	beq	a3,a5,670 <vprintf+0x1da>
        putc(fd, '%');
 590:	02500593          	li	a1,37
 594:	855a                	mv	a0,s6
 596:	e3bff0ef          	jal	3d0 <putc>
        putc(fd, c0);
 59a:	85ca                	mv	a1,s2
 59c:	855a                	mv	a0,s6
 59e:	e33ff0ef          	jal	3d0 <putc>
      state = 0;
 5a2:	4981                	li	s3,0
 5a4:	bf35                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	008b8913          	addi	s2,s7,8
 5aa:	4685                	li	a3,1
 5ac:	4629                	li	a2,10
 5ae:	000bb583          	ld	a1,0(s7)
 5b2:	855a                	mv	a0,s6
 5b4:	e3bff0ef          	jal	3ee <printint>
        i += 1;
 5b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ba:	8bca                	mv	s7,s2
      state = 0;
 5bc:	4981                	li	s3,0
        i += 1;
 5be:	b70d                	j	4e0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c0:	06400793          	li	a5,100
 5c4:	02f60763          	beq	a2,a5,5f2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c8:	07500793          	li	a5,117
 5cc:	06f60963          	beq	a2,a5,63e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5d0:	07800793          	li	a5,120
 5d4:	faf61ee3          	bne	a2,a5,590 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	008b8913          	addi	s2,s7,8
 5dc:	4681                	li	a3,0
 5de:	4641                	li	a2,16
 5e0:	000bb583          	ld	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e09ff0ef          	jal	3ee <printint>
        i += 2;
 5ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ec:	8bca                	mv	s7,s2
      state = 0;
 5ee:	4981                	li	s3,0
        i += 2;
 5f0:	bdc5                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	008b8913          	addi	s2,s7,8
 5f6:	4685                	li	a3,1
 5f8:	4629                	li	a2,10
 5fa:	000bb583          	ld	a1,0(s7)
 5fe:	855a                	mv	a0,s6
 600:	defff0ef          	jal	3ee <printint>
        i += 2;
 604:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 606:	8bca                	mv	s7,s2
      state = 0;
 608:	4981                	li	s3,0
        i += 2;
 60a:	bdd9                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60c:	008b8913          	addi	s2,s7,8
 610:	4681                	li	a3,0
 612:	4629                	li	a2,10
 614:	000be583          	lwu	a1,0(s7)
 618:	855a                	mv	a0,s6
 61a:	dd5ff0ef          	jal	3ee <printint>
 61e:	8bca                	mv	s7,s2
      state = 0;
 620:	4981                	li	s3,0
 622:	bd7d                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	008b8913          	addi	s2,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000bb583          	ld	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	dbdff0ef          	jal	3ee <printint>
        i += 1;
 636:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 638:	8bca                	mv	s7,s2
      state = 0;
 63a:	4981                	li	s3,0
        i += 1;
 63c:	b555                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	008b8913          	addi	s2,s7,8
 642:	4681                	li	a3,0
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	da3ff0ef          	jal	3ee <printint>
        i += 2;
 650:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 652:	8bca                	mv	s7,s2
      state = 0;
 654:	4981                	li	s3,0
        i += 2;
 656:	b569                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 658:	008b8913          	addi	s2,s7,8
 65c:	4681                	li	a3,0
 65e:	4641                	li	a2,16
 660:	000be583          	lwu	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	d89ff0ef          	jal	3ee <printint>
 66a:	8bca                	mv	s7,s2
      state = 0;
 66c:	4981                	li	s3,0
 66e:	bd8d                	j	4e0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	008b8913          	addi	s2,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000bb583          	ld	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	d71ff0ef          	jal	3ee <printint>
        i += 1;
 682:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 684:	8bca                	mv	s7,s2
      state = 0;
 686:	4981                	li	s3,0
        i += 1;
 688:	bda1                	j	4e0 <vprintf+0x4a>
 68a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 68c:	008b8d13          	addi	s10,s7,8
 690:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 694:	03000593          	li	a1,48
 698:	855a                	mv	a0,s6
 69a:	d37ff0ef          	jal	3d0 <putc>
  putc(fd, 'x');
 69e:	07800593          	li	a1,120
 6a2:	855a                	mv	a0,s6
 6a4:	d2dff0ef          	jal	3d0 <putc>
 6a8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6aa:	00000b97          	auipc	s7,0x0
 6ae:	27eb8b93          	addi	s7,s7,638 # 928 <digits>
 6b2:	03c9d793          	srli	a5,s3,0x3c
 6b6:	97de                	add	a5,a5,s7
 6b8:	0007c583          	lbu	a1,0(a5)
 6bc:	855a                	mv	a0,s6
 6be:	d13ff0ef          	jal	3d0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c2:	0992                	slli	s3,s3,0x4
 6c4:	397d                	addiw	s2,s2,-1
 6c6:	fe0916e3          	bnez	s2,6b2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6ca:	8bea                	mv	s7,s10
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	6d02                	ld	s10,0(sp)
 6d0:	bd01                	j	4e0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	000bc583          	lbu	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	cf5ff0ef          	jal	3d0 <putc>
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
 6e4:	bbf5                	j	4e0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	008b8993          	addi	s3,s7,8
 6ea:	000bb903          	ld	s2,0(s7)
 6ee:	00090f63          	beqz	s2,70c <vprintf+0x276>
        for(; *s; s++)
 6f2:	00094583          	lbu	a1,0(s2)
 6f6:	c195                	beqz	a1,71a <vprintf+0x284>
          putc(fd, *s);
 6f8:	855a                	mv	a0,s6
 6fa:	cd7ff0ef          	jal	3d0 <putc>
        for(; *s; s++)
 6fe:	0905                	addi	s2,s2,1
 700:	00094583          	lbu	a1,0(s2)
 704:	f9f5                	bnez	a1,6f8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	bbd9                	j	4e0 <vprintf+0x4a>
          s = "(null)";
 70c:	00000917          	auipc	s2,0x0
 710:	21490913          	addi	s2,s2,532 # 920 <malloc+0x108>
        for(; *s; s++)
 714:	02800593          	li	a1,40
 718:	b7c5                	j	6f8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	b3c9                	j	4e0 <vprintf+0x4a>
 720:	64a6                	ld	s1,72(sp)
 722:	79e2                	ld	s3,56(sp)
 724:	7a42                	ld	s4,48(sp)
 726:	7aa2                	ld	s5,40(sp)
 728:	7b02                	ld	s6,32(sp)
 72a:	6be2                	ld	s7,24(sp)
 72c:	6c42                	ld	s8,16(sp)
 72e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 730:	60e6                	ld	ra,88(sp)
 732:	6446                	ld	s0,80(sp)
 734:	6906                	ld	s2,64(sp)
 736:	6125                	addi	sp,sp,96
 738:	8082                	ret

000000000000073a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 756:	8622                	mv	a2,s0
 758:	d3fff0ef          	jal	496 <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	d0dff0ef          	jal	496 <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 796:	1141                	addi	sp,sp,-16
 798:	e422                	sd	s0,8(sp)
 79a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a0:	00001797          	auipc	a5,0x1
 7a4:	8607b783          	ld	a5,-1952(a5) # 1000 <freep>
 7a8:	a02d                	j	7d2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7aa:	4618                	lw	a4,8(a2)
 7ac:	9f2d                	addw	a4,a4,a1
 7ae:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	6398                	ld	a4,0(a5)
 7b4:	6310                	ld	a2,0(a4)
 7b6:	a83d                	j	7f4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b8:	ff852703          	lw	a4,-8(a0)
 7bc:	9f31                	addw	a4,a4,a2
 7be:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7c0:	ff053683          	ld	a3,-16(a0)
 7c4:	a091                	j	808 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e7e463          	bltu	a5,a4,7d0 <free+0x3a>
 7cc:	00e6ea63          	bltu	a3,a4,7e0 <free+0x4a>
{
 7d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	fed7fae3          	bgeu	a5,a3,7c6 <free+0x30>
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e6e463          	bltu	a3,a4,7e0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	fee7eae3          	bltu	a5,a4,7d0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059813          	slli	a6,a1,0x20
 7ea:	01c85713          	srli	a4,a6,0x1c
 7ee:	9736                	add	a4,a4,a3
 7f0:	fae60de3          	beq	a2,a4,7aa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061593          	slli	a1,a2,0x20
 7fe:	01c5d713          	srli	a4,a1,0x1c
 802:	973e                	add	a4,a4,a5
 804:	fae68ae3          	beq	a3,a4,7b8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 808:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	7ef73b23          	sd	a5,2038(a4) # 1000 <freep>
}
 812:	6422                	ld	s0,8(sp)
 814:	0141                	addi	sp,sp,16
 816:	8082                	ret

0000000000000818 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 818:	7139                	addi	sp,sp,-64
 81a:	fc06                	sd	ra,56(sp)
 81c:	f822                	sd	s0,48(sp)
 81e:	f426                	sd	s1,40(sp)
 820:	ec4e                	sd	s3,24(sp)
 822:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 824:	02051493          	slli	s1,a0,0x20
 828:	9081                	srli	s1,s1,0x20
 82a:	04bd                	addi	s1,s1,15
 82c:	8091                	srli	s1,s1,0x4
 82e:	0014899b          	addiw	s3,s1,1
 832:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 834:	00000517          	auipc	a0,0x0
 838:	7cc53503          	ld	a0,1996(a0) # 1000 <freep>
 83c:	c915                	beqz	a0,870 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 840:	4798                	lw	a4,8(a5)
 842:	08977a63          	bgeu	a4,s1,8d6 <malloc+0xbe>
 846:	f04a                	sd	s2,32(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 84e:	8a4e                	mv	s4,s3
 850:	0009871b          	sext.w	a4,s3
 854:	6685                	lui	a3,0x1
 856:	00d77363          	bgeu	a4,a3,85c <malloc+0x44>
 85a:	6a05                	lui	s4,0x1
 85c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 860:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 864:	00000917          	auipc	s2,0x0
 868:	79c90913          	addi	s2,s2,1948 # 1000 <freep>
  if(p == SBRK_ERROR)
 86c:	5afd                	li	s5,-1
 86e:	a081                	j	8ae <malloc+0x96>
 870:	f04a                	sd	s2,32(sp)
 872:	e852                	sd	s4,16(sp)
 874:	e456                	sd	s5,8(sp)
 876:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 878:	00000797          	auipc	a5,0x0
 87c:	79878793          	addi	a5,a5,1944 # 1010 <base>
 880:	00000717          	auipc	a4,0x0
 884:	78f73023          	sd	a5,1920(a4) # 1000 <freep>
 888:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 88e:	b7c1                	j	84e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 890:	6398                	ld	a4,0(a5)
 892:	e118                	sd	a4,0(a0)
 894:	a8a9                	j	8ee <malloc+0xd6>
  hp->s.size = nu;
 896:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89a:	0541                	addi	a0,a0,16
 89c:	efbff0ef          	jal	796 <free>
  return freep;
 8a0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8a4:	c12d                	beqz	a0,906 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	02977263          	bgeu	a4,s1,8ce <malloc+0xb6>
    if(p == freep)
 8ae:	00093703          	ld	a4,0(s2)
 8b2:	853e                	mv	a0,a5
 8b4:	fef719e3          	bne	a4,a5,8a6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8b8:	8552                	mv	a0,s4
 8ba:	a23ff0ef          	jal	2dc <sbrk>
  if(p == SBRK_ERROR)
 8be:	fd551ce3          	bne	a0,s5,896 <malloc+0x7e>
        return 0;
 8c2:	4501                	li	a0,0
 8c4:	7902                	ld	s2,32(sp)
 8c6:	6a42                	ld	s4,16(sp)
 8c8:	6aa2                	ld	s5,8(sp)
 8ca:	6b02                	ld	s6,0(sp)
 8cc:	a03d                	j	8fa <malloc+0xe2>
 8ce:	7902                	ld	s2,32(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d6:	fae48de3          	beq	s1,a4,890 <malloc+0x78>
        p->s.size -= nunits;
 8da:	4137073b          	subw	a4,a4,s3
 8de:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8e0:	02071693          	slli	a3,a4,0x20
 8e4:	01c6d713          	srli	a4,a3,0x1c
 8e8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ea:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70a73923          	sd	a0,1810(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f6:	01078513          	addi	a0,a5,16
  }
}
 8fa:	70e2                	ld	ra,56(sp)
 8fc:	7442                	ld	s0,48(sp)
 8fe:	74a2                	ld	s1,40(sp)
 900:	69e2                	ld	s3,24(sp)
 902:	6121                	addi	sp,sp,64
 904:	8082                	ret
 906:	7902                	ld	s2,32(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
 90e:	b7f5                	j	8fa <malloc+0xe2>
