
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
    if (argc < 2) {
   a:	4785                	li	a5,1
   c:	02a7d563          	bge	a5,a0,36 <main+0x36>
  10:	84ae                	mv	s1,a1
        printf("Usage: trace <syscall_number> <command> <args>\n");
        exit(1);
    }

    int syscall_num = atoi(argv[1]);
  12:	6588                	ld	a0,8(a1)
  14:	1ba000ef          	jal	1ce <atoi>
    if (trace(syscall_num) < 0) {
  18:	2e8000ef          	jal	300 <trace>
  1c:	02054663          	bltz	a0,48 <main+0x48>
        printf("Failed to set trace mask\n");
        exit(1);
    }

    exec(argv[2], argv + 2);
  20:	01048593          	addi	a1,s1,16
  24:	6888                	ld	a0,16(s1)
  26:	322000ef          	jal	348 <exec>
    return 0;
}
  2a:	4501                	li	a0,0
  2c:	60e2                	ld	ra,24(sp)
  2e:	6442                	ld	s0,16(sp)
  30:	64a2                	ld	s1,8(sp)
  32:	6105                	addi	sp,sp,32
  34:	8082                	ret
        printf("Usage: trace <syscall_number> <command> <args>\n");
  36:	00001517          	auipc	a0,0x1
  3a:	8ba50513          	addi	a0,a0,-1862 # 8f0 <malloc+0xf8>
  3e:	706000ef          	jal	744 <printf>
        exit(1);
  42:	4505                	li	a0,1
  44:	2cc000ef          	jal	310 <exit>
        printf("Failed to set trace mask\n");
  48:	00001517          	auipc	a0,0x1
  4c:	8d850513          	addi	a0,a0,-1832 # 920 <malloc+0x128>
  50:	6f4000ef          	jal	744 <printf>
        exit(1);
  54:	4505                	li	a0,1
  56:	2ba000ef          	jal	310 <exit>

000000000000005a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e406                	sd	ra,8(sp)
  5e:	e022                	sd	s0,0(sp)
  60:	0800                	addi	s0,sp,16
  extern int main();
  main();
  62:	f9fff0ef          	jal	0 <main>
  exit(0);
  66:	4501                	li	a0,0
  68:	2a8000ef          	jal	310 <exit>

000000000000006c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e422                	sd	s0,8(sp)
  70:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  72:	87aa                	mv	a5,a0
  74:	0585                	addi	a1,a1,1
  76:	0785                	addi	a5,a5,1
  78:	fff5c703          	lbu	a4,-1(a1)
  7c:	fee78fa3          	sb	a4,-1(a5)
  80:	fb75                	bnez	a4,74 <strcpy+0x8>
    ;
  return os;
}
  82:	6422                	ld	s0,8(sp)
  84:	0141                	addi	sp,sp,16
  86:	8082                	ret

0000000000000088 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  88:	1141                	addi	sp,sp,-16
  8a:	e422                	sd	s0,8(sp)
  8c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cb91                	beqz	a5,a6 <strcmp+0x1e>
  94:	0005c703          	lbu	a4,0(a1)
  98:	00f71763          	bne	a4,a5,a6 <strcmp+0x1e>
    p++, q++;
  9c:	0505                	addi	a0,a0,1
  9e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a0:	00054783          	lbu	a5,0(a0)
  a4:	fbe5                	bnez	a5,94 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a6:	0005c503          	lbu	a0,0(a1)
}
  aa:	40a7853b          	subw	a0,a5,a0
  ae:	6422                	ld	s0,8(sp)
  b0:	0141                	addi	sp,sp,16
  b2:	8082                	ret

00000000000000b4 <strlen>:

uint
strlen(const char *s)
{
  b4:	1141                	addi	sp,sp,-16
  b6:	e422                	sd	s0,8(sp)
  b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cf91                	beqz	a5,da <strlen+0x26>
  c0:	0505                	addi	a0,a0,1
  c2:	87aa                	mv	a5,a0
  c4:	86be                	mv	a3,a5
  c6:	0785                	addi	a5,a5,1
  c8:	fff7c703          	lbu	a4,-1(a5)
  cc:	ff65                	bnez	a4,c4 <strlen+0x10>
  ce:	40a6853b          	subw	a0,a3,a0
  d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d4:	6422                	ld	s0,8(sp)
  d6:	0141                	addi	sp,sp,16
  d8:	8082                	ret
  for(n = 0; s[n]; n++)
  da:	4501                	li	a0,0
  dc:	bfe5                	j	d4 <strlen+0x20>

00000000000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	1141                	addi	sp,sp,-16
  e0:	e422                	sd	s0,8(sp)
  e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e4:	ca19                	beqz	a2,fa <memset+0x1c>
  e6:	87aa                	mv	a5,a0
  e8:	1602                	slli	a2,a2,0x20
  ea:	9201                	srli	a2,a2,0x20
  ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f4:	0785                	addi	a5,a5,1
  f6:	fee79de3          	bne	a5,a4,f0 <memset+0x12>
  }
  return dst;
}
  fa:	6422                	ld	s0,8(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e422                	sd	s0,8(sp)
 104:	0800                	addi	s0,sp,16
  for(; *s; s++)
 106:	00054783          	lbu	a5,0(a0)
 10a:	cb99                	beqz	a5,120 <strchr+0x20>
    if(*s == c)
 10c:	00f58763          	beq	a1,a5,11a <strchr+0x1a>
  for(; *s; s++)
 110:	0505                	addi	a0,a0,1
 112:	00054783          	lbu	a5,0(a0)
 116:	fbfd                	bnez	a5,10c <strchr+0xc>
      return (char*)s;
  return 0;
 118:	4501                	li	a0,0
}
 11a:	6422                	ld	s0,8(sp)
 11c:	0141                	addi	sp,sp,16
 11e:	8082                	ret
  return 0;
 120:	4501                	li	a0,0
 122:	bfe5                	j	11a <strchr+0x1a>

0000000000000124 <gets>:

char*
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	1080                	addi	s0,sp,96
 13a:	8baa                	mv	s7,a0
 13c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13e:	892a                	mv	s2,a0
 140:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 142:	4aa9                	li	s5,10
 144:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 146:	89a6                	mv	s3,s1
 148:	2485                	addiw	s1,s1,1
 14a:	0344d663          	bge	s1,s4,176 <gets+0x52>
    cc = read(0, &c, 1);
 14e:	4605                	li	a2,1
 150:	faf40593          	addi	a1,s0,-81
 154:	4501                	li	a0,0
 156:	1d2000ef          	jal	328 <read>
    if(cc < 1)
 15a:	00a05e63          	blez	a0,176 <gets+0x52>
    buf[i++] = c;
 15e:	faf44783          	lbu	a5,-81(s0)
 162:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 166:	01578763          	beq	a5,s5,174 <gets+0x50>
 16a:	0905                	addi	s2,s2,1
 16c:	fd679de3          	bne	a5,s6,146 <gets+0x22>
    buf[i++] = c;
 170:	89a6                	mv	s3,s1
 172:	a011                	j	176 <gets+0x52>
 174:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 176:	99de                	add	s3,s3,s7
 178:	00098023          	sb	zero,0(s3)
  return buf;
}
 17c:	855e                	mv	a0,s7
 17e:	60e6                	ld	ra,88(sp)
 180:	6446                	ld	s0,80(sp)
 182:	64a6                	ld	s1,72(sp)
 184:	6906                	ld	s2,64(sp)
 186:	79e2                	ld	s3,56(sp)
 188:	7a42                	ld	s4,48(sp)
 18a:	7aa2                	ld	s5,40(sp)
 18c:	7b02                	ld	s6,32(sp)
 18e:	6be2                	ld	s7,24(sp)
 190:	6125                	addi	sp,sp,96
 192:	8082                	ret

0000000000000194 <stat>:

int
stat(const char *n, struct stat *st)
{
 194:	1101                	addi	sp,sp,-32
 196:	ec06                	sd	ra,24(sp)
 198:	e822                	sd	s0,16(sp)
 19a:	e04a                	sd	s2,0(sp)
 19c:	1000                	addi	s0,sp,32
 19e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a0:	4581                	li	a1,0
 1a2:	1ae000ef          	jal	350 <open>
  if(fd < 0)
 1a6:	02054263          	bltz	a0,1ca <stat+0x36>
 1aa:	e426                	sd	s1,8(sp)
 1ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ae:	85ca                	mv	a1,s2
 1b0:	1b8000ef          	jal	368 <fstat>
 1b4:	892a                	mv	s2,a0
  close(fd);
 1b6:	8526                	mv	a0,s1
 1b8:	180000ef          	jal	338 <close>
  return r;
 1bc:	64a2                	ld	s1,8(sp)
}
 1be:	854a                	mv	a0,s2
 1c0:	60e2                	ld	ra,24(sp)
 1c2:	6442                	ld	s0,16(sp)
 1c4:	6902                	ld	s2,0(sp)
 1c6:	6105                	addi	sp,sp,32
 1c8:	8082                	ret
    return -1;
 1ca:	597d                	li	s2,-1
 1cc:	bfcd                	j	1be <stat+0x2a>

00000000000001ce <atoi>:

int
atoi(const char *s)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1d4:	00054683          	lbu	a3,0(a0)
 1d8:	fd06879b          	addiw	a5,a3,-48
 1dc:	0ff7f793          	zext.b	a5,a5
 1e0:	4625                	li	a2,9
 1e2:	02f66863          	bltu	a2,a5,212 <atoi+0x44>
 1e6:	872a                	mv	a4,a0
  n = 0;
 1e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ea:	0705                	addi	a4,a4,1
 1ec:	0025179b          	slliw	a5,a0,0x2
 1f0:	9fa9                	addw	a5,a5,a0
 1f2:	0017979b          	slliw	a5,a5,0x1
 1f6:	9fb5                	addw	a5,a5,a3
 1f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1fc:	00074683          	lbu	a3,0(a4)
 200:	fd06879b          	addiw	a5,a3,-48
 204:	0ff7f793          	zext.b	a5,a5
 208:	fef671e3          	bgeu	a2,a5,1ea <atoi+0x1c>
  return n;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
  n = 0;
 212:	4501                	li	a0,0
 214:	bfe5                	j	20c <atoi+0x3e>

0000000000000216 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21c:	02b57463          	bgeu	a0,a1,244 <memmove+0x2e>
    while(n-- > 0)
 220:	00c05f63          	blez	a2,23e <memmove+0x28>
 224:	1602                	slli	a2,a2,0x20
 226:	9201                	srli	a2,a2,0x20
 228:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22c:	872a                	mv	a4,a0
      *dst++ = *src++;
 22e:	0585                	addi	a1,a1,1
 230:	0705                	addi	a4,a4,1
 232:	fff5c683          	lbu	a3,-1(a1)
 236:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23a:	fef71ae3          	bne	a4,a5,22e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
    dst += n;
 244:	00c50733          	add	a4,a0,a2
    src += n;
 248:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24a:	fec05ae3          	blez	a2,23e <memmove+0x28>
 24e:	fff6079b          	addiw	a5,a2,-1
 252:	1782                	slli	a5,a5,0x20
 254:	9381                	srli	a5,a5,0x20
 256:	fff7c793          	not	a5,a5
 25a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25c:	15fd                	addi	a1,a1,-1
 25e:	177d                	addi	a4,a4,-1
 260:	0005c683          	lbu	a3,0(a1)
 264:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x46>
 26c:	bfc9                	j	23e <memmove+0x28>

000000000000026e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 274:	ca05                	beqz	a2,2a4 <memcmp+0x36>
 276:	fff6069b          	addiw	a3,a2,-1
 27a:	1682                	slli	a3,a3,0x20
 27c:	9281                	srli	a3,a3,0x20
 27e:	0685                	addi	a3,a3,1
 280:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 282:	00054783          	lbu	a5,0(a0)
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00e79863          	bne	a5,a4,29a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28e:	0505                	addi	a0,a0,1
    p2++;
 290:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 292:	fed518e3          	bne	a0,a3,282 <memcmp+0x14>
  }
  return 0;
 296:	4501                	li	a0,0
 298:	a019                	j	29e <memcmp+0x30>
      return *p1 - *p2;
 29a:	40e7853b          	subw	a0,a5,a4
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <memcmp+0x30>

00000000000002a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b0:	f67ff0ef          	jal	216 <memmove>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <sbrk>:

char *
sbrk(int n) {
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2c4:	4585                	li	a1,1
 2c6:	0d2000ef          	jal	398 <sys_sbrk>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <sbrklazy>:

char *
sbrklazy(int n) {
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2da:	4589                	li	a1,2
 2dc:	0bc000ef          	jal	398 <sys_sbrk>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 2e8:	48e5                	li	a7,25
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 2f0:	48e1                	li	a7,24
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 2f8:	48dd                	li	a7,23
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <trace>:
.global trace
trace:
 li a7, SYS_trace
 300:	48d9                	li	a7,22
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <fork>:
.global fork
fork:
 li a7, SYS_fork
 308:	4885                	li	a7,1
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exit>:
.global exit
exit:
 li a7, SYS_exit
 310:	4889                	li	a7,2
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <wait>:
.global wait
wait:
 li a7, SYS_wait
 318:	488d                	li	a7,3
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 320:	4891                	li	a7,4
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <read>:
.global read
read:
 li a7, SYS_read
 328:	4895                	li	a7,5
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <write>:
.global write
write:
 li a7, SYS_write
 330:	48c1                	li	a7,16
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <close>:
.global close
close:
 li a7, SYS_close
 338:	48d5                	li	a7,21
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <kill>:
.global kill
kill:
 li a7, SYS_kill
 340:	4899                	li	a7,6
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exec>:
.global exec
exec:
 li a7, SYS_exec
 348:	489d                	li	a7,7
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <open>:
.global open
open:
 li a7, SYS_open
 350:	48bd                	li	a7,15
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 368:	48a1                	li	a7,8
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <link>:
.global link
link:
 li a7, SYS_link
 370:	48cd                	li	a7,19
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 378:	48d1                	li	a7,20
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3b0:	1101                	addi	sp,sp,-32
 3b2:	ec06                	sd	ra,24(sp)
 3b4:	e822                	sd	s0,16(sp)
 3b6:	1000                	addi	s0,sp,32
 3b8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3bc:	4605                	li	a2,1
 3be:	fef40593          	addi	a1,s0,-17
 3c2:	f6fff0ef          	jal	330 <write>
}
 3c6:	60e2                	ld	ra,24(sp)
 3c8:	6442                	ld	s0,16(sp)
 3ca:	6105                	addi	sp,sp,32
 3cc:	8082                	ret

00000000000003ce <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ce:	715d                	addi	sp,sp,-80
 3d0:	e486                	sd	ra,72(sp)
 3d2:	e0a2                	sd	s0,64(sp)
 3d4:	fc26                	sd	s1,56(sp)
 3d6:	0880                	addi	s0,sp,80
 3d8:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3da:	c299                	beqz	a3,3e0 <printint+0x12>
 3dc:	0805c963          	bltz	a1,46e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3e0:	2581                	sext.w	a1,a1
  neg = 0;
 3e2:	4881                	li	a7,0
 3e4:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 3e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ea:	2601                	sext.w	a2,a2
 3ec:	00000517          	auipc	a0,0x0
 3f0:	55c50513          	addi	a0,a0,1372 # 948 <digits>
 3f4:	883a                	mv	a6,a4
 3f6:	2705                	addiw	a4,a4,1
 3f8:	02c5f7bb          	remuw	a5,a1,a2
 3fc:	1782                	slli	a5,a5,0x20
 3fe:	9381                	srli	a5,a5,0x20
 400:	97aa                	add	a5,a5,a0
 402:	0007c783          	lbu	a5,0(a5)
 406:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 40a:	0005879b          	sext.w	a5,a1
 40e:	02c5d5bb          	divuw	a1,a1,a2
 412:	0685                	addi	a3,a3,1
 414:	fec7f0e3          	bgeu	a5,a2,3f4 <printint+0x26>
  if(neg)
 418:	00088c63          	beqz	a7,430 <printint+0x62>
    buf[i++] = '-';
 41c:	fd070793          	addi	a5,a4,-48
 420:	00878733          	add	a4,a5,s0
 424:	02d00793          	li	a5,45
 428:	fef70423          	sb	a5,-24(a4)
 42c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 430:	02e05a63          	blez	a4,464 <printint+0x96>
 434:	f84a                	sd	s2,48(sp)
 436:	f44e                	sd	s3,40(sp)
 438:	fb840793          	addi	a5,s0,-72
 43c:	00e78933          	add	s2,a5,a4
 440:	fff78993          	addi	s3,a5,-1
 444:	99ba                	add	s3,s3,a4
 446:	377d                	addiw	a4,a4,-1
 448:	1702                	slli	a4,a4,0x20
 44a:	9301                	srli	a4,a4,0x20
 44c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 450:	fff94583          	lbu	a1,-1(s2)
 454:	8526                	mv	a0,s1
 456:	f5bff0ef          	jal	3b0 <putc>
  while(--i >= 0)
 45a:	197d                	addi	s2,s2,-1
 45c:	ff391ae3          	bne	s2,s3,450 <printint+0x82>
 460:	7942                	ld	s2,48(sp)
 462:	79a2                	ld	s3,40(sp)
}
 464:	60a6                	ld	ra,72(sp)
 466:	6406                	ld	s0,64(sp)
 468:	74e2                	ld	s1,56(sp)
 46a:	6161                	addi	sp,sp,80
 46c:	8082                	ret
    x = -xx;
 46e:	40b005bb          	negw	a1,a1
    neg = 1;
 472:	4885                	li	a7,1
    x = -xx;
 474:	bf85                	j	3e4 <printint+0x16>

0000000000000476 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 476:	711d                	addi	sp,sp,-96
 478:	ec86                	sd	ra,88(sp)
 47a:	e8a2                	sd	s0,80(sp)
 47c:	e0ca                	sd	s2,64(sp)
 47e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 480:	0005c903          	lbu	s2,0(a1)
 484:	28090663          	beqz	s2,710 <vprintf+0x29a>
 488:	e4a6                	sd	s1,72(sp)
 48a:	fc4e                	sd	s3,56(sp)
 48c:	f852                	sd	s4,48(sp)
 48e:	f456                	sd	s5,40(sp)
 490:	f05a                	sd	s6,32(sp)
 492:	ec5e                	sd	s7,24(sp)
 494:	e862                	sd	s8,16(sp)
 496:	e466                	sd	s9,8(sp)
 498:	8b2a                	mv	s6,a0
 49a:	8a2e                	mv	s4,a1
 49c:	8bb2                	mv	s7,a2
  state = 0;
 49e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a0:	4481                	li	s1,0
 4a2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4a8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ac:	06c00c93          	li	s9,108
 4b0:	a005                	j	4d0 <vprintf+0x5a>
        putc(fd, c0);
 4b2:	85ca                	mv	a1,s2
 4b4:	855a                	mv	a0,s6
 4b6:	efbff0ef          	jal	3b0 <putc>
 4ba:	a019                	j	4c0 <vprintf+0x4a>
    } else if(state == '%'){
 4bc:	03598263          	beq	s3,s5,4e0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4c0:	2485                	addiw	s1,s1,1
 4c2:	8726                	mv	a4,s1
 4c4:	009a07b3          	add	a5,s4,s1
 4c8:	0007c903          	lbu	s2,0(a5)
 4cc:	22090a63          	beqz	s2,700 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 4d0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4d4:	fe0994e3          	bnez	s3,4bc <vprintf+0x46>
      if(c0 == '%'){
 4d8:	fd579de3          	bne	a5,s5,4b2 <vprintf+0x3c>
        state = '%';
 4dc:	89be                	mv	s3,a5
 4de:	b7cd                	j	4c0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e0:	00ea06b3          	add	a3,s4,a4
 4e4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4e8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4ea:	c681                	beqz	a3,4f2 <vprintf+0x7c>
 4ec:	9752                	add	a4,a4,s4
 4ee:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4f2:	05878363          	beq	a5,s8,538 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 4f6:	05978d63          	beq	a5,s9,550 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4fa:	07500713          	li	a4,117
 4fe:	0ee78763          	beq	a5,a4,5ec <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 502:	07800713          	li	a4,120
 506:	12e78963          	beq	a5,a4,638 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 50a:	07000713          	li	a4,112
 50e:	14e78e63          	beq	a5,a4,66a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 512:	06300713          	li	a4,99
 516:	18e78e63          	beq	a5,a4,6b2 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 51a:	07300713          	li	a4,115
 51e:	1ae78463          	beq	a5,a4,6c6 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 522:	02500713          	li	a4,37
 526:	04e79563          	bne	a5,a4,570 <vprintf+0xfa>
        putc(fd, '%');
 52a:	02500593          	li	a1,37
 52e:	855a                	mv	a0,s6
 530:	e81ff0ef          	jal	3b0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 534:	4981                	li	s3,0
 536:	b769                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 538:	008b8913          	addi	s2,s7,8
 53c:	4685                	li	a3,1
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e89ff0ef          	jal	3ce <printint>
 54a:	8bca                	mv	s7,s2
      state = 0;
 54c:	4981                	li	s3,0
 54e:	bf8d                	j	4c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 550:	06400793          	li	a5,100
 554:	02f68963          	beq	a3,a5,586 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 558:	06c00793          	li	a5,108
 55c:	04f68263          	beq	a3,a5,5a0 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 560:	07500793          	li	a5,117
 564:	0af68063          	beq	a3,a5,604 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 568:	07800793          	li	a5,120
 56c:	0ef68263          	beq	a3,a5,650 <vprintf+0x1da>
        putc(fd, '%');
 570:	02500593          	li	a1,37
 574:	855a                	mv	a0,s6
 576:	e3bff0ef          	jal	3b0 <putc>
        putc(fd, c0);
 57a:	85ca                	mv	a1,s2
 57c:	855a                	mv	a0,s6
 57e:	e33ff0ef          	jal	3b0 <putc>
      state = 0;
 582:	4981                	li	s3,0
 584:	bf35                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8913          	addi	s2,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e3bff0ef          	jal	3ce <printint>
        i += 1;
 598:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8bca                	mv	s7,s2
      state = 0;
 59c:	4981                	li	s3,0
        i += 1;
 59e:	b70d                	j	4c0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a0:	06400793          	li	a5,100
 5a4:	02f60763          	beq	a2,a5,5d2 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5a8:	07500793          	li	a5,117
 5ac:	06f60963          	beq	a2,a5,61e <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5b0:	07800793          	li	a5,120
 5b4:	faf61ee3          	bne	a2,a5,570 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000bb583          	ld	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	e09ff0ef          	jal	3ce <printint>
        i += 2;
 5ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8bca                	mv	s7,s2
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	bdc5                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d2:	008b8913          	addi	s2,s7,8
 5d6:	4685                	li	a3,1
 5d8:	4629                	li	a2,10
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	defff0ef          	jal	3ce <printint>
        i += 2;
 5e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e6:	8bca                	mv	s7,s2
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	bdd9                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ec:	008b8913          	addi	s2,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000be583          	lwu	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	dd5ff0ef          	jal	3ce <printint>
 5fe:	8bca                	mv	s7,s2
      state = 0;
 600:	4981                	li	s3,0
 602:	bd7d                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 604:	008b8913          	addi	s2,s7,8
 608:	4681                	li	a3,0
 60a:	4629                	li	a2,10
 60c:	000bb583          	ld	a1,0(s7)
 610:	855a                	mv	a0,s6
 612:	dbdff0ef          	jal	3ce <printint>
        i += 1;
 616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 618:	8bca                	mv	s7,s2
      state = 0;
 61a:	4981                	li	s3,0
        i += 1;
 61c:	b555                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61e:	008b8913          	addi	s2,s7,8
 622:	4681                	li	a3,0
 624:	4629                	li	a2,10
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	da3ff0ef          	jal	3ce <printint>
        i += 2;
 630:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 632:	8bca                	mv	s7,s2
      state = 0;
 634:	4981                	li	s3,0
        i += 2;
 636:	b569                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 638:	008b8913          	addi	s2,s7,8
 63c:	4681                	li	a3,0
 63e:	4641                	li	a2,16
 640:	000be583          	lwu	a1,0(s7)
 644:	855a                	mv	a0,s6
 646:	d89ff0ef          	jal	3ce <printint>
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bd8d                	j	4c0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 650:	008b8913          	addi	s2,s7,8
 654:	4681                	li	a3,0
 656:	4641                	li	a2,16
 658:	000bb583          	ld	a1,0(s7)
 65c:	855a                	mv	a0,s6
 65e:	d71ff0ef          	jal	3ce <printint>
        i += 1;
 662:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 664:	8bca                	mv	s7,s2
      state = 0;
 666:	4981                	li	s3,0
        i += 1;
 668:	bda1                	j	4c0 <vprintf+0x4a>
 66a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 66c:	008b8d13          	addi	s10,s7,8
 670:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 674:	03000593          	li	a1,48
 678:	855a                	mv	a0,s6
 67a:	d37ff0ef          	jal	3b0 <putc>
  putc(fd, 'x');
 67e:	07800593          	li	a1,120
 682:	855a                	mv	a0,s6
 684:	d2dff0ef          	jal	3b0 <putc>
 688:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 68a:	00000b97          	auipc	s7,0x0
 68e:	2beb8b93          	addi	s7,s7,702 # 948 <digits>
 692:	03c9d793          	srli	a5,s3,0x3c
 696:	97de                	add	a5,a5,s7
 698:	0007c583          	lbu	a1,0(a5)
 69c:	855a                	mv	a0,s6
 69e:	d13ff0ef          	jal	3b0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	slli	s3,s3,0x4
 6a4:	397d                	addiw	s2,s2,-1
 6a6:	fe0916e3          	bnez	s2,692 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 6aa:	8bea                	mv	s7,s10
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	6d02                	ld	s10,0(sp)
 6b0:	bd01                	j	4c0 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	000bc583          	lbu	a1,0(s7)
 6ba:	855a                	mv	a0,s6
 6bc:	cf5ff0ef          	jal	3b0 <putc>
 6c0:	8bca                	mv	s7,s2
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bbf5                	j	4c0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6c6:	008b8993          	addi	s3,s7,8
 6ca:	000bb903          	ld	s2,0(s7)
 6ce:	00090f63          	beqz	s2,6ec <vprintf+0x276>
        for(; *s; s++)
 6d2:	00094583          	lbu	a1,0(s2)
 6d6:	c195                	beqz	a1,6fa <vprintf+0x284>
          putc(fd, *s);
 6d8:	855a                	mv	a0,s6
 6da:	cd7ff0ef          	jal	3b0 <putc>
        for(; *s; s++)
 6de:	0905                	addi	s2,s2,1
 6e0:	00094583          	lbu	a1,0(s2)
 6e4:	f9f5                	bnez	a1,6d8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6e6:	8bce                	mv	s7,s3
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bbd9                	j	4c0 <vprintf+0x4a>
          s = "(null)";
 6ec:	00000917          	auipc	s2,0x0
 6f0:	25490913          	addi	s2,s2,596 # 940 <malloc+0x148>
        for(; *s; s++)
 6f4:	02800593          	li	a1,40
 6f8:	b7c5                	j	6d8 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 6fa:	8bce                	mv	s7,s3
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b3c9                	j	4c0 <vprintf+0x4a>
 700:	64a6                	ld	s1,72(sp)
 702:	79e2                	ld	s3,56(sp)
 704:	7a42                	ld	s4,48(sp)
 706:	7aa2                	ld	s5,40(sp)
 708:	7b02                	ld	s6,32(sp)
 70a:	6be2                	ld	s7,24(sp)
 70c:	6c42                	ld	s8,16(sp)
 70e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 710:	60e6                	ld	ra,88(sp)
 712:	6446                	ld	s0,80(sp)
 714:	6906                	ld	s2,64(sp)
 716:	6125                	addi	sp,sp,96
 718:	8082                	ret

000000000000071a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71a:	715d                	addi	sp,sp,-80
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	e010                	sd	a2,0(s0)
 724:	e414                	sd	a3,8(s0)
 726:	e818                	sd	a4,16(s0)
 728:	ec1c                	sd	a5,24(s0)
 72a:	03043023          	sd	a6,32(s0)
 72e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 732:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 736:	8622                	mv	a2,s0
 738:	d3fff0ef          	jal	476 <vprintf>
}
 73c:	60e2                	ld	ra,24(sp)
 73e:	6442                	ld	s0,16(sp)
 740:	6161                	addi	sp,sp,80
 742:	8082                	ret

0000000000000744 <printf>:

void
printf(const char *fmt, ...)
{
 744:	711d                	addi	sp,sp,-96
 746:	ec06                	sd	ra,24(sp)
 748:	e822                	sd	s0,16(sp)
 74a:	1000                	addi	s0,sp,32
 74c:	e40c                	sd	a1,8(s0)
 74e:	e810                	sd	a2,16(s0)
 750:	ec14                	sd	a3,24(s0)
 752:	f018                	sd	a4,32(s0)
 754:	f41c                	sd	a5,40(s0)
 756:	03043823          	sd	a6,48(s0)
 75a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75e:	00840613          	addi	a2,s0,8
 762:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 766:	85aa                	mv	a1,a0
 768:	4505                	li	a0,1
 76a:	d0dff0ef          	jal	476 <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6125                	addi	sp,sp,96
 774:	8082                	ret

0000000000000776 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 776:	1141                	addi	sp,sp,-16
 778:	e422                	sd	s0,8(sp)
 77a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	00001797          	auipc	a5,0x1
 784:	8807b783          	ld	a5,-1920(a5) # 1000 <freep>
 788:	a02d                	j	7b2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78a:	4618                	lw	a4,8(a2)
 78c:	9f2d                	addw	a4,a4,a1
 78e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 792:	6398                	ld	a4,0(a5)
 794:	6310                	ld	a2,0(a4)
 796:	a83d                	j	7d4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 798:	ff852703          	lw	a4,-8(a0)
 79c:	9f31                	addw	a4,a4,a2
 79e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a0:	ff053683          	ld	a3,-16(a0)
 7a4:	a091                	j	7e8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a6:	6398                	ld	a4,0(a5)
 7a8:	00e7e463          	bltu	a5,a4,7b0 <free+0x3a>
 7ac:	00e6ea63          	bltu	a3,a4,7c0 <free+0x4a>
{
 7b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b2:	fed7fae3          	bgeu	a5,a3,7a6 <free+0x30>
 7b6:	6398                	ld	a4,0(a5)
 7b8:	00e6e463          	bltu	a3,a4,7c0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7bc:	fee7eae3          	bltu	a5,a4,7b0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c0:	ff852583          	lw	a1,-8(a0)
 7c4:	6390                	ld	a2,0(a5)
 7c6:	02059813          	slli	a6,a1,0x20
 7ca:	01c85713          	srli	a4,a6,0x1c
 7ce:	9736                	add	a4,a4,a3
 7d0:	fae60de3          	beq	a2,a4,78a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7d8:	4790                	lw	a2,8(a5)
 7da:	02061593          	slli	a1,a2,0x20
 7de:	01c5d713          	srli	a4,a1,0x1c
 7e2:	973e                	add	a4,a4,a5
 7e4:	fae68ae3          	beq	a3,a4,798 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ea:	00001717          	auipc	a4,0x1
 7ee:	80f73b23          	sd	a5,-2026(a4) # 1000 <freep>
}
 7f2:	6422                	ld	s0,8(sp)
 7f4:	0141                	addi	sp,sp,16
 7f6:	8082                	ret

00000000000007f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f8:	7139                	addi	sp,sp,-64
 7fa:	fc06                	sd	ra,56(sp)
 7fc:	f822                	sd	s0,48(sp)
 7fe:	f426                	sd	s1,40(sp)
 800:	ec4e                	sd	s3,24(sp)
 802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 804:	02051493          	slli	s1,a0,0x20
 808:	9081                	srli	s1,s1,0x20
 80a:	04bd                	addi	s1,s1,15
 80c:	8091                	srli	s1,s1,0x4
 80e:	0014899b          	addiw	s3,s1,1
 812:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 814:	00000517          	auipc	a0,0x0
 818:	7ec53503          	ld	a0,2028(a0) # 1000 <freep>
 81c:	c915                	beqz	a0,850 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 820:	4798                	lw	a4,8(a5)
 822:	08977a63          	bgeu	a4,s1,8b6 <malloc+0xbe>
 826:	f04a                	sd	s2,32(sp)
 828:	e852                	sd	s4,16(sp)
 82a:	e456                	sd	s5,8(sp)
 82c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 82e:	8a4e                	mv	s4,s3
 830:	0009871b          	sext.w	a4,s3
 834:	6685                	lui	a3,0x1
 836:	00d77363          	bgeu	a4,a3,83c <malloc+0x44>
 83a:	6a05                	lui	s4,0x1
 83c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 840:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 844:	00000917          	auipc	s2,0x0
 848:	7bc90913          	addi	s2,s2,1980 # 1000 <freep>
  if(p == SBRK_ERROR)
 84c:	5afd                	li	s5,-1
 84e:	a081                	j	88e <malloc+0x96>
 850:	f04a                	sd	s2,32(sp)
 852:	e852                	sd	s4,16(sp)
 854:	e456                	sd	s5,8(sp)
 856:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 858:	00000797          	auipc	a5,0x0
 85c:	7b878793          	addi	a5,a5,1976 # 1010 <base>
 860:	00000717          	auipc	a4,0x0
 864:	7af73023          	sd	a5,1952(a4) # 1000 <freep>
 868:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 86e:	b7c1                	j	82e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	e118                	sd	a4,0(a0)
 874:	a8a9                	j	8ce <malloc+0xd6>
  hp->s.size = nu;
 876:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87a:	0541                	addi	a0,a0,16
 87c:	efbff0ef          	jal	776 <free>
  return freep;
 880:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 884:	c12d                	beqz	a0,8e6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 886:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 888:	4798                	lw	a4,8(a5)
 88a:	02977263          	bgeu	a4,s1,8ae <malloc+0xb6>
    if(p == freep)
 88e:	00093703          	ld	a4,0(s2)
 892:	853e                	mv	a0,a5
 894:	fef719e3          	bne	a4,a5,886 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 898:	8552                	mv	a0,s4
 89a:	a23ff0ef          	jal	2bc <sbrk>
  if(p == SBRK_ERROR)
 89e:	fd551ce3          	bne	a0,s5,876 <malloc+0x7e>
        return 0;
 8a2:	4501                	li	a0,0
 8a4:	7902                	ld	s2,32(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	a03d                	j	8da <malloc+0xe2>
 8ae:	7902                	ld	s2,32(sp)
 8b0:	6a42                	ld	s4,16(sp)
 8b2:	6aa2                	ld	s5,8(sp)
 8b4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b6:	fae48de3          	beq	s1,a4,870 <malloc+0x78>
        p->s.size -= nunits;
 8ba:	4137073b          	subw	a4,a4,s3
 8be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c0:	02071693          	slli	a3,a4,0x20
 8c4:	01c6d713          	srli	a4,a3,0x1c
 8c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72a73923          	sd	a0,1842(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d6:	01078513          	addi	a0,a5,16
  }
}
 8da:	70e2                	ld	ra,56(sp)
 8dc:	7442                	ld	s0,48(sp)
 8de:	74a2                	ld	s1,40(sp)
 8e0:	69e2                	ld	s3,24(sp)
 8e2:	6121                	addi	sp,sp,64
 8e4:	8082                	ret
 8e6:	7902                	ld	s2,32(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
 8ee:	b7f5                	j	8da <malloc+0xe2>
