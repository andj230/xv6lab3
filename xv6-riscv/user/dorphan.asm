
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	91450513          	addi	a0,a0,-1772 # 920 <malloc+0xf8>
  14:	394000ef          	jal	3a8 <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	90c50513          	addi	a0,a0,-1780 # 928 <malloc+0x100>
  24:	750000ef          	jal	774 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	316000ef          	jal	340 <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	8f250513          	addi	a0,a0,-1806 # 920 <malloc+0xf8>
  36:	37a000ef          	jal	3b0 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	90250513          	addi	a0,a0,-1790 # 940 <malloc+0x118>
  46:	72e000ef          	jal	774 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2f4000ef          	jal	340 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	90850513          	addi	a0,a0,-1784 # 958 <malloc+0x130>
  58:	338000ef          	jal	390 <unlink>
  5c:	00054d63          	bltz	a0,76 <main+0x76>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	91850513          	addi	a0,a0,-1768 # 978 <malloc+0x150>
  68:	70c000ef          	jal	774 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800513          	li	a0,1000
  70:	360000ef          	jal	3d0 <pause>
  74:	bfe5                	j	6c <main+0x6c>
    printf("%s: unlink failed\n", s);
  76:	85a6                	mv	a1,s1
  78:	00001517          	auipc	a0,0x1
  7c:	8e850513          	addi	a0,a0,-1816 # 960 <malloc+0x138>
  80:	6f4000ef          	jal	774 <printf>
    exit(1);
  84:	4505                	li	a0,1
  86:	2ba000ef          	jal	340 <exit>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  extern int main();
  main();
  92:	f6fff0ef          	jal	0 <main>
  exit(0);
  96:	4501                	li	a0,0
  98:	2a8000ef          	jal	340 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a2:	87aa                	mv	a5,a0
  a4:	0585                	addi	a1,a1,1
  a6:	0785                	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fb75                	bnez	a4,a4 <strcpy+0x8>
    ;
  return os;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x1e>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x1e>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x10>
  fe:	40a6853b          	subw	a0,a3,a0
 102:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1c>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x12>
  }
  return dst;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb99                	beqz	a5,150 <strchr+0x20>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1a>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xc>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  return 0;
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strchr+0x1a>

0000000000000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	711d                	addi	sp,sp,-96
 156:	ec86                	sd	ra,88(sp)
 158:	e8a2                	sd	s0,80(sp)
 15a:	e4a6                	sd	s1,72(sp)
 15c:	e0ca                	sd	s2,64(sp)
 15e:	fc4e                	sd	s3,56(sp)
 160:	f852                	sd	s4,48(sp)
 162:	f456                	sd	s5,40(sp)
 164:	f05a                	sd	s6,32(sp)
 166:	ec5e                	sd	s7,24(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4aa9                	li	s5,10
 174:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	2485                	addiw	s1,s1,1
 17a:	0344d663          	bge	s1,s4,1a6 <gets+0x52>
    cc = read(0, &c, 1);
 17e:	4605                	li	a2,1
 180:	faf40593          	addi	a1,s0,-81
 184:	4501                	li	a0,0
 186:	1d2000ef          	jal	358 <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x52>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x50>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679de3          	bne	a5,s6,176 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x52>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	1ae000ef          	jal	380 <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	1b8000ef          	jal	398 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	180000ef          	jal	368 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fef71ae3          	bne	a4,a5,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addiw	a3,a2,-1
 2aa:	1682                	slli	a3,a3,0x20
 2ac:	9281                	srli	a3,a3,0x20
 2ae:	0685                	addi	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrk>:

char *
sbrk(int n) {
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f4:	4585                	li	a1,1
 2f6:	0d2000ef          	jal	3c8 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrklazy>:

char *
sbrklazy(int n) {
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30a:	4589                	li	a1,2
 30c:	0bc000ef          	jal	3c8 <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 318:	48e5                	li	a7,25
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 320:	48e1                	li	a7,24
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 328:	48dd                	li	a7,23
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <trace>:
.global trace
trace:
 li a7, SYS_trace
 330:	48d9                	li	a7,22
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <fork>:
.global fork
fork:
 li a7, SYS_fork
 338:	4885                	li	a7,1
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <exit>:
.global exit
exit:
 li a7, SYS_exit
 340:	4889                	li	a7,2
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <wait>:
.global wait
wait:
 li a7, SYS_wait
 348:	488d                	li	a7,3
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 350:	4891                	li	a7,4
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <read>:
.global read
read:
 li a7, SYS_read
 358:	4895                	li	a7,5
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <write>:
.global write
write:
 li a7, SYS_write
 360:	48c1                	li	a7,16
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <close>:
.global close
close:
 li a7, SYS_close
 368:	48d5                	li	a7,21
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <kill>:
.global kill
kill:
 li a7, SYS_kill
 370:	4899                	li	a7,6
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <exec>:
.global exec
exec:
 li a7, SYS_exec
 378:	489d                	li	a7,7
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <open>:
.global open
open:
 li a7, SYS_open
 380:	48bd                	li	a7,15
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 388:	48c5                	li	a7,17
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 390:	48c9                	li	a7,18
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 398:	48a1                	li	a7,8
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <link>:
.global link
link:
 li a7, SYS_link
 3a0:	48cd                	li	a7,19
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a8:	48d1                	li	a7,20
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b0:	48a5                	li	a7,9
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b8:	48a9                	li	a7,10
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c0:	48ad                	li	a7,11
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3c8:	48b1                	li	a7,12
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3d0:	48b5                	li	a7,13
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d8:	48b9                	li	a7,14
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	addi	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	addi	a1,s0,-17
 3f2:	f6fff0ef          	jal	360 <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	addi	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3fe:	715d                	addi	sp,sp,-80
 400:	e486                	sd	ra,72(sp)
 402:	e0a2                	sd	s0,64(sp)
 404:	fc26                	sd	s1,56(sp)
 406:	0880                	addi	s0,sp,80
 408:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40a:	c299                	beqz	a3,410 <printint+0x12>
 40c:	0805c963          	bltz	a1,49e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 410:	2581                	sext.w	a1,a1
  neg = 0;
 412:	4881                	li	a7,0
 414:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 418:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41a:	2601                	sext.w	a2,a2
 41c:	00000517          	auipc	a0,0x0
 420:	58450513          	addi	a0,a0,1412 # 9a0 <digits>
 424:	883a                	mv	a6,a4
 426:	2705                	addiw	a4,a4,1
 428:	02c5f7bb          	remuw	a5,a1,a2
 42c:	1782                	slli	a5,a5,0x20
 42e:	9381                	srli	a5,a5,0x20
 430:	97aa                	add	a5,a5,a0
 432:	0007c783          	lbu	a5,0(a5)
 436:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43a:	0005879b          	sext.w	a5,a1
 43e:	02c5d5bb          	divuw	a1,a1,a2
 442:	0685                	addi	a3,a3,1
 444:	fec7f0e3          	bgeu	a5,a2,424 <printint+0x26>
  if(neg)
 448:	00088c63          	beqz	a7,460 <printint+0x62>
    buf[i++] = '-';
 44c:	fd070793          	addi	a5,a4,-48
 450:	00878733          	add	a4,a5,s0
 454:	02d00793          	li	a5,45
 458:	fef70423          	sb	a5,-24(a4)
 45c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 460:	02e05a63          	blez	a4,494 <printint+0x96>
 464:	f84a                	sd	s2,48(sp)
 466:	f44e                	sd	s3,40(sp)
 468:	fb840793          	addi	a5,s0,-72
 46c:	00e78933          	add	s2,a5,a4
 470:	fff78993          	addi	s3,a5,-1
 474:	99ba                	add	s3,s3,a4
 476:	377d                	addiw	a4,a4,-1
 478:	1702                	slli	a4,a4,0x20
 47a:	9301                	srli	a4,a4,0x20
 47c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 480:	fff94583          	lbu	a1,-1(s2)
 484:	8526                	mv	a0,s1
 486:	f5bff0ef          	jal	3e0 <putc>
  while(--i >= 0)
 48a:	197d                	addi	s2,s2,-1
 48c:	ff391ae3          	bne	s2,s3,480 <printint+0x82>
 490:	7942                	ld	s2,48(sp)
 492:	79a2                	ld	s3,40(sp)
}
 494:	60a6                	ld	ra,72(sp)
 496:	6406                	ld	s0,64(sp)
 498:	74e2                	ld	s1,56(sp)
 49a:	6161                	addi	sp,sp,80
 49c:	8082                	ret
    x = -xx;
 49e:	40b005bb          	negw	a1,a1
    neg = 1;
 4a2:	4885                	li	a7,1
    x = -xx;
 4a4:	bf85                	j	414 <printint+0x16>

00000000000004a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a6:	711d                	addi	sp,sp,-96
 4a8:	ec86                	sd	ra,88(sp)
 4aa:	e8a2                	sd	s0,80(sp)
 4ac:	e0ca                	sd	s2,64(sp)
 4ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b0:	0005c903          	lbu	s2,0(a1)
 4b4:	28090663          	beqz	s2,740 <vprintf+0x29a>
 4b8:	e4a6                	sd	s1,72(sp)
 4ba:	fc4e                	sd	s3,56(sp)
 4bc:	f852                	sd	s4,48(sp)
 4be:	f456                	sd	s5,40(sp)
 4c0:	f05a                	sd	s6,32(sp)
 4c2:	ec5e                	sd	s7,24(sp)
 4c4:	e862                	sd	s8,16(sp)
 4c6:	e466                	sd	s9,8(sp)
 4c8:	8b2a                	mv	s6,a0
 4ca:	8a2e                	mv	s4,a1
 4cc:	8bb2                	mv	s7,a2
  state = 0;
 4ce:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d0:	4481                	li	s1,0
 4d2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4d4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4d8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4dc:	06c00c93          	li	s9,108
 4e0:	a005                	j	500 <vprintf+0x5a>
        putc(fd, c0);
 4e2:	85ca                	mv	a1,s2
 4e4:	855a                	mv	a0,s6
 4e6:	efbff0ef          	jal	3e0 <putc>
 4ea:	a019                	j	4f0 <vprintf+0x4a>
    } else if(state == '%'){
 4ec:	03598263          	beq	s3,s5,510 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4f0:	2485                	addiw	s1,s1,1
 4f2:	8726                	mv	a4,s1
 4f4:	009a07b3          	add	a5,s4,s1
 4f8:	0007c903          	lbu	s2,0(a5)
 4fc:	22090a63          	beqz	s2,730 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 500:	0009079b          	sext.w	a5,s2
    if(state == 0){
 504:	fe0994e3          	bnez	s3,4ec <vprintf+0x46>
      if(c0 == '%'){
 508:	fd579de3          	bne	a5,s5,4e2 <vprintf+0x3c>
        state = '%';
 50c:	89be                	mv	s3,a5
 50e:	b7cd                	j	4f0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 510:	00ea06b3          	add	a3,s4,a4
 514:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 518:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 51a:	c681                	beqz	a3,522 <vprintf+0x7c>
 51c:	9752                	add	a4,a4,s4
 51e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 522:	05878363          	beq	a5,s8,568 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 526:	05978d63          	beq	a5,s9,580 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 52a:	07500713          	li	a4,117
 52e:	0ee78763          	beq	a5,a4,61c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 532:	07800713          	li	a4,120
 536:	12e78963          	beq	a5,a4,668 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 53a:	07000713          	li	a4,112
 53e:	14e78e63          	beq	a5,a4,69a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 542:	06300713          	li	a4,99
 546:	18e78e63          	beq	a5,a4,6e2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 54a:	07300713          	li	a4,115
 54e:	1ae78463          	beq	a5,a4,6f6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 552:	02500713          	li	a4,37
 556:	04e79563          	bne	a5,a4,5a0 <vprintf+0xfa>
        putc(fd, '%');
 55a:	02500593          	li	a1,37
 55e:	855a                	mv	a0,s6
 560:	e81ff0ef          	jal	3e0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 564:	4981                	li	s3,0
 566:	b769                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 568:	008b8913          	addi	s2,s7,8
 56c:	4685                	li	a3,1
 56e:	4629                	li	a2,10
 570:	000ba583          	lw	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e89ff0ef          	jal	3fe <printint>
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
 57e:	bf8d                	j	4f0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 580:	06400793          	li	a5,100
 584:	02f68963          	beq	a3,a5,5b6 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 588:	06c00793          	li	a5,108
 58c:	04f68263          	beq	a3,a5,5d0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 590:	07500793          	li	a5,117
 594:	0af68063          	beq	a3,a5,634 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 598:	07800793          	li	a5,120
 59c:	0ef68263          	beq	a3,a5,680 <vprintf+0x1da>
        putc(fd, '%');
 5a0:	02500593          	li	a1,37
 5a4:	855a                	mv	a0,s6
 5a6:	e3bff0ef          	jal	3e0 <putc>
        putc(fd, c0);
 5aa:	85ca                	mv	a1,s2
 5ac:	855a                	mv	a0,s6
 5ae:	e33ff0ef          	jal	3e0 <putc>
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	bf35                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	008b8913          	addi	s2,s7,8
 5ba:	4685                	li	a3,1
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e3bff0ef          	jal	3fe <printint>
        i += 1;
 5c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
        i += 1;
 5ce:	b70d                	j	4f0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d0:	06400793          	li	a5,100
 5d4:	02f60763          	beq	a2,a5,602 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d8:	07500793          	li	a5,117
 5dc:	06f60963          	beq	a2,a5,64e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5e0:	07800793          	li	a5,120
 5e4:	faf61ee3          	bne	a2,a5,5a0 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e09ff0ef          	jal	3fe <printint>
        i += 2;
 5fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	bdc5                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 602:	008b8913          	addi	s2,s7,8
 606:	4685                	li	a3,1
 608:	4629                	li	a2,10
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	defff0ef          	jal	3fe <printint>
        i += 2;
 614:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 616:	8bca                	mv	s7,s2
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	bdd9                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 61c:	008b8913          	addi	s2,s7,8
 620:	4681                	li	a3,0
 622:	4629                	li	a2,10
 624:	000be583          	lwu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	dd5ff0ef          	jal	3fe <printint>
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
 632:	bd7d                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000bb583          	ld	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	dbdff0ef          	jal	3fe <printint>
        i += 1;
 646:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 1;
 64c:	b555                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64e:	008b8913          	addi	s2,s7,8
 652:	4681                	li	a3,0
 654:	4629                	li	a2,10
 656:	000bb583          	ld	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	da3ff0ef          	jal	3fe <printint>
        i += 2;
 660:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
        i += 2;
 666:	b569                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000be583          	lwu	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	d89ff0ef          	jal	3fe <printint>
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
 67e:	bd8d                	j	4f0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	008b8913          	addi	s2,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000bb583          	ld	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d71ff0ef          	jal	3fe <printint>
        i += 1;
 692:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
        i += 1;
 698:	bda1                	j	4f0 <vprintf+0x4a>
 69a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 69c:	008b8d13          	addi	s10,s7,8
 6a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a4:	03000593          	li	a1,48
 6a8:	855a                	mv	a0,s6
 6aa:	d37ff0ef          	jal	3e0 <putc>
  putc(fd, 'x');
 6ae:	07800593          	li	a1,120
 6b2:	855a                	mv	a0,s6
 6b4:	d2dff0ef          	jal	3e0 <putc>
 6b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ba:	00000b97          	auipc	s7,0x0
 6be:	2e6b8b93          	addi	s7,s7,742 # 9a0 <digits>
 6c2:	03c9d793          	srli	a5,s3,0x3c
 6c6:	97de                	add	a5,a5,s7
 6c8:	0007c583          	lbu	a1,0(a5)
 6cc:	855a                	mv	a0,s6
 6ce:	d13ff0ef          	jal	3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6d2:	0992                	slli	s3,s3,0x4
 6d4:	397d                	addiw	s2,s2,-1
 6d6:	fe0916e3          	bnez	s2,6c2 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6da:	8bea                	mv	s7,s10
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	6d02                	ld	s10,0(sp)
 6e0:	bd01                	j	4f0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6e2:	008b8913          	addi	s2,s7,8
 6e6:	000bc583          	lbu	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	cf5ff0ef          	jal	3e0 <putc>
 6f0:	8bca                	mv	s7,s2
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bbf5                	j	4f0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6f6:	008b8993          	addi	s3,s7,8
 6fa:	000bb903          	ld	s2,0(s7)
 6fe:	00090f63          	beqz	s2,71c <vprintf+0x276>
        for(; *s; s++)
 702:	00094583          	lbu	a1,0(s2)
 706:	c195                	beqz	a1,72a <vprintf+0x284>
          putc(fd, *s);
 708:	855a                	mv	a0,s6
 70a:	cd7ff0ef          	jal	3e0 <putc>
        for(; *s; s++)
 70e:	0905                	addi	s2,s2,1
 710:	00094583          	lbu	a1,0(s2)
 714:	f9f5                	bnez	a1,708 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 716:	8bce                	mv	s7,s3
      state = 0;
 718:	4981                	li	s3,0
 71a:	bbd9                	j	4f0 <vprintf+0x4a>
          s = "(null)";
 71c:	00000917          	auipc	s2,0x0
 720:	27c90913          	addi	s2,s2,636 # 998 <malloc+0x170>
        for(; *s; s++)
 724:	02800593          	li	a1,40
 728:	b7c5                	j	708 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 72a:	8bce                	mv	s7,s3
      state = 0;
 72c:	4981                	li	s3,0
 72e:	b3c9                	j	4f0 <vprintf+0x4a>
 730:	64a6                	ld	s1,72(sp)
 732:	79e2                	ld	s3,56(sp)
 734:	7a42                	ld	s4,48(sp)
 736:	7aa2                	ld	s5,40(sp)
 738:	7b02                	ld	s6,32(sp)
 73a:	6be2                	ld	s7,24(sp)
 73c:	6c42                	ld	s8,16(sp)
 73e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 740:	60e6                	ld	ra,88(sp)
 742:	6446                	ld	s0,80(sp)
 744:	6906                	ld	s2,64(sp)
 746:	6125                	addi	sp,sp,96
 748:	8082                	ret

000000000000074a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74a:	715d                	addi	sp,sp,-80
 74c:	ec06                	sd	ra,24(sp)
 74e:	e822                	sd	s0,16(sp)
 750:	1000                	addi	s0,sp,32
 752:	e010                	sd	a2,0(s0)
 754:	e414                	sd	a3,8(s0)
 756:	e818                	sd	a4,16(s0)
 758:	ec1c                	sd	a5,24(s0)
 75a:	03043023          	sd	a6,32(s0)
 75e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 762:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 766:	8622                	mv	a2,s0
 768:	d3fff0ef          	jal	4a6 <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6161                	addi	sp,sp,80
 772:	8082                	ret

0000000000000774 <printf>:

void
printf(const char *fmt, ...)
{
 774:	711d                	addi	sp,sp,-96
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e40c                	sd	a1,8(s0)
 77e:	e810                	sd	a2,16(s0)
 780:	ec14                	sd	a3,24(s0)
 782:	f018                	sd	a4,32(s0)
 784:	f41c                	sd	a5,40(s0)
 786:	03043823          	sd	a6,48(s0)
 78a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	00840613          	addi	a2,s0,8
 792:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 796:	85aa                	mv	a1,a0
 798:	4505                	li	a0,1
 79a:	d0dff0ef          	jal	4a6 <vprintf>
}
 79e:	60e2                	ld	ra,24(sp)
 7a0:	6442                	ld	s0,16(sp)
 7a2:	6125                	addi	sp,sp,96
 7a4:	8082                	ret

00000000000007a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a6:	1141                	addi	sp,sp,-16
 7a8:	e422                	sd	s0,8(sp)
 7aa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ac:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b0:	00001797          	auipc	a5,0x1
 7b4:	8507b783          	ld	a5,-1968(a5) # 1000 <freep>
 7b8:	a02d                	j	7e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7ba:	4618                	lw	a4,8(a2)
 7bc:	9f2d                	addw	a4,a4,a1
 7be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c2:	6398                	ld	a4,0(a5)
 7c4:	6310                	ld	a2,0(a4)
 7c6:	a83d                	j	804 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7c8:	ff852703          	lw	a4,-8(a0)
 7cc:	9f31                	addw	a4,a4,a2
 7ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7d0:	ff053683          	ld	a3,-16(a0)
 7d4:	a091                	j	818 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e7e463          	bltu	a5,a4,7e0 <free+0x3a>
 7dc:	00e6ea63          	bltu	a3,a4,7f0 <free+0x4a>
{
 7e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e2:	fed7fae3          	bgeu	a5,a3,7d6 <free+0x30>
 7e6:	6398                	ld	a4,0(a5)
 7e8:	00e6e463          	bltu	a3,a4,7f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ec:	fee7eae3          	bltu	a5,a4,7e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7f0:	ff852583          	lw	a1,-8(a0)
 7f4:	6390                	ld	a2,0(a5)
 7f6:	02059813          	slli	a6,a1,0x20
 7fa:	01c85713          	srli	a4,a6,0x1c
 7fe:	9736                	add	a4,a4,a3
 800:	fae60de3          	beq	a2,a4,7ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 804:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 808:	4790                	lw	a2,8(a5)
 80a:	02061593          	slli	a1,a2,0x20
 80e:	01c5d713          	srli	a4,a1,0x1c
 812:	973e                	add	a4,a4,a5
 814:	fae68ae3          	beq	a3,a4,7c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 818:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 81a:	00000717          	auipc	a4,0x0
 81e:	7ef73323          	sd	a5,2022(a4) # 1000 <freep>
}
 822:	6422                	ld	s0,8(sp)
 824:	0141                	addi	sp,sp,16
 826:	8082                	ret

0000000000000828 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 828:	7139                	addi	sp,sp,-64
 82a:	fc06                	sd	ra,56(sp)
 82c:	f822                	sd	s0,48(sp)
 82e:	f426                	sd	s1,40(sp)
 830:	ec4e                	sd	s3,24(sp)
 832:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 834:	02051493          	slli	s1,a0,0x20
 838:	9081                	srli	s1,s1,0x20
 83a:	04bd                	addi	s1,s1,15
 83c:	8091                	srli	s1,s1,0x4
 83e:	0014899b          	addiw	s3,s1,1
 842:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 844:	00000517          	auipc	a0,0x0
 848:	7bc53503          	ld	a0,1980(a0) # 1000 <freep>
 84c:	c915                	beqz	a0,880 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 850:	4798                	lw	a4,8(a5)
 852:	08977a63          	bgeu	a4,s1,8e6 <malloc+0xbe>
 856:	f04a                	sd	s2,32(sp)
 858:	e852                	sd	s4,16(sp)
 85a:	e456                	sd	s5,8(sp)
 85c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 85e:	8a4e                	mv	s4,s3
 860:	0009871b          	sext.w	a4,s3
 864:	6685                	lui	a3,0x1
 866:	00d77363          	bgeu	a4,a3,86c <malloc+0x44>
 86a:	6a05                	lui	s4,0x1
 86c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 870:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 874:	00000917          	auipc	s2,0x0
 878:	78c90913          	addi	s2,s2,1932 # 1000 <freep>
  if(p == SBRK_ERROR)
 87c:	5afd                	li	s5,-1
 87e:	a081                	j	8be <malloc+0x96>
 880:	f04a                	sd	s2,32(sp)
 882:	e852                	sd	s4,16(sp)
 884:	e456                	sd	s5,8(sp)
 886:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 888:	00001797          	auipc	a5,0x1
 88c:	98078793          	addi	a5,a5,-1664 # 1208 <base>
 890:	00000717          	auipc	a4,0x0
 894:	76f73823          	sd	a5,1904(a4) # 1000 <freep>
 898:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 89e:	b7c1                	j	85e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8a0:	6398                	ld	a4,0(a5)
 8a2:	e118                	sd	a4,0(a0)
 8a4:	a8a9                	j	8fe <malloc+0xd6>
  hp->s.size = nu;
 8a6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8aa:	0541                	addi	a0,a0,16
 8ac:	efbff0ef          	jal	7a6 <free>
  return freep;
 8b0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8b4:	c12d                	beqz	a0,916 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b8:	4798                	lw	a4,8(a5)
 8ba:	02977263          	bgeu	a4,s1,8de <malloc+0xb6>
    if(p == freep)
 8be:	00093703          	ld	a4,0(s2)
 8c2:	853e                	mv	a0,a5
 8c4:	fef719e3          	bne	a4,a5,8b6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8c8:	8552                	mv	a0,s4
 8ca:	a23ff0ef          	jal	2ec <sbrk>
  if(p == SBRK_ERROR)
 8ce:	fd551ce3          	bne	a0,s5,8a6 <malloc+0x7e>
        return 0;
 8d2:	4501                	li	a0,0
 8d4:	7902                	ld	s2,32(sp)
 8d6:	6a42                	ld	s4,16(sp)
 8d8:	6aa2                	ld	s5,8(sp)
 8da:	6b02                	ld	s6,0(sp)
 8dc:	a03d                	j	90a <malloc+0xe2>
 8de:	7902                	ld	s2,32(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8e6:	fae48de3          	beq	s1,a4,8a0 <malloc+0x78>
        p->s.size -= nunits;
 8ea:	4137073b          	subw	a4,a4,s3
 8ee:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f0:	02071693          	slli	a3,a4,0x20
 8f4:	01c6d713          	srli	a4,a3,0x1c
 8f8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8fa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8fe:	00000717          	auipc	a4,0x0
 902:	70a73123          	sd	a0,1794(a4) # 1000 <freep>
      return (void*)(p + 1);
 906:	01078513          	addi	a0,a5,16
  }
}
 90a:	70e2                	ld	ra,56(sp)
 90c:	7442                	ld	s0,48(sp)
 90e:	74a2                	ld	s1,40(sp)
 910:	69e2                	ld	s3,24(sp)
 912:	6121                	addi	sp,sp,64
 914:	8082                	ret
 916:	7902                	ld	s2,32(sp)
 918:	6a42                	ld	s4,16(sp)
 91a:	6aa2                	ld	s5,8(sp)
 91c:	6b02                	ld	s6,0(sp)
 91e:	b7f5                	j	90a <malloc+0xe2>
