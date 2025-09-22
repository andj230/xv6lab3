
user/_rm:     file format elf64-littleriscv


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
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d763          	bge	a5,a0,38 <main+0x38>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	344000ef          	jal	36c <unlink>
  2c:	02054263          	bltz	a0,50 <main+0x50>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a02d                	j	60 <main+0x60>
  38:	e426                	sd	s1,8(sp)
  3a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	8c458593          	addi	a1,a1,-1852 # 900 <malloc+0xfc>
  44:	4509                	li	a0,2
  46:	6e0000ef          	jal	726 <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2d0000ef          	jal	31c <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  50:	6090                	ld	a2,0(s1)
  52:	00001597          	auipc	a1,0x1
  56:	8c658593          	addi	a1,a1,-1850 # 918 <malloc+0x114>
  5a:	4509                	li	a0,2
  5c:	6ca000ef          	jal	726 <fprintf>
      break;
    }
  }

  exit(0);
  60:	4501                	li	a0,0
  62:	2ba000ef          	jal	31c <exit>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	2a8000ef          	jal	31c <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	86be                	mv	a3,a5
  d2:	0785                	addi	a5,a5,1
  d4:	fff7c703          	lbu	a4,-1(a5)
  d8:	ff65                	bnez	a4,d0 <strlen+0x10>
  da:	40a6853b          	subw	a0,a3,a0
  de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d663          	bge	s1,s4,182 <gets+0x52>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	1d2000ef          	jal	334 <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x52>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x50>
 176:	0905                	addi	s2,s2,1
 178:	fd679de3          	bne	a5,s6,152 <gets+0x22>
    buf[i++] = c;
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x52>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e04a                	sd	s2,0(sp)
 1a8:	1000                	addi	s0,sp,32
 1aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ac:	4581                	li	a1,0
 1ae:	1ae000ef          	jal	35c <open>
  if(fd < 0)
 1b2:	02054263          	bltz	a0,1d6 <stat+0x36>
 1b6:	e426                	sd	s1,8(sp)
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	1b8000ef          	jal	374 <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	180000ef          	jal	344 <close>
  return r;
 1c8:	64a2                	ld	s1,8(sp)
}
 1ca:	854a                	mv	a0,s2
 1cc:	60e2                	ld	ra,24(sp)
 1ce:	6442                	ld	s0,16(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfcd                	j	1ca <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054683          	lbu	a3,0(a0)
 1e4:	fd06879b          	addiw	a5,a3,-48
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	4625                	li	a2,9
 1ee:	02f66863          	bltu	a2,a5,21e <atoi+0x44>
 1f2:	872a                	mv	a4,a0
  n = 0;
 1f4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f6:	0705                	addi	a4,a4,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb5                	addw	a5,a5,a3
 204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 208:	00074683          	lbu	a3,0(a4)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	fef671e3          	bgeu	a2,a5,1f6 <atoi+0x1c>
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x3e>

0000000000000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 228:	02b57463          	bgeu	a0,a1,250 <memmove+0x2e>
    while(n-- > 0)
 22c:	00c05f63          	blez	a2,24a <memmove+0x28>
 230:	1602                	slli	a2,a2,0x20
 232:	9201                	srli	a2,a2,0x20
 234:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 238:	872a                	mv	a4,a0
      *dst++ = *src++;
 23a:	0585                	addi	a1,a1,1
 23c:	0705                	addi	a4,a4,1
 23e:	fff5c683          	lbu	a3,-1(a1)
 242:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 246:	fef71ae3          	bne	a4,a5,23a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
    dst += n;
 250:	00c50733          	add	a4,a0,a2
    src += n;
 254:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 256:	fec05ae3          	blez	a2,24a <memmove+0x28>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x46>
 278:	bfc9                	j	24a <memmove+0x28>

000000000000027a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	ca05                	beqz	a2,2b0 <memcmp+0x36>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29a:	0505                	addi	a0,a0,1
    p2++;
 29c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x14>
  }
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x30>
      return *p1 - *p2;
 2a6:	40e7853b          	subw	a0,a5,a4
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <memcmp+0x30>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	f67ff0ef          	jal	222 <memmove>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <sbrk>:

char *
sbrk(int n) {
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d0:	4585                	li	a1,1
 2d2:	0d2000ef          	jal	3a4 <sys_sbrk>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <sbrklazy>:

char *
sbrklazy(int n) {
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2e6:	4589                	li	a1,2
 2e8:	0bc000ef          	jal	3a4 <sys_sbrk>
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 2f4:	48e5                	li	a7,25
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 2fc:	48e1                	li	a7,24
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 304:	48dd                	li	a7,23
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <trace>:
.global trace
trace:
 li a7, SYS_trace
 30c:	48d9                	li	a7,22
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fork>:
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3bc:	1101                	addi	sp,sp,-32
 3be:	ec06                	sd	ra,24(sp)
 3c0:	e822                	sd	s0,16(sp)
 3c2:	1000                	addi	s0,sp,32
 3c4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3c8:	4605                	li	a2,1
 3ca:	fef40593          	addi	a1,s0,-17
 3ce:	f6fff0ef          	jal	33c <write>
}
 3d2:	60e2                	ld	ra,24(sp)
 3d4:	6442                	ld	s0,16(sp)
 3d6:	6105                	addi	sp,sp,32
 3d8:	8082                	ret

00000000000003da <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3da:	715d                	addi	sp,sp,-80
 3dc:	e486                	sd	ra,72(sp)
 3de:	e0a2                	sd	s0,64(sp)
 3e0:	fc26                	sd	s1,56(sp)
 3e2:	0880                	addi	s0,sp,80
 3e4:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3e6:	c299                	beqz	a3,3ec <printint+0x12>
 3e8:	0805c963          	bltz	a1,47a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ec:	2581                	sext.w	a1,a1
  neg = 0;
 3ee:	4881                	li	a7,0
 3f0:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3f4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3f6:	2601                	sext.w	a2,a2
 3f8:	00000517          	auipc	a0,0x0
 3fc:	54850513          	addi	a0,a0,1352 # 940 <digits>
 400:	883a                	mv	a6,a4
 402:	2705                	addiw	a4,a4,1
 404:	02c5f7bb          	remuw	a5,a1,a2
 408:	1782                	slli	a5,a5,0x20
 40a:	9381                	srli	a5,a5,0x20
 40c:	97aa                	add	a5,a5,a0
 40e:	0007c783          	lbu	a5,0(a5)
 412:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 416:	0005879b          	sext.w	a5,a1
 41a:	02c5d5bb          	divuw	a1,a1,a2
 41e:	0685                	addi	a3,a3,1
 420:	fec7f0e3          	bgeu	a5,a2,400 <printint+0x26>
  if(neg)
 424:	00088c63          	beqz	a7,43c <printint+0x62>
    buf[i++] = '-';
 428:	fd070793          	addi	a5,a4,-48
 42c:	00878733          	add	a4,a5,s0
 430:	02d00793          	li	a5,45
 434:	fef70423          	sb	a5,-24(a4)
 438:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 43c:	02e05a63          	blez	a4,470 <printint+0x96>
 440:	f84a                	sd	s2,48(sp)
 442:	f44e                	sd	s3,40(sp)
 444:	fb840793          	addi	a5,s0,-72
 448:	00e78933          	add	s2,a5,a4
 44c:	fff78993          	addi	s3,a5,-1
 450:	99ba                	add	s3,s3,a4
 452:	377d                	addiw	a4,a4,-1
 454:	1702                	slli	a4,a4,0x20
 456:	9301                	srli	a4,a4,0x20
 458:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 45c:	fff94583          	lbu	a1,-1(s2)
 460:	8526                	mv	a0,s1
 462:	f5bff0ef          	jal	3bc <putc>
  while(--i >= 0)
 466:	197d                	addi	s2,s2,-1
 468:	ff391ae3          	bne	s2,s3,45c <printint+0x82>
 46c:	7942                	ld	s2,48(sp)
 46e:	79a2                	ld	s3,40(sp)
}
 470:	60a6                	ld	ra,72(sp)
 472:	6406                	ld	s0,64(sp)
 474:	74e2                	ld	s1,56(sp)
 476:	6161                	addi	sp,sp,80
 478:	8082                	ret
    x = -xx;
 47a:	40b005bb          	negw	a1,a1
    neg = 1;
 47e:	4885                	li	a7,1
    x = -xx;
 480:	bf85                	j	3f0 <printint+0x16>

0000000000000482 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 482:	711d                	addi	sp,sp,-96
 484:	ec86                	sd	ra,88(sp)
 486:	e8a2                	sd	s0,80(sp)
 488:	e0ca                	sd	s2,64(sp)
 48a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 48c:	0005c903          	lbu	s2,0(a1)
 490:	28090663          	beqz	s2,71c <vprintf+0x29a>
 494:	e4a6                	sd	s1,72(sp)
 496:	fc4e                	sd	s3,56(sp)
 498:	f852                	sd	s4,48(sp)
 49a:	f456                	sd	s5,40(sp)
 49c:	f05a                	sd	s6,32(sp)
 49e:	ec5e                	sd	s7,24(sp)
 4a0:	e862                	sd	s8,16(sp)
 4a2:	e466                	sd	s9,8(sp)
 4a4:	8b2a                	mv	s6,a0
 4a6:	8a2e                	mv	s4,a1
 4a8:	8bb2                	mv	s7,a2
  state = 0;
 4aa:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ac:	4481                	li	s1,0
 4ae:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4b0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4b4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4b8:	06c00c93          	li	s9,108
 4bc:	a005                	j	4dc <vprintf+0x5a>
        putc(fd, c0);
 4be:	85ca                	mv	a1,s2
 4c0:	855a                	mv	a0,s6
 4c2:	efbff0ef          	jal	3bc <putc>
 4c6:	a019                	j	4cc <vprintf+0x4a>
    } else if(state == '%'){
 4c8:	03598263          	beq	s3,s5,4ec <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4cc:	2485                	addiw	s1,s1,1
 4ce:	8726                	mv	a4,s1
 4d0:	009a07b3          	add	a5,s4,s1
 4d4:	0007c903          	lbu	s2,0(a5)
 4d8:	22090a63          	beqz	s2,70c <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4dc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4e0:	fe0994e3          	bnez	s3,4c8 <vprintf+0x46>
      if(c0 == '%'){
 4e4:	fd579de3          	bne	a5,s5,4be <vprintf+0x3c>
        state = '%';
 4e8:	89be                	mv	s3,a5
 4ea:	b7cd                	j	4cc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4ec:	00ea06b3          	add	a3,s4,a4
 4f0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4f4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4f6:	c681                	beqz	a3,4fe <vprintf+0x7c>
 4f8:	9752                	add	a4,a4,s4
 4fa:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4fe:	05878363          	beq	a5,s8,544 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 502:	05978d63          	beq	a5,s9,55c <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 506:	07500713          	li	a4,117
 50a:	0ee78763          	beq	a5,a4,5f8 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 50e:	07800713          	li	a4,120
 512:	12e78963          	beq	a5,a4,644 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 516:	07000713          	li	a4,112
 51a:	14e78e63          	beq	a5,a4,676 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 51e:	06300713          	li	a4,99
 522:	18e78e63          	beq	a5,a4,6be <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 526:	07300713          	li	a4,115
 52a:	1ae78463          	beq	a5,a4,6d2 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 52e:	02500713          	li	a4,37
 532:	04e79563          	bne	a5,a4,57c <vprintf+0xfa>
        putc(fd, '%');
 536:	02500593          	li	a1,37
 53a:	855a                	mv	a0,s6
 53c:	e81ff0ef          	jal	3bc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 540:	4981                	li	s3,0
 542:	b769                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 544:	008b8913          	addi	s2,s7,8
 548:	4685                	li	a3,1
 54a:	4629                	li	a2,10
 54c:	000ba583          	lw	a1,0(s7)
 550:	855a                	mv	a0,s6
 552:	e89ff0ef          	jal	3da <printint>
 556:	8bca                	mv	s7,s2
      state = 0;
 558:	4981                	li	s3,0
 55a:	bf8d                	j	4cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	06400793          	li	a5,100
 560:	02f68963          	beq	a3,a5,592 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 564:	06c00793          	li	a5,108
 568:	04f68263          	beq	a3,a5,5ac <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 56c:	07500793          	li	a5,117
 570:	0af68063          	beq	a3,a5,610 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 574:	07800793          	li	a5,120
 578:	0ef68263          	beq	a3,a5,65c <vprintf+0x1da>
        putc(fd, '%');
 57c:	02500593          	li	a1,37
 580:	855a                	mv	a0,s6
 582:	e3bff0ef          	jal	3bc <putc>
        putc(fd, c0);
 586:	85ca                	mv	a1,s2
 588:	855a                	mv	a0,s6
 58a:	e33ff0ef          	jal	3bc <putc>
      state = 0;
 58e:	4981                	li	s3,0
 590:	bf35                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000bb583          	ld	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	e3bff0ef          	jal	3da <printint>
        i += 1;
 5a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 1;
 5aa:	b70d                	j	4cc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ac:	06400793          	li	a5,100
 5b0:	02f60763          	beq	a2,a5,5de <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5b4:	07500793          	li	a5,117
 5b8:	06f60963          	beq	a2,a5,62a <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5bc:	07800793          	li	a5,120
 5c0:	faf61ee3          	bne	a2,a5,57c <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4641                	li	a2,16
 5cc:	000bb583          	ld	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	e09ff0ef          	jal	3da <printint>
        i += 2;
 5d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 2;
 5dc:	bdc5                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	defff0ef          	jal	3da <printint>
        i += 2;
 5f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bdd9                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4629                	li	a2,10
 600:	000be583          	lwu	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	dd5ff0ef          	jal	3da <printint>
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bd7d                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4629                	li	a2,10
 618:	000bb583          	ld	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	dbdff0ef          	jal	3da <printint>
        i += 1;
 622:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b555                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	da3ff0ef          	jal	3da <printint>
        i += 2;
 63c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	b569                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 644:	008b8913          	addi	s2,s7,8
 648:	4681                	li	a3,0
 64a:	4641                	li	a2,16
 64c:	000be583          	lwu	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d89ff0ef          	jal	3da <printint>
 656:	8bca                	mv	s7,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bd8d                	j	4cc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000bb583          	ld	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	d71ff0ef          	jal	3da <printint>
        i += 1;
 66e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 1;
 674:	bda1                	j	4cc <vprintf+0x4a>
 676:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 678:	008b8d13          	addi	s10,s7,8
 67c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 680:	03000593          	li	a1,48
 684:	855a                	mv	a0,s6
 686:	d37ff0ef          	jal	3bc <putc>
  putc(fd, 'x');
 68a:	07800593          	li	a1,120
 68e:	855a                	mv	a0,s6
 690:	d2dff0ef          	jal	3bc <putc>
 694:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 696:	00000b97          	auipc	s7,0x0
 69a:	2aab8b93          	addi	s7,s7,682 # 940 <digits>
 69e:	03c9d793          	srli	a5,s3,0x3c
 6a2:	97de                	add	a5,a5,s7
 6a4:	0007c583          	lbu	a1,0(a5)
 6a8:	855a                	mv	a0,s6
 6aa:	d13ff0ef          	jal	3bc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ae:	0992                	slli	s3,s3,0x4
 6b0:	397d                	addiw	s2,s2,-1
 6b2:	fe0916e3          	bnez	s2,69e <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6b6:	8bea                	mv	s7,s10
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	6d02                	ld	s10,0(sp)
 6bc:	bd01                	j	4cc <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6be:	008b8913          	addi	s2,s7,8
 6c2:	000bc583          	lbu	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	cf5ff0ef          	jal	3bc <putc>
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bbf5                	j	4cc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6d2:	008b8993          	addi	s3,s7,8
 6d6:	000bb903          	ld	s2,0(s7)
 6da:	00090f63          	beqz	s2,6f8 <vprintf+0x276>
        for(; *s; s++)
 6de:	00094583          	lbu	a1,0(s2)
 6e2:	c195                	beqz	a1,706 <vprintf+0x284>
          putc(fd, *s);
 6e4:	855a                	mv	a0,s6
 6e6:	cd7ff0ef          	jal	3bc <putc>
        for(; *s; s++)
 6ea:	0905                	addi	s2,s2,1
 6ec:	00094583          	lbu	a1,0(s2)
 6f0:	f9f5                	bnez	a1,6e4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6f2:	8bce                	mv	s7,s3
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bbd9                	j	4cc <vprintf+0x4a>
          s = "(null)";
 6f8:	00000917          	auipc	s2,0x0
 6fc:	24090913          	addi	s2,s2,576 # 938 <malloc+0x134>
        for(; *s; s++)
 700:	02800593          	li	a1,40
 704:	b7c5                	j	6e4 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	b3c9                	j	4cc <vprintf+0x4a>
 70c:	64a6                	ld	s1,72(sp)
 70e:	79e2                	ld	s3,56(sp)
 710:	7a42                	ld	s4,48(sp)
 712:	7aa2                	ld	s5,40(sp)
 714:	7b02                	ld	s6,32(sp)
 716:	6be2                	ld	s7,24(sp)
 718:	6c42                	ld	s8,16(sp)
 71a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 71c:	60e6                	ld	ra,88(sp)
 71e:	6446                	ld	s0,80(sp)
 720:	6906                	ld	s2,64(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 742:	8622                	mv	a2,s0
 744:	d3fff0ef          	jal	482 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	addi	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	addi	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	d0dff0ef          	jal	482 <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret

0000000000000782 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 782:	1141                	addi	sp,sp,-16
 784:	e422                	sd	s0,8(sp)
 786:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 788:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	00001797          	auipc	a5,0x1
 790:	8747b783          	ld	a5,-1932(a5) # 1000 <freep>
 794:	a02d                	j	7be <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 796:	4618                	lw	a4,8(a2)
 798:	9f2d                	addw	a4,a4,a1
 79a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	6398                	ld	a4,0(a5)
 7a0:	6310                	ld	a2,0(a4)
 7a2:	a83d                	j	7e0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a4:	ff852703          	lw	a4,-8(a0)
 7a8:	9f31                	addw	a4,a4,a2
 7aa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ac:	ff053683          	ld	a3,-16(a0)
 7b0:	a091                	j	7f4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b2:	6398                	ld	a4,0(a5)
 7b4:	00e7e463          	bltu	a5,a4,7bc <free+0x3a>
 7b8:	00e6ea63          	bltu	a3,a4,7cc <free+0x4a>
{
 7bc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	fed7fae3          	bgeu	a5,a3,7b2 <free+0x30>
 7c2:	6398                	ld	a4,0(a5)
 7c4:	00e6e463          	bltu	a3,a4,7cc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	fee7eae3          	bltu	a5,a4,7bc <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7cc:	ff852583          	lw	a1,-8(a0)
 7d0:	6390                	ld	a2,0(a5)
 7d2:	02059813          	slli	a6,a1,0x20
 7d6:	01c85713          	srli	a4,a6,0x1c
 7da:	9736                	add	a4,a4,a3
 7dc:	fae60de3          	beq	a2,a4,796 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e4:	4790                	lw	a2,8(a5)
 7e6:	02061593          	slli	a1,a2,0x20
 7ea:	01c5d713          	srli	a4,a1,0x1c
 7ee:	973e                	add	a4,a4,a5
 7f0:	fae68ae3          	beq	a3,a4,7a4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7f4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f6:	00001717          	auipc	a4,0x1
 7fa:	80f73523          	sd	a5,-2038(a4) # 1000 <freep>
}
 7fe:	6422                	ld	s0,8(sp)
 800:	0141                	addi	sp,sp,16
 802:	8082                	ret

0000000000000804 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 804:	7139                	addi	sp,sp,-64
 806:	fc06                	sd	ra,56(sp)
 808:	f822                	sd	s0,48(sp)
 80a:	f426                	sd	s1,40(sp)
 80c:	ec4e                	sd	s3,24(sp)
 80e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 810:	02051493          	slli	s1,a0,0x20
 814:	9081                	srli	s1,s1,0x20
 816:	04bd                	addi	s1,s1,15
 818:	8091                	srli	s1,s1,0x4
 81a:	0014899b          	addiw	s3,s1,1
 81e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 820:	00000517          	auipc	a0,0x0
 824:	7e053503          	ld	a0,2016(a0) # 1000 <freep>
 828:	c915                	beqz	a0,85c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 82a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82c:	4798                	lw	a4,8(a5)
 82e:	08977a63          	bgeu	a4,s1,8c2 <malloc+0xbe>
 832:	f04a                	sd	s2,32(sp)
 834:	e852                	sd	s4,16(sp)
 836:	e456                	sd	s5,8(sp)
 838:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 83a:	8a4e                	mv	s4,s3
 83c:	0009871b          	sext.w	a4,s3
 840:	6685                	lui	a3,0x1
 842:	00d77363          	bgeu	a4,a3,848 <malloc+0x44>
 846:	6a05                	lui	s4,0x1
 848:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 850:	00000917          	auipc	s2,0x0
 854:	7b090913          	addi	s2,s2,1968 # 1000 <freep>
  if(p == SBRK_ERROR)
 858:	5afd                	li	s5,-1
 85a:	a081                	j	89a <malloc+0x96>
 85c:	f04a                	sd	s2,32(sp)
 85e:	e852                	sd	s4,16(sp)
 860:	e456                	sd	s5,8(sp)
 862:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 864:	00000797          	auipc	a5,0x0
 868:	7ac78793          	addi	a5,a5,1964 # 1010 <base>
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
 874:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 876:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87a:	b7c1                	j	83a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	a8a9                	j	8da <malloc+0xd6>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	efbff0ef          	jal	782 <free>
  return freep;
 88c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 890:	c12d                	beqz	a0,8f2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	02977263          	bgeu	a4,s1,8ba <malloc+0xb6>
    if(p == freep)
 89a:	00093703          	ld	a4,0(s2)
 89e:	853e                	mv	a0,a5
 8a0:	fef719e3          	bne	a4,a5,892 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8a4:	8552                	mv	a0,s4
 8a6:	a23ff0ef          	jal	2c8 <sbrk>
  if(p == SBRK_ERROR)
 8aa:	fd551ce3          	bne	a0,s5,882 <malloc+0x7e>
        return 0;
 8ae:	4501                	li	a0,0
 8b0:	7902                	ld	s2,32(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
 8b8:	a03d                	j	8e6 <malloc+0xe2>
 8ba:	7902                	ld	s2,32(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c2:	fae48de3          	beq	s1,a4,87c <malloc+0x78>
        p->s.size -= nunits;
 8c6:	4137073b          	subw	a4,a4,s3
 8ca:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8cc:	02071693          	slli	a3,a4,0x20
 8d0:	01c6d713          	srli	a4,a3,0x1c
 8d4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8da:	00000717          	auipc	a4,0x0
 8de:	72a73323          	sd	a0,1830(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e2:	01078513          	addi	a0,a5,16
  }
}
 8e6:	70e2                	ld	ra,56(sp)
 8e8:	7442                	ld	s0,48(sp)
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	69e2                	ld	s3,24(sp)
 8ee:	6121                	addi	sp,sp,64
 8f0:	8082                	ret
 8f2:	7902                	ld	s2,32(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
 8fa:	b7f5                	j	8e6 <malloc+0xe2>
