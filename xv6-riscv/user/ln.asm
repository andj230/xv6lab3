
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	8e058593          	addi	a1,a1,-1824 # 8f0 <malloc+0x104>
  18:	4509                	li	a0,2
  1a:	6f4000ef          	jal	70e <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	8ca58593          	addi	a1,a1,-1846 # 908 <malloc+0x11c>
  46:	4509                	li	a0,2
  48:	6c6000ef          	jal	70e <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  extern int main();
  main();
  56:	fabff0ef          	jal	0 <main>
  exit(0);
  5a:	4501                	li	a0,0
  5c:	2a8000ef          	jal	304 <exit>

0000000000000060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  60:	1141                	addi	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0x8>
    ;
  return os;
}
  76:	6422                	ld	s0,8(sp)
  78:	0141                	addi	sp,sp,16
  7a:	8082                	ret

000000000000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  82:	00054783          	lbu	a5,0(a0)
  86:	cb91                	beqz	a5,9a <strcmp+0x1e>
  88:	0005c703          	lbu	a4,0(a1)
  8c:	00f71763          	bne	a4,a5,9a <strcmp+0x1e>
    p++, q++;
  90:	0505                	addi	a0,a0,1
  92:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  94:	00054783          	lbu	a5,0(a0)
  98:	fbe5                	bnez	a5,88 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9a:	0005c503          	lbu	a0,0(a1)
}
  9e:	40a7853b          	subw	a0,a5,a0
  a2:	6422                	ld	s0,8(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret

00000000000000a8 <strlen>:

uint
strlen(const char *s)
{
  a8:	1141                	addi	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ae:	00054783          	lbu	a5,0(a0)
  b2:	cf91                	beqz	a5,ce <strlen+0x26>
  b4:	0505                	addi	a0,a0,1
  b6:	87aa                	mv	a5,a0
  b8:	86be                	mv	a3,a5
  ba:	0785                	addi	a5,a5,1
  bc:	fff7c703          	lbu	a4,-1(a5)
  c0:	ff65                	bnez	a4,b8 <strlen+0x10>
  c2:	40a6853b          	subw	a0,a3,a0
  c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret
  for(n = 0; s[n]; n++)
  ce:	4501                	li	a0,0
  d0:	bfe5                	j	c8 <strlen+0x20>

00000000000000d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e422                	sd	s0,8(sp)
  d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  d8:	ca19                	beqz	a2,ee <memset+0x1c>
  da:	87aa                	mv	a5,a0
  dc:	1602                	slli	a2,a2,0x20
  de:	9201                	srli	a2,a2,0x20
  e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  e8:	0785                	addi	a5,a5,1
  ea:	fee79de3          	bne	a5,a4,e4 <memset+0x12>
  }
  return dst;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret

00000000000000f4 <strchr>:

char*
strchr(const char *s, char c)
{
  f4:	1141                	addi	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fa:	00054783          	lbu	a5,0(a0)
  fe:	cb99                	beqz	a5,114 <strchr+0x20>
    if(*s == c)
 100:	00f58763          	beq	a1,a5,10e <strchr+0x1a>
  for(; *s; s++)
 104:	0505                	addi	a0,a0,1
 106:	00054783          	lbu	a5,0(a0)
 10a:	fbfd                	bnez	a5,100 <strchr+0xc>
      return (char*)s;
  return 0;
 10c:	4501                	li	a0,0
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  return 0;
 114:	4501                	li	a0,0
 116:	bfe5                	j	10e <strchr+0x1a>

0000000000000118 <gets>:

char*
gets(char *buf, int max)
{
 118:	711d                	addi	sp,sp,-96
 11a:	ec86                	sd	ra,88(sp)
 11c:	e8a2                	sd	s0,80(sp)
 11e:	e4a6                	sd	s1,72(sp)
 120:	e0ca                	sd	s2,64(sp)
 122:	fc4e                	sd	s3,56(sp)
 124:	f852                	sd	s4,48(sp)
 126:	f456                	sd	s5,40(sp)
 128:	f05a                	sd	s6,32(sp)
 12a:	ec5e                	sd	s7,24(sp)
 12c:	1080                	addi	s0,sp,96
 12e:	8baa                	mv	s7,a0
 130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 132:	892a                	mv	s2,a0
 134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 136:	4aa9                	li	s5,10
 138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13a:	89a6                	mv	s3,s1
 13c:	2485                	addiw	s1,s1,1
 13e:	0344d663          	bge	s1,s4,16a <gets+0x52>
    cc = read(0, &c, 1);
 142:	4605                	li	a2,1
 144:	faf40593          	addi	a1,s0,-81
 148:	4501                	li	a0,0
 14a:	1d2000ef          	jal	31c <read>
    if(cc < 1)
 14e:	00a05e63          	blez	a0,16a <gets+0x52>
    buf[i++] = c;
 152:	faf44783          	lbu	a5,-81(s0)
 156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15a:	01578763          	beq	a5,s5,168 <gets+0x50>
 15e:	0905                	addi	s2,s2,1
 160:	fd679de3          	bne	a5,s6,13a <gets+0x22>
    buf[i++] = c;
 164:	89a6                	mv	s3,s1
 166:	a011                	j	16a <gets+0x52>
 168:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 16a:	99de                	add	s3,s3,s7
 16c:	00098023          	sb	zero,0(s3)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6125                	addi	sp,sp,96
 186:	8082                	ret

0000000000000188 <stat>:

int
stat(const char *n, struct stat *st)
{
 188:	1101                	addi	sp,sp,-32
 18a:	ec06                	sd	ra,24(sp)
 18c:	e822                	sd	s0,16(sp)
 18e:	e04a                	sd	s2,0(sp)
 190:	1000                	addi	s0,sp,32
 192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 194:	4581                	li	a1,0
 196:	1ae000ef          	jal	344 <open>
  if(fd < 0)
 19a:	02054263          	bltz	a0,1be <stat+0x36>
 19e:	e426                	sd	s1,8(sp)
 1a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a2:	85ca                	mv	a1,s2
 1a4:	1b8000ef          	jal	35c <fstat>
 1a8:	892a                	mv	s2,a0
  close(fd);
 1aa:	8526                	mv	a0,s1
 1ac:	180000ef          	jal	32c <close>
  return r;
 1b0:	64a2                	ld	s1,8(sp)
}
 1b2:	854a                	mv	a0,s2
 1b4:	60e2                	ld	ra,24(sp)
 1b6:	6442                	ld	s0,16(sp)
 1b8:	6902                	ld	s2,0(sp)
 1ba:	6105                	addi	sp,sp,32
 1bc:	8082                	ret
    return -1;
 1be:	597d                	li	s2,-1
 1c0:	bfcd                	j	1b2 <stat+0x2a>

00000000000001c2 <atoi>:

int
atoi(const char *s)
{
 1c2:	1141                	addi	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c8:	00054683          	lbu	a3,0(a0)
 1cc:	fd06879b          	addiw	a5,a3,-48
 1d0:	0ff7f793          	zext.b	a5,a5
 1d4:	4625                	li	a2,9
 1d6:	02f66863          	bltu	a2,a5,206 <atoi+0x44>
 1da:	872a                	mv	a4,a0
  n = 0;
 1dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1de:	0705                	addi	a4,a4,1
 1e0:	0025179b          	slliw	a5,a0,0x2
 1e4:	9fa9                	addw	a5,a5,a0
 1e6:	0017979b          	slliw	a5,a5,0x1
 1ea:	9fb5                	addw	a5,a5,a3
 1ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f0:	00074683          	lbu	a3,0(a4)
 1f4:	fd06879b          	addiw	a5,a3,-48
 1f8:	0ff7f793          	zext.b	a5,a5
 1fc:	fef671e3          	bgeu	a2,a5,1de <atoi+0x1c>
  return n;
}
 200:	6422                	ld	s0,8(sp)
 202:	0141                	addi	sp,sp,16
 204:	8082                	ret
  n = 0;
 206:	4501                	li	a0,0
 208:	bfe5                	j	200 <atoi+0x3e>

000000000000020a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 20a:	1141                	addi	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 210:	02b57463          	bgeu	a0,a1,238 <memmove+0x2e>
    while(n-- > 0)
 214:	00c05f63          	blez	a2,232 <memmove+0x28>
 218:	1602                	slli	a2,a2,0x20
 21a:	9201                	srli	a2,a2,0x20
 21c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 220:	872a                	mv	a4,a0
      *dst++ = *src++;
 222:	0585                	addi	a1,a1,1
 224:	0705                	addi	a4,a4,1
 226:	fff5c683          	lbu	a3,-1(a1)
 22a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22e:	fef71ae3          	bne	a4,a5,222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 232:	6422                	ld	s0,8(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec05ae3          	blez	a2,232 <memmove+0x28>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fee79ae3          	bne	a5,a4,250 <memmove+0x46>
 260:	bfc9                	j	232 <memmove+0x28>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e422                	sd	s0,8(sp)
 266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 268:	ca05                	beqz	a2,298 <memcmp+0x36>
 26a:	fff6069b          	addiw	a3,a2,-1
 26e:	1682                	slli	a3,a3,0x20
 270:	9281                	srli	a3,a3,0x20
 272:	0685                	addi	a3,a3,1
 274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 276:	00054783          	lbu	a5,0(a0)
 27a:	0005c703          	lbu	a4,0(a1)
 27e:	00e79863          	bne	a5,a4,28e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 282:	0505                	addi	a0,a0,1
    p2++;
 284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 286:	fed518e3          	bne	a0,a3,276 <memcmp+0x14>
  }
  return 0;
 28a:	4501                	li	a0,0
 28c:	a019                	j	292 <memcmp+0x30>
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
}
 292:	6422                	ld	s0,8(sp)
 294:	0141                	addi	sp,sp,16
 296:	8082                	ret
  return 0;
 298:	4501                	li	a0,0
 29a:	bfe5                	j	292 <memcmp+0x30>

000000000000029c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 29c:	1141                	addi	sp,sp,-16
 29e:	e406                	sd	ra,8(sp)
 2a0:	e022                	sd	s0,0(sp)
 2a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a4:	f67ff0ef          	jal	20a <memmove>
}
 2a8:	60a2                	ld	ra,8(sp)
 2aa:	6402                	ld	s0,0(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret

00000000000002b0 <sbrk>:

char *
sbrk(int n) {
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2b8:	4585                	li	a1,1
 2ba:	0d2000ef          	jal	38c <sys_sbrk>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <sbrklazy>:

char *
sbrklazy(int n) {
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ce:	4589                	li	a1,2
 2d0:	0bc000ef          	jal	38c <sys_sbrk>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 2dc:	48e5                	li	a7,25
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 2e4:	48e1                	li	a7,24
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 2ec:	48dd                	li	a7,23
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 2f4:	48d9                	li	a7,22
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <fork>:
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a4:	1101                	addi	sp,sp,-32
 3a6:	ec06                	sd	ra,24(sp)
 3a8:	e822                	sd	s0,16(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b0:	4605                	li	a2,1
 3b2:	fef40593          	addi	a1,s0,-17
 3b6:	f6fff0ef          	jal	324 <write>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	6105                	addi	sp,sp,32
 3c0:	8082                	ret

00000000000003c2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3c2:	715d                	addi	sp,sp,-80
 3c4:	e486                	sd	ra,72(sp)
 3c6:	e0a2                	sd	s0,64(sp)
 3c8:	fc26                	sd	s1,56(sp)
 3ca:	0880                	addi	s0,sp,80
 3cc:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ce:	c299                	beqz	a3,3d4 <printint+0x12>
 3d0:	0805c963          	bltz	a1,462 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3d4:	2581                	sext.w	a1,a1
  neg = 0;
 3d6:	4881                	li	a7,0
 3d8:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3dc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3de:	2601                	sext.w	a2,a2
 3e0:	00000517          	auipc	a0,0x0
 3e4:	54850513          	addi	a0,a0,1352 # 928 <digits>
 3e8:	883a                	mv	a6,a4
 3ea:	2705                	addiw	a4,a4,1
 3ec:	02c5f7bb          	remuw	a5,a1,a2
 3f0:	1782                	slli	a5,a5,0x20
 3f2:	9381                	srli	a5,a5,0x20
 3f4:	97aa                	add	a5,a5,a0
 3f6:	0007c783          	lbu	a5,0(a5)
 3fa:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3fe:	0005879b          	sext.w	a5,a1
 402:	02c5d5bb          	divuw	a1,a1,a2
 406:	0685                	addi	a3,a3,1
 408:	fec7f0e3          	bgeu	a5,a2,3e8 <printint+0x26>
  if(neg)
 40c:	00088c63          	beqz	a7,424 <printint+0x62>
    buf[i++] = '-';
 410:	fd070793          	addi	a5,a4,-48
 414:	00878733          	add	a4,a5,s0
 418:	02d00793          	li	a5,45
 41c:	fef70423          	sb	a5,-24(a4)
 420:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 424:	02e05a63          	blez	a4,458 <printint+0x96>
 428:	f84a                	sd	s2,48(sp)
 42a:	f44e                	sd	s3,40(sp)
 42c:	fb840793          	addi	a5,s0,-72
 430:	00e78933          	add	s2,a5,a4
 434:	fff78993          	addi	s3,a5,-1
 438:	99ba                	add	s3,s3,a4
 43a:	377d                	addiw	a4,a4,-1
 43c:	1702                	slli	a4,a4,0x20
 43e:	9301                	srli	a4,a4,0x20
 440:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 444:	fff94583          	lbu	a1,-1(s2)
 448:	8526                	mv	a0,s1
 44a:	f5bff0ef          	jal	3a4 <putc>
  while(--i >= 0)
 44e:	197d                	addi	s2,s2,-1
 450:	ff391ae3          	bne	s2,s3,444 <printint+0x82>
 454:	7942                	ld	s2,48(sp)
 456:	79a2                	ld	s3,40(sp)
}
 458:	60a6                	ld	ra,72(sp)
 45a:	6406                	ld	s0,64(sp)
 45c:	74e2                	ld	s1,56(sp)
 45e:	6161                	addi	sp,sp,80
 460:	8082                	ret
    x = -xx;
 462:	40b005bb          	negw	a1,a1
    neg = 1;
 466:	4885                	li	a7,1
    x = -xx;
 468:	bf85                	j	3d8 <printint+0x16>

000000000000046a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 46a:	711d                	addi	sp,sp,-96
 46c:	ec86                	sd	ra,88(sp)
 46e:	e8a2                	sd	s0,80(sp)
 470:	e0ca                	sd	s2,64(sp)
 472:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 474:	0005c903          	lbu	s2,0(a1)
 478:	28090663          	beqz	s2,704 <vprintf+0x29a>
 47c:	e4a6                	sd	s1,72(sp)
 47e:	fc4e                	sd	s3,56(sp)
 480:	f852                	sd	s4,48(sp)
 482:	f456                	sd	s5,40(sp)
 484:	f05a                	sd	s6,32(sp)
 486:	ec5e                	sd	s7,24(sp)
 488:	e862                	sd	s8,16(sp)
 48a:	e466                	sd	s9,8(sp)
 48c:	8b2a                	mv	s6,a0
 48e:	8a2e                	mv	s4,a1
 490:	8bb2                	mv	s7,a2
  state = 0;
 492:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 494:	4481                	li	s1,0
 496:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 498:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 49c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4a0:	06c00c93          	li	s9,108
 4a4:	a005                	j	4c4 <vprintf+0x5a>
        putc(fd, c0);
 4a6:	85ca                	mv	a1,s2
 4a8:	855a                	mv	a0,s6
 4aa:	efbff0ef          	jal	3a4 <putc>
 4ae:	a019                	j	4b4 <vprintf+0x4a>
    } else if(state == '%'){
 4b0:	03598263          	beq	s3,s5,4d4 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4b4:	2485                	addiw	s1,s1,1
 4b6:	8726                	mv	a4,s1
 4b8:	009a07b3          	add	a5,s4,s1
 4bc:	0007c903          	lbu	s2,0(a5)
 4c0:	22090a63          	beqz	s2,6f4 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4c4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4c8:	fe0994e3          	bnez	s3,4b0 <vprintf+0x46>
      if(c0 == '%'){
 4cc:	fd579de3          	bne	a5,s5,4a6 <vprintf+0x3c>
        state = '%';
 4d0:	89be                	mv	s3,a5
 4d2:	b7cd                	j	4b4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4d4:	00ea06b3          	add	a3,s4,a4
 4d8:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4dc:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4de:	c681                	beqz	a3,4e6 <vprintf+0x7c>
 4e0:	9752                	add	a4,a4,s4
 4e2:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4e6:	05878363          	beq	a5,s8,52c <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	05978d63          	beq	a5,s9,544 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4ee:	07500713          	li	a4,117
 4f2:	0ee78763          	beq	a5,a4,5e0 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4f6:	07800713          	li	a4,120
 4fa:	12e78963          	beq	a5,a4,62c <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4fe:	07000713          	li	a4,112
 502:	14e78e63          	beq	a5,a4,65e <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 506:	06300713          	li	a4,99
 50a:	18e78e63          	beq	a5,a4,6a6 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 50e:	07300713          	li	a4,115
 512:	1ae78463          	beq	a5,a4,6ba <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 516:	02500713          	li	a4,37
 51a:	04e79563          	bne	a5,a4,564 <vprintf+0xfa>
        putc(fd, '%');
 51e:	02500593          	li	a1,37
 522:	855a                	mv	a0,s6
 524:	e81ff0ef          	jal	3a4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 528:	4981                	li	s3,0
 52a:	b769                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 52c:	008b8913          	addi	s2,s7,8
 530:	4685                	li	a3,1
 532:	4629                	li	a2,10
 534:	000ba583          	lw	a1,0(s7)
 538:	855a                	mv	a0,s6
 53a:	e89ff0ef          	jal	3c2 <printint>
 53e:	8bca                	mv	s7,s2
      state = 0;
 540:	4981                	li	s3,0
 542:	bf8d                	j	4b4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 544:	06400793          	li	a5,100
 548:	02f68963          	beq	a3,a5,57a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54c:	06c00793          	li	a5,108
 550:	04f68263          	beq	a3,a5,594 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 554:	07500793          	li	a5,117
 558:	0af68063          	beq	a3,a5,5f8 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 55c:	07800793          	li	a5,120
 560:	0ef68263          	beq	a3,a5,644 <vprintf+0x1da>
        putc(fd, '%');
 564:	02500593          	li	a1,37
 568:	855a                	mv	a0,s6
 56a:	e3bff0ef          	jal	3a4 <putc>
        putc(fd, c0);
 56e:	85ca                	mv	a1,s2
 570:	855a                	mv	a0,s6
 572:	e33ff0ef          	jal	3a4 <putc>
      state = 0;
 576:	4981                	li	s3,0
 578:	bf35                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 57a:	008b8913          	addi	s2,s7,8
 57e:	4685                	li	a3,1
 580:	4629                	li	a2,10
 582:	000bb583          	ld	a1,0(s7)
 586:	855a                	mv	a0,s6
 588:	e3bff0ef          	jal	3c2 <printint>
        i += 1;
 58c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 58e:	8bca                	mv	s7,s2
      state = 0;
 590:	4981                	li	s3,0
        i += 1;
 592:	b70d                	j	4b4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 594:	06400793          	li	a5,100
 598:	02f60763          	beq	a2,a5,5c6 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 59c:	07500793          	li	a5,117
 5a0:	06f60963          	beq	a2,a5,612 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5a4:	07800793          	li	a5,120
 5a8:	faf61ee3          	bne	a2,a5,564 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4641                	li	a2,16
 5b4:	000bb583          	ld	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	e09ff0ef          	jal	3c2 <printint>
        i += 2;
 5be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c0:	8bca                	mv	s7,s2
      state = 0;
 5c2:	4981                	li	s3,0
        i += 2;
 5c4:	bdc5                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	008b8913          	addi	s2,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000bb583          	ld	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	defff0ef          	jal	3c2 <printint>
        i += 2;
 5d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	8bca                	mv	s7,s2
      state = 0;
 5dc:	4981                	li	s3,0
        i += 2;
 5de:	bdd9                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5e0:	008b8913          	addi	s2,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000be583          	lwu	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	dd5ff0ef          	jal	3c2 <printint>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bd7d                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	dbdff0ef          	jal	3c2 <printint>
        i += 1;
 60a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
        i += 1;
 610:	b555                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 612:	008b8913          	addi	s2,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000bb583          	ld	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	da3ff0ef          	jal	3c2 <printint>
        i += 2;
 624:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	8bca                	mv	s7,s2
      state = 0;
 628:	4981                	li	s3,0
        i += 2;
 62a:	b569                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 62c:	008b8913          	addi	s2,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000be583          	lwu	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	d89ff0ef          	jal	3c2 <printint>
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
 642:	bd8d                	j	4b4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d71ff0ef          	jal	3c2 <printint>
        i += 1;
 656:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
        i += 1;
 65c:	bda1                	j	4b4 <vprintf+0x4a>
 65e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 660:	008b8d13          	addi	s10,s7,8
 664:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	855a                	mv	a0,s6
 66e:	d37ff0ef          	jal	3a4 <putc>
  putc(fd, 'x');
 672:	07800593          	li	a1,120
 676:	855a                	mv	a0,s6
 678:	d2dff0ef          	jal	3a4 <putc>
 67c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 67e:	00000b97          	auipc	s7,0x0
 682:	2aab8b93          	addi	s7,s7,682 # 928 <digits>
 686:	03c9d793          	srli	a5,s3,0x3c
 68a:	97de                	add	a5,a5,s7
 68c:	0007c583          	lbu	a1,0(a5)
 690:	855a                	mv	a0,s6
 692:	d13ff0ef          	jal	3a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 696:	0992                	slli	s3,s3,0x4
 698:	397d                	addiw	s2,s2,-1
 69a:	fe0916e3          	bnez	s2,686 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 69e:	8bea                	mv	s7,s10
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	6d02                	ld	s10,0(sp)
 6a4:	bd01                	j	4b4 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	000bc583          	lbu	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	cf5ff0ef          	jal	3a4 <putc>
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bbf5                	j	4b4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6ba:	008b8993          	addi	s3,s7,8
 6be:	000bb903          	ld	s2,0(s7)
 6c2:	00090f63          	beqz	s2,6e0 <vprintf+0x276>
        for(; *s; s++)
 6c6:	00094583          	lbu	a1,0(s2)
 6ca:	c195                	beqz	a1,6ee <vprintf+0x284>
          putc(fd, *s);
 6cc:	855a                	mv	a0,s6
 6ce:	cd7ff0ef          	jal	3a4 <putc>
        for(; *s; s++)
 6d2:	0905                	addi	s2,s2,1
 6d4:	00094583          	lbu	a1,0(s2)
 6d8:	f9f5                	bnez	a1,6cc <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6da:	8bce                	mv	s7,s3
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bbd9                	j	4b4 <vprintf+0x4a>
          s = "(null)";
 6e0:	00000917          	auipc	s2,0x0
 6e4:	24090913          	addi	s2,s2,576 # 920 <malloc+0x134>
        for(; *s; s++)
 6e8:	02800593          	li	a1,40
 6ec:	b7c5                	j	6cc <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6ee:	8bce                	mv	s7,s3
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	b3c9                	j	4b4 <vprintf+0x4a>
 6f4:	64a6                	ld	s1,72(sp)
 6f6:	79e2                	ld	s3,56(sp)
 6f8:	7a42                	ld	s4,48(sp)
 6fa:	7aa2                	ld	s5,40(sp)
 6fc:	7b02                	ld	s6,32(sp)
 6fe:	6be2                	ld	s7,24(sp)
 700:	6c42                	ld	s8,16(sp)
 702:	6ca2                	ld	s9,8(sp)
    }
  }
}
 704:	60e6                	ld	ra,88(sp)
 706:	6446                	ld	s0,80(sp)
 708:	6906                	ld	s2,64(sp)
 70a:	6125                	addi	sp,sp,96
 70c:	8082                	ret

000000000000070e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 70e:	715d                	addi	sp,sp,-80
 710:	ec06                	sd	ra,24(sp)
 712:	e822                	sd	s0,16(sp)
 714:	1000                	addi	s0,sp,32
 716:	e010                	sd	a2,0(s0)
 718:	e414                	sd	a3,8(s0)
 71a:	e818                	sd	a4,16(s0)
 71c:	ec1c                	sd	a5,24(s0)
 71e:	03043023          	sd	a6,32(s0)
 722:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 726:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 72a:	8622                	mv	a2,s0
 72c:	d3fff0ef          	jal	46a <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6161                	addi	sp,sp,80
 736:	8082                	ret

0000000000000738 <printf>:

void
printf(const char *fmt, ...)
{
 738:	711d                	addi	sp,sp,-96
 73a:	ec06                	sd	ra,24(sp)
 73c:	e822                	sd	s0,16(sp)
 73e:	1000                	addi	s0,sp,32
 740:	e40c                	sd	a1,8(s0)
 742:	e810                	sd	a2,16(s0)
 744:	ec14                	sd	a3,24(s0)
 746:	f018                	sd	a4,32(s0)
 748:	f41c                	sd	a5,40(s0)
 74a:	03043823          	sd	a6,48(s0)
 74e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	00840613          	addi	a2,s0,8
 756:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75a:	85aa                	mv	a1,a0
 75c:	4505                	li	a0,1
 75e:	d0dff0ef          	jal	46a <vprintf>
}
 762:	60e2                	ld	ra,24(sp)
 764:	6442                	ld	s0,16(sp)
 766:	6125                	addi	sp,sp,96
 768:	8082                	ret

000000000000076a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76a:	1141                	addi	sp,sp,-16
 76c:	e422                	sd	s0,8(sp)
 76e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 770:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	00001797          	auipc	a5,0x1
 778:	88c7b783          	ld	a5,-1908(a5) # 1000 <freep>
 77c:	a02d                	j	7a6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77e:	4618                	lw	a4,8(a2)
 780:	9f2d                	addw	a4,a4,a1
 782:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	6398                	ld	a4,0(a5)
 788:	6310                	ld	a2,0(a4)
 78a:	a83d                	j	7c8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78c:	ff852703          	lw	a4,-8(a0)
 790:	9f31                	addw	a4,a4,a2
 792:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 794:	ff053683          	ld	a3,-16(a0)
 798:	a091                	j	7dc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	6398                	ld	a4,0(a5)
 79c:	00e7e463          	bltu	a5,a4,7a4 <free+0x3a>
 7a0:	00e6ea63          	bltu	a3,a4,7b4 <free+0x4a>
{
 7a4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	fed7fae3          	bgeu	a5,a3,79a <free+0x30>
 7aa:	6398                	ld	a4,0(a5)
 7ac:	00e6e463          	bltu	a3,a4,7b4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	fee7eae3          	bltu	a5,a4,7a4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b4:	ff852583          	lw	a1,-8(a0)
 7b8:	6390                	ld	a2,0(a5)
 7ba:	02059813          	slli	a6,a1,0x20
 7be:	01c85713          	srli	a4,a6,0x1c
 7c2:	9736                	add	a4,a4,a3
 7c4:	fae60de3          	beq	a2,a4,77e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7cc:	4790                	lw	a2,8(a5)
 7ce:	02061593          	slli	a1,a2,0x20
 7d2:	01c5d713          	srli	a4,a1,0x1c
 7d6:	973e                	add	a4,a4,a5
 7d8:	fae68ae3          	beq	a3,a4,78c <free+0x22>
    p->s.ptr = bp->s.ptr;
 7dc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7de:	00001717          	auipc	a4,0x1
 7e2:	82f73123          	sd	a5,-2014(a4) # 1000 <freep>
}
 7e6:	6422                	ld	s0,8(sp)
 7e8:	0141                	addi	sp,sp,16
 7ea:	8082                	ret

00000000000007ec <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ec:	7139                	addi	sp,sp,-64
 7ee:	fc06                	sd	ra,56(sp)
 7f0:	f822                	sd	s0,48(sp)
 7f2:	f426                	sd	s1,40(sp)
 7f4:	ec4e                	sd	s3,24(sp)
 7f6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f8:	02051493          	slli	s1,a0,0x20
 7fc:	9081                	srli	s1,s1,0x20
 7fe:	04bd                	addi	s1,s1,15
 800:	8091                	srli	s1,s1,0x4
 802:	0014899b          	addiw	s3,s1,1
 806:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 808:	00000517          	auipc	a0,0x0
 80c:	7f853503          	ld	a0,2040(a0) # 1000 <freep>
 810:	c915                	beqz	a0,844 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 812:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 814:	4798                	lw	a4,8(a5)
 816:	08977a63          	bgeu	a4,s1,8aa <malloc+0xbe>
 81a:	f04a                	sd	s2,32(sp)
 81c:	e852                	sd	s4,16(sp)
 81e:	e456                	sd	s5,8(sp)
 820:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 822:	8a4e                	mv	s4,s3
 824:	0009871b          	sext.w	a4,s3
 828:	6685                	lui	a3,0x1
 82a:	00d77363          	bgeu	a4,a3,830 <malloc+0x44>
 82e:	6a05                	lui	s4,0x1
 830:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 834:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 838:	00000917          	auipc	s2,0x0
 83c:	7c890913          	addi	s2,s2,1992 # 1000 <freep>
  if(p == SBRK_ERROR)
 840:	5afd                	li	s5,-1
 842:	a081                	j	882 <malloc+0x96>
 844:	f04a                	sd	s2,32(sp)
 846:	e852                	sd	s4,16(sp)
 848:	e456                	sd	s5,8(sp)
 84a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 84c:	00000797          	auipc	a5,0x0
 850:	7c478793          	addi	a5,a5,1988 # 1010 <base>
 854:	00000717          	auipc	a4,0x0
 858:	7af73623          	sd	a5,1964(a4) # 1000 <freep>
 85c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 862:	b7c1                	j	822 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 864:	6398                	ld	a4,0(a5)
 866:	e118                	sd	a4,0(a0)
 868:	a8a9                	j	8c2 <malloc+0xd6>
  hp->s.size = nu;
 86a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86e:	0541                	addi	a0,a0,16
 870:	efbff0ef          	jal	76a <free>
  return freep;
 874:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 878:	c12d                	beqz	a0,8da <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87c:	4798                	lw	a4,8(a5)
 87e:	02977263          	bgeu	a4,s1,8a2 <malloc+0xb6>
    if(p == freep)
 882:	00093703          	ld	a4,0(s2)
 886:	853e                	mv	a0,a5
 888:	fef719e3          	bne	a4,a5,87a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 88c:	8552                	mv	a0,s4
 88e:	a23ff0ef          	jal	2b0 <sbrk>
  if(p == SBRK_ERROR)
 892:	fd551ce3          	bne	a0,s5,86a <malloc+0x7e>
        return 0;
 896:	4501                	li	a0,0
 898:	7902                	ld	s2,32(sp)
 89a:	6a42                	ld	s4,16(sp)
 89c:	6aa2                	ld	s5,8(sp)
 89e:	6b02                	ld	s6,0(sp)
 8a0:	a03d                	j	8ce <malloc+0xe2>
 8a2:	7902                	ld	s2,32(sp)
 8a4:	6a42                	ld	s4,16(sp)
 8a6:	6aa2                	ld	s5,8(sp)
 8a8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8aa:	fae48de3          	beq	s1,a4,864 <malloc+0x78>
        p->s.size -= nunits;
 8ae:	4137073b          	subw	a4,a4,s3
 8b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b4:	02071693          	slli	a3,a4,0x20
 8b8:	01c6d713          	srli	a4,a3,0x1c
 8bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c2:	00000717          	auipc	a4,0x0
 8c6:	72a73f23          	sd	a0,1854(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ca:	01078513          	addi	a0,a5,16
  }
}
 8ce:	70e2                	ld	ra,56(sp)
 8d0:	7442                	ld	s0,48(sp)
 8d2:	74a2                	ld	s1,40(sp)
 8d4:	69e2                	ld	s3,24(sp)
 8d6:	6121                	addi	sp,sp,64
 8d8:	8082                	ret
 8da:	7902                	ld	s2,32(sp)
 8dc:	6a42                	ld	s4,16(sp)
 8de:	6aa2                	ld	s5,8(sp)
 8e0:	6b02                	ld	s6,0(sp)
 8e2:	b7f5                	j	8ce <malloc+0xe2>
