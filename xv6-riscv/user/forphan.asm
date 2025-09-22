
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	95050513          	addi	a0,a0,-1712 # 960 <malloc+0xfe>
  18:	3a2000ef          	jal	3ba <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	addi	a1,s0,-56
  24:	3ae000ef          	jal	3d2 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	93450513          	addi	a0,a0,-1740 # 960 <malloc+0xfe>
  34:	396000ef          	jal	3ca <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	92250513          	addi	a0,a0,-1758 # 960 <malloc+0xfe>
  46:	374000ef          	jal	3ba <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	96e50513          	addi	a0,a0,-1682 # 9c0 <malloc+0x15e>
  5a:	754000ef          	jal	7ae <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	31a000ef          	jal	37a <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	90a50513          	addi	a0,a0,-1782 # 970 <malloc+0x10e>
  6e:	740000ef          	jal	7ae <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	306000ef          	jal	37a <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	91068693          	addi	a3,a3,-1776 # 988 <malloc+0x126>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	90e58593          	addi	a1,a1,-1778 # 990 <malloc+0x12e>
  8a:	4509                	li	a0,2
  8c:	6f8000ef          	jal	784 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2e8000ef          	jal	37a <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	91050513          	addi	a0,a0,-1776 # 9a8 <malloc+0x146>
  a0:	70e000ef          	jal	7ae <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2d4000ef          	jal	37a <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	92a50513          	addi	a0,a0,-1750 # 9d8 <malloc+0x176>
  b6:	6f8000ef          	jal	7ae <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800513          	li	a0,1000
  be:	34c000ef          	jal	40a <pause>
  c2:	bfe5                	j	ba <main+0xba>

00000000000000c4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  extern int main();
  main();
  cc:	f35ff0ef          	jal	0 <main>
  exit(0);
  d0:	4501                	li	a0,0
  d2:	2a8000ef          	jal	37a <exit>

00000000000000d6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  dc:	87aa                	mv	a5,a0
  de:	0585                	addi	a1,a1,1
  e0:	0785                	addi	a5,a5,1
  e2:	fff5c703          	lbu	a4,-1(a1)
  e6:	fee78fa3          	sb	a4,-1(a5)
  ea:	fb75                	bnez	a4,de <strcpy+0x8>
    ;
  return os;
}
  ec:	6422                	ld	s0,8(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret

00000000000000f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e422                	sd	s0,8(sp)
  f6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  f8:	00054783          	lbu	a5,0(a0)
  fc:	cb91                	beqz	a5,110 <strcmp+0x1e>
  fe:	0005c703          	lbu	a4,0(a1)
 102:	00f71763          	bne	a4,a5,110 <strcmp+0x1e>
    p++, q++;
 106:	0505                	addi	a0,a0,1
 108:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	fbe5                	bnez	a5,fe <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 110:	0005c503          	lbu	a0,0(a1)
}
 114:	40a7853b          	subw	a0,a5,a0
 118:	6422                	ld	s0,8(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 124:	00054783          	lbu	a5,0(a0)
 128:	cf91                	beqz	a5,144 <strlen+0x26>
 12a:	0505                	addi	a0,a0,1
 12c:	87aa                	mv	a5,a0
 12e:	86be                	mv	a3,a5
 130:	0785                	addi	a5,a5,1
 132:	fff7c703          	lbu	a4,-1(a5)
 136:	ff65                	bnez	a4,12e <strlen+0x10>
 138:	40a6853b          	subw	a0,a3,a0
 13c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret
  for(n = 0; s[n]; n++)
 144:	4501                	li	a0,0
 146:	bfe5                	j	13e <strlen+0x20>

0000000000000148 <memset>:

void*
memset(void *dst, int c, uint n)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e422                	sd	s0,8(sp)
 14c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 14e:	ca19                	beqz	a2,164 <memset+0x1c>
 150:	87aa                	mv	a5,a0
 152:	1602                	slli	a2,a2,0x20
 154:	9201                	srli	a2,a2,0x20
 156:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 15e:	0785                	addi	a5,a5,1
 160:	fee79de3          	bne	a5,a4,15a <memset+0x12>
  }
  return dst;
}
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strchr>:

char*
strchr(const char *s, char c)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cb99                	beqz	a5,18a <strchr+0x20>
    if(*s == c)
 176:	00f58763          	beq	a1,a5,184 <strchr+0x1a>
  for(; *s; s++)
 17a:	0505                	addi	a0,a0,1
 17c:	00054783          	lbu	a5,0(a0)
 180:	fbfd                	bnez	a5,176 <strchr+0xc>
      return (char*)s;
  return 0;
 182:	4501                	li	a0,0
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  return 0;
 18a:	4501                	li	a0,0
 18c:	bfe5                	j	184 <strchr+0x1a>

000000000000018e <gets>:

char*
gets(char *buf, int max)
{
 18e:	711d                	addi	sp,sp,-96
 190:	ec86                	sd	ra,88(sp)
 192:	e8a2                	sd	s0,80(sp)
 194:	e4a6                	sd	s1,72(sp)
 196:	e0ca                	sd	s2,64(sp)
 198:	fc4e                	sd	s3,56(sp)
 19a:	f852                	sd	s4,48(sp)
 19c:	f456                	sd	s5,40(sp)
 19e:	f05a                	sd	s6,32(sp)
 1a0:	ec5e                	sd	s7,24(sp)
 1a2:	1080                	addi	s0,sp,96
 1a4:	8baa                	mv	s7,a0
 1a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	892a                	mv	s2,a0
 1aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ac:	4aa9                	li	s5,10
 1ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1b0:	89a6                	mv	s3,s1
 1b2:	2485                	addiw	s1,s1,1
 1b4:	0344d663          	bge	s1,s4,1e0 <gets+0x52>
    cc = read(0, &c, 1);
 1b8:	4605                	li	a2,1
 1ba:	faf40593          	addi	a1,s0,-81
 1be:	4501                	li	a0,0
 1c0:	1d2000ef          	jal	392 <read>
    if(cc < 1)
 1c4:	00a05e63          	blez	a0,1e0 <gets+0x52>
    buf[i++] = c;
 1c8:	faf44783          	lbu	a5,-81(s0)
 1cc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1d0:	01578763          	beq	a5,s5,1de <gets+0x50>
 1d4:	0905                	addi	s2,s2,1
 1d6:	fd679de3          	bne	a5,s6,1b0 <gets+0x22>
    buf[i++] = c;
 1da:	89a6                	mv	s3,s1
 1dc:	a011                	j	1e0 <gets+0x52>
 1de:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1e0:	99de                	add	s3,s3,s7
 1e2:	00098023          	sb	zero,0(s3)
  return buf;
}
 1e6:	855e                	mv	a0,s7
 1e8:	60e6                	ld	ra,88(sp)
 1ea:	6446                	ld	s0,80(sp)
 1ec:	64a6                	ld	s1,72(sp)
 1ee:	6906                	ld	s2,64(sp)
 1f0:	79e2                	ld	s3,56(sp)
 1f2:	7a42                	ld	s4,48(sp)
 1f4:	7aa2                	ld	s5,40(sp)
 1f6:	7b02                	ld	s6,32(sp)
 1f8:	6be2                	ld	s7,24(sp)
 1fa:	6125                	addi	sp,sp,96
 1fc:	8082                	ret

00000000000001fe <stat>:

int
stat(const char *n, struct stat *st)
{
 1fe:	1101                	addi	sp,sp,-32
 200:	ec06                	sd	ra,24(sp)
 202:	e822                	sd	s0,16(sp)
 204:	e04a                	sd	s2,0(sp)
 206:	1000                	addi	s0,sp,32
 208:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20a:	4581                	li	a1,0
 20c:	1ae000ef          	jal	3ba <open>
  if(fd < 0)
 210:	02054263          	bltz	a0,234 <stat+0x36>
 214:	e426                	sd	s1,8(sp)
 216:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 218:	85ca                	mv	a1,s2
 21a:	1b8000ef          	jal	3d2 <fstat>
 21e:	892a                	mv	s2,a0
  close(fd);
 220:	8526                	mv	a0,s1
 222:	180000ef          	jal	3a2 <close>
  return r;
 226:	64a2                	ld	s1,8(sp)
}
 228:	854a                	mv	a0,s2
 22a:	60e2                	ld	ra,24(sp)
 22c:	6442                	ld	s0,16(sp)
 22e:	6902                	ld	s2,0(sp)
 230:	6105                	addi	sp,sp,32
 232:	8082                	ret
    return -1;
 234:	597d                	li	s2,-1
 236:	bfcd                	j	228 <stat+0x2a>

0000000000000238 <atoi>:

int
atoi(const char *s)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23e:	00054683          	lbu	a3,0(a0)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	4625                	li	a2,9
 24c:	02f66863          	bltu	a2,a5,27c <atoi+0x44>
 250:	872a                	mv	a4,a0
  n = 0;
 252:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 254:	0705                	addi	a4,a4,1
 256:	0025179b          	slliw	a5,a0,0x2
 25a:	9fa9                	addw	a5,a5,a0
 25c:	0017979b          	slliw	a5,a5,0x1
 260:	9fb5                	addw	a5,a5,a3
 262:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 266:	00074683          	lbu	a3,0(a4)
 26a:	fd06879b          	addiw	a5,a3,-48
 26e:	0ff7f793          	zext.b	a5,a5
 272:	fef671e3          	bgeu	a2,a5,254 <atoi+0x1c>
  return n;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret
  n = 0;
 27c:	4501                	li	a0,0
 27e:	bfe5                	j	276 <atoi+0x3e>

0000000000000280 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 286:	02b57463          	bgeu	a0,a1,2ae <memmove+0x2e>
    while(n-- > 0)
 28a:	00c05f63          	blez	a2,2a8 <memmove+0x28>
 28e:	1602                	slli	a2,a2,0x20
 290:	9201                	srli	a2,a2,0x20
 292:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 296:	872a                	mv	a4,a0
      *dst++ = *src++;
 298:	0585                	addi	a1,a1,1
 29a:	0705                	addi	a4,a4,1
 29c:	fff5c683          	lbu	a3,-1(a1)
 2a0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2a4:	fef71ae3          	bne	a4,a5,298 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a8:	6422                	ld	s0,8(sp)
 2aa:	0141                	addi	sp,sp,16
 2ac:	8082                	ret
    dst += n;
 2ae:	00c50733          	add	a4,a0,a2
    src += n;
 2b2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2b4:	fec05ae3          	blez	a2,2a8 <memmove+0x28>
 2b8:	fff6079b          	addiw	a5,a2,-1
 2bc:	1782                	slli	a5,a5,0x20
 2be:	9381                	srli	a5,a5,0x20
 2c0:	fff7c793          	not	a5,a5
 2c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c6:	15fd                	addi	a1,a1,-1
 2c8:	177d                	addi	a4,a4,-1
 2ca:	0005c683          	lbu	a3,0(a1)
 2ce:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2d2:	fee79ae3          	bne	a5,a4,2c6 <memmove+0x46>
 2d6:	bfc9                	j	2a8 <memmove+0x28>

00000000000002d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2de:	ca05                	beqz	a2,30e <memcmp+0x36>
 2e0:	fff6069b          	addiw	a3,a2,-1
 2e4:	1682                	slli	a3,a3,0x20
 2e6:	9281                	srli	a3,a3,0x20
 2e8:	0685                	addi	a3,a3,1
 2ea:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ec:	00054783          	lbu	a5,0(a0)
 2f0:	0005c703          	lbu	a4,0(a1)
 2f4:	00e79863          	bne	a5,a4,304 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f8:	0505                	addi	a0,a0,1
    p2++;
 2fa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2fc:	fed518e3          	bne	a0,a3,2ec <memcmp+0x14>
  }
  return 0;
 300:	4501                	li	a0,0
 302:	a019                	j	308 <memcmp+0x30>
      return *p1 - *p2;
 304:	40e7853b          	subw	a0,a5,a4
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret
  return 0;
 30e:	4501                	li	a0,0
 310:	bfe5                	j	308 <memcmp+0x30>

0000000000000312 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 312:	1141                	addi	sp,sp,-16
 314:	e406                	sd	ra,8(sp)
 316:	e022                	sd	s0,0(sp)
 318:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 31a:	f67ff0ef          	jal	280 <memmove>
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret

0000000000000326 <sbrk>:

char *
sbrk(int n) {
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 32e:	4585                	li	a1,1
 330:	0d2000ef          	jal	402 <sys_sbrk>
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <sbrklazy>:

char *
sbrklazy(int n) {
 33c:	1141                	addi	sp,sp,-16
 33e:	e406                	sd	ra,8(sp)
 340:	e022                	sd	s0,0(sp)
 342:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 344:	4589                	li	a1,2
 346:	0bc000ef          	jal	402 <sys_sbrk>
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret

0000000000000352 <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 352:	48e5                	li	a7,25
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 35a:	48e1                	li	a7,24
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 362:	48dd                	li	a7,23
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <trace>:
.global trace
trace:
 li a7, SYS_trace
 36a:	48d9                	li	a7,22
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <fork>:
.global fork
fork:
 li a7, SYS_fork
 372:	4885                	li	a7,1
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exit>:
.global exit
exit:
 li a7, SYS_exit
 37a:	4889                	li	a7,2
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <wait>:
.global wait
wait:
 li a7, SYS_wait
 382:	488d                	li	a7,3
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38a:	4891                	li	a7,4
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <read>:
.global read
read:
 li a7, SYS_read
 392:	4895                	li	a7,5
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <write>:
.global write
write:
 li a7, SYS_write
 39a:	48c1                	li	a7,16
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <close>:
.global close
close:
 li a7, SYS_close
 3a2:	48d5                	li	a7,21
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 3aa:	4899                	li	a7,6
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b2:	489d                	li	a7,7
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <open>:
.global open
open:
 li a7, SYS_open
 3ba:	48bd                	li	a7,15
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c2:	48c5                	li	a7,17
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ca:	48c9                	li	a7,18
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d2:	48a1                	li	a7,8
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <link>:
.global link
link:
 li a7, SYS_link
 3da:	48cd                	li	a7,19
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e2:	48d1                	li	a7,20
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ea:	48a5                	li	a7,9
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f2:	48a9                	li	a7,10
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fa:	48ad                	li	a7,11
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 402:	48b1                	li	a7,12
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <pause>:
.global pause
pause:
 li a7, SYS_pause
 40a:	48b5                	li	a7,13
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 412:	48b9                	li	a7,14
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 41a:	1101                	addi	sp,sp,-32
 41c:	ec06                	sd	ra,24(sp)
 41e:	e822                	sd	s0,16(sp)
 420:	1000                	addi	s0,sp,32
 422:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 426:	4605                	li	a2,1
 428:	fef40593          	addi	a1,s0,-17
 42c:	f6fff0ef          	jal	39a <write>
}
 430:	60e2                	ld	ra,24(sp)
 432:	6442                	ld	s0,16(sp)
 434:	6105                	addi	sp,sp,32
 436:	8082                	ret

0000000000000438 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 438:	715d                	addi	sp,sp,-80
 43a:	e486                	sd	ra,72(sp)
 43c:	e0a2                	sd	s0,64(sp)
 43e:	fc26                	sd	s1,56(sp)
 440:	0880                	addi	s0,sp,80
 442:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 444:	c299                	beqz	a3,44a <printint+0x12>
 446:	0805c963          	bltz	a1,4d8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 44a:	2581                	sext.w	a1,a1
  neg = 0;
 44c:	4881                	li	a7,0
 44e:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 452:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 454:	2601                	sext.w	a2,a2
 456:	00000517          	auipc	a0,0x0
 45a:	5aa50513          	addi	a0,a0,1450 # a00 <digits>
 45e:	883a                	mv	a6,a4
 460:	2705                	addiw	a4,a4,1
 462:	02c5f7bb          	remuw	a5,a1,a2
 466:	1782                	slli	a5,a5,0x20
 468:	9381                	srli	a5,a5,0x20
 46a:	97aa                	add	a5,a5,a0
 46c:	0007c783          	lbu	a5,0(a5)
 470:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 474:	0005879b          	sext.w	a5,a1
 478:	02c5d5bb          	divuw	a1,a1,a2
 47c:	0685                	addi	a3,a3,1
 47e:	fec7f0e3          	bgeu	a5,a2,45e <printint+0x26>
  if(neg)
 482:	00088c63          	beqz	a7,49a <printint+0x62>
    buf[i++] = '-';
 486:	fd070793          	addi	a5,a4,-48
 48a:	00878733          	add	a4,a5,s0
 48e:	02d00793          	li	a5,45
 492:	fef70423          	sb	a5,-24(a4)
 496:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 49a:	02e05a63          	blez	a4,4ce <printint+0x96>
 49e:	f84a                	sd	s2,48(sp)
 4a0:	f44e                	sd	s3,40(sp)
 4a2:	fb840793          	addi	a5,s0,-72
 4a6:	00e78933          	add	s2,a5,a4
 4aa:	fff78993          	addi	s3,a5,-1
 4ae:	99ba                	add	s3,s3,a4
 4b0:	377d                	addiw	a4,a4,-1
 4b2:	1702                	slli	a4,a4,0x20
 4b4:	9301                	srli	a4,a4,0x20
 4b6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ba:	fff94583          	lbu	a1,-1(s2)
 4be:	8526                	mv	a0,s1
 4c0:	f5bff0ef          	jal	41a <putc>
  while(--i >= 0)
 4c4:	197d                	addi	s2,s2,-1
 4c6:	ff391ae3          	bne	s2,s3,4ba <printint+0x82>
 4ca:	7942                	ld	s2,48(sp)
 4cc:	79a2                	ld	s3,40(sp)
}
 4ce:	60a6                	ld	ra,72(sp)
 4d0:	6406                	ld	s0,64(sp)
 4d2:	74e2                	ld	s1,56(sp)
 4d4:	6161                	addi	sp,sp,80
 4d6:	8082                	ret
    x = -xx;
 4d8:	40b005bb          	negw	a1,a1
    neg = 1;
 4dc:	4885                	li	a7,1
    x = -xx;
 4de:	bf85                	j	44e <printint+0x16>

00000000000004e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e0:	711d                	addi	sp,sp,-96
 4e2:	ec86                	sd	ra,88(sp)
 4e4:	e8a2                	sd	s0,80(sp)
 4e6:	e0ca                	sd	s2,64(sp)
 4e8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ea:	0005c903          	lbu	s2,0(a1)
 4ee:	28090663          	beqz	s2,77a <vprintf+0x29a>
 4f2:	e4a6                	sd	s1,72(sp)
 4f4:	fc4e                	sd	s3,56(sp)
 4f6:	f852                	sd	s4,48(sp)
 4f8:	f456                	sd	s5,40(sp)
 4fa:	f05a                	sd	s6,32(sp)
 4fc:	ec5e                	sd	s7,24(sp)
 4fe:	e862                	sd	s8,16(sp)
 500:	e466                	sd	s9,8(sp)
 502:	8b2a                	mv	s6,a0
 504:	8a2e                	mv	s4,a1
 506:	8bb2                	mv	s7,a2
  state = 0;
 508:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 50a:	4481                	li	s1,0
 50c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 50e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 512:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 516:	06c00c93          	li	s9,108
 51a:	a005                	j	53a <vprintf+0x5a>
        putc(fd, c0);
 51c:	85ca                	mv	a1,s2
 51e:	855a                	mv	a0,s6
 520:	efbff0ef          	jal	41a <putc>
 524:	a019                	j	52a <vprintf+0x4a>
    } else if(state == '%'){
 526:	03598263          	beq	s3,s5,54a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 52a:	2485                	addiw	s1,s1,1
 52c:	8726                	mv	a4,s1
 52e:	009a07b3          	add	a5,s4,s1
 532:	0007c903          	lbu	s2,0(a5)
 536:	22090a63          	beqz	s2,76a <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 53a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 53e:	fe0994e3          	bnez	s3,526 <vprintf+0x46>
      if(c0 == '%'){
 542:	fd579de3          	bne	a5,s5,51c <vprintf+0x3c>
        state = '%';
 546:	89be                	mv	s3,a5
 548:	b7cd                	j	52a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 54a:	00ea06b3          	add	a3,s4,a4
 54e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 552:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 554:	c681                	beqz	a3,55c <vprintf+0x7c>
 556:	9752                	add	a4,a4,s4
 558:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 55c:	05878363          	beq	a5,s8,5a2 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 560:	05978d63          	beq	a5,s9,5ba <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 564:	07500713          	li	a4,117
 568:	0ee78763          	beq	a5,a4,656 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 56c:	07800713          	li	a4,120
 570:	12e78963          	beq	a5,a4,6a2 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 574:	07000713          	li	a4,112
 578:	14e78e63          	beq	a5,a4,6d4 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 57c:	06300713          	li	a4,99
 580:	18e78e63          	beq	a5,a4,71c <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 584:	07300713          	li	a4,115
 588:	1ae78463          	beq	a5,a4,730 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 58c:	02500713          	li	a4,37
 590:	04e79563          	bne	a5,a4,5da <vprintf+0xfa>
        putc(fd, '%');
 594:	02500593          	li	a1,37
 598:	855a                	mv	a0,s6
 59a:	e81ff0ef          	jal	41a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 59e:	4981                	li	s3,0
 5a0:	b769                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	e89ff0ef          	jal	438 <printint>
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	bf8d                	j	52a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ba:	06400793          	li	a5,100
 5be:	02f68963          	beq	a3,a5,5f0 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5c2:	06c00793          	li	a5,108
 5c6:	04f68263          	beq	a3,a5,60a <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 5ca:	07500793          	li	a5,117
 5ce:	0af68063          	beq	a3,a5,66e <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 5d2:	07800793          	li	a5,120
 5d6:	0ef68263          	beq	a3,a5,6ba <vprintf+0x1da>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	855a                	mv	a0,s6
 5e0:	e3bff0ef          	jal	41a <putc>
        putc(fd, c0);
 5e4:	85ca                	mv	a1,s2
 5e6:	855a                	mv	a0,s6
 5e8:	e33ff0ef          	jal	41a <putc>
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	bf35                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e3bff0ef          	jal	438 <printint>
        i += 1;
 602:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
        i += 1;
 608:	b70d                	j	52a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 60a:	06400793          	li	a5,100
 60e:	02f60763          	beq	a2,a5,63c <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 612:	07500793          	li	a5,117
 616:	06f60963          	beq	a2,a5,688 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 61a:	07800793          	li	a5,120
 61e:	faf61ee3          	bne	a2,a5,5da <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e09ff0ef          	jal	438 <printint>
        i += 2;
 634:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	bdc5                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63c:	008b8913          	addi	s2,s7,8
 640:	4685                	li	a3,1
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	defff0ef          	jal	438 <printint>
        i += 2;
 64e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bdd9                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	dd5ff0ef          	jal	438 <printint>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bd7d                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dbdff0ef          	jal	438 <printint>
        i += 1;
 680:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 1;
 686:	b555                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 688:	008b8913          	addi	s2,s7,8
 68c:	4681                	li	a3,0
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	da3ff0ef          	jal	438 <printint>
        i += 2;
 69a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b569                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6a2:	008b8913          	addi	s2,s7,8
 6a6:	4681                	li	a3,0
 6a8:	4641                	li	a2,16
 6aa:	000be583          	lwu	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	d89ff0ef          	jal	438 <printint>
 6b4:	8bca                	mv	s7,s2
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	bd8d                	j	52a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	d71ff0ef          	jal	438 <printint>
        i += 1;
 6cc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 1;
 6d2:	bda1                	j	52a <vprintf+0x4a>
 6d4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6d6:	008b8d13          	addi	s10,s7,8
 6da:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6de:	03000593          	li	a1,48
 6e2:	855a                	mv	a0,s6
 6e4:	d37ff0ef          	jal	41a <putc>
  putc(fd, 'x');
 6e8:	07800593          	li	a1,120
 6ec:	855a                	mv	a0,s6
 6ee:	d2dff0ef          	jal	41a <putc>
 6f2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f4:	00000b97          	auipc	s7,0x0
 6f8:	30cb8b93          	addi	s7,s7,780 # a00 <digits>
 6fc:	03c9d793          	srli	a5,s3,0x3c
 700:	97de                	add	a5,a5,s7
 702:	0007c583          	lbu	a1,0(a5)
 706:	855a                	mv	a0,s6
 708:	d13ff0ef          	jal	41a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 70c:	0992                	slli	s3,s3,0x4
 70e:	397d                	addiw	s2,s2,-1
 710:	fe0916e3          	bnez	s2,6fc <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 714:	8bea                	mv	s7,s10
      state = 0;
 716:	4981                	li	s3,0
 718:	6d02                	ld	s10,0(sp)
 71a:	bd01                	j	52a <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 71c:	008b8913          	addi	s2,s7,8
 720:	000bc583          	lbu	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	cf5ff0ef          	jal	41a <putc>
 72a:	8bca                	mv	s7,s2
      state = 0;
 72c:	4981                	li	s3,0
 72e:	bbf5                	j	52a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 730:	008b8993          	addi	s3,s7,8
 734:	000bb903          	ld	s2,0(s7)
 738:	00090f63          	beqz	s2,756 <vprintf+0x276>
        for(; *s; s++)
 73c:	00094583          	lbu	a1,0(s2)
 740:	c195                	beqz	a1,764 <vprintf+0x284>
          putc(fd, *s);
 742:	855a                	mv	a0,s6
 744:	cd7ff0ef          	jal	41a <putc>
        for(; *s; s++)
 748:	0905                	addi	s2,s2,1
 74a:	00094583          	lbu	a1,0(s2)
 74e:	f9f5                	bnez	a1,742 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 750:	8bce                	mv	s7,s3
      state = 0;
 752:	4981                	li	s3,0
 754:	bbd9                	j	52a <vprintf+0x4a>
          s = "(null)";
 756:	00000917          	auipc	s2,0x0
 75a:	2a290913          	addi	s2,s2,674 # 9f8 <malloc+0x196>
        for(; *s; s++)
 75e:	02800593          	li	a1,40
 762:	b7c5                	j	742 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 764:	8bce                	mv	s7,s3
      state = 0;
 766:	4981                	li	s3,0
 768:	b3c9                	j	52a <vprintf+0x4a>
 76a:	64a6                	ld	s1,72(sp)
 76c:	79e2                	ld	s3,56(sp)
 76e:	7a42                	ld	s4,48(sp)
 770:	7aa2                	ld	s5,40(sp)
 772:	7b02                	ld	s6,32(sp)
 774:	6be2                	ld	s7,24(sp)
 776:	6c42                	ld	s8,16(sp)
 778:	6ca2                	ld	s9,8(sp)
    }
  }
}
 77a:	60e6                	ld	ra,88(sp)
 77c:	6446                	ld	s0,80(sp)
 77e:	6906                	ld	s2,64(sp)
 780:	6125                	addi	sp,sp,96
 782:	8082                	ret

0000000000000784 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 784:	715d                	addi	sp,sp,-80
 786:	ec06                	sd	ra,24(sp)
 788:	e822                	sd	s0,16(sp)
 78a:	1000                	addi	s0,sp,32
 78c:	e010                	sd	a2,0(s0)
 78e:	e414                	sd	a3,8(s0)
 790:	e818                	sd	a4,16(s0)
 792:	ec1c                	sd	a5,24(s0)
 794:	03043023          	sd	a6,32(s0)
 798:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a0:	8622                	mv	a2,s0
 7a2:	d3fff0ef          	jal	4e0 <vprintf>
}
 7a6:	60e2                	ld	ra,24(sp)
 7a8:	6442                	ld	s0,16(sp)
 7aa:	6161                	addi	sp,sp,80
 7ac:	8082                	ret

00000000000007ae <printf>:

void
printf(const char *fmt, ...)
{
 7ae:	711d                	addi	sp,sp,-96
 7b0:	ec06                	sd	ra,24(sp)
 7b2:	e822                	sd	s0,16(sp)
 7b4:	1000                	addi	s0,sp,32
 7b6:	e40c                	sd	a1,8(s0)
 7b8:	e810                	sd	a2,16(s0)
 7ba:	ec14                	sd	a3,24(s0)
 7bc:	f018                	sd	a4,32(s0)
 7be:	f41c                	sd	a5,40(s0)
 7c0:	03043823          	sd	a6,48(s0)
 7c4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c8:	00840613          	addi	a2,s0,8
 7cc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d0:	85aa                	mv	a1,a0
 7d2:	4505                	li	a0,1
 7d4:	d0dff0ef          	jal	4e0 <vprintf>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6125                	addi	sp,sp,96
 7de:	8082                	ret

00000000000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	1141                	addi	sp,sp,-16
 7e2:	e422                	sd	s0,8(sp)
 7e4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	00001797          	auipc	a5,0x1
 7ee:	8167b783          	ld	a5,-2026(a5) # 1000 <freep>
 7f2:	a02d                	j	81c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f4:	4618                	lw	a4,8(a2)
 7f6:	9f2d                	addw	a4,a4,a1
 7f8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	6398                	ld	a4,0(a5)
 7fe:	6310                	ld	a2,0(a4)
 800:	a83d                	j	83e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 802:	ff852703          	lw	a4,-8(a0)
 806:	9f31                	addw	a4,a4,a2
 808:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 80a:	ff053683          	ld	a3,-16(a0)
 80e:	a091                	j	852 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	6398                	ld	a4,0(a5)
 812:	00e7e463          	bltu	a5,a4,81a <free+0x3a>
 816:	00e6ea63          	bltu	a3,a4,82a <free+0x4a>
{
 81a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81c:	fed7fae3          	bgeu	a5,a3,810 <free+0x30>
 820:	6398                	ld	a4,0(a5)
 822:	00e6e463          	bltu	a3,a4,82a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	fee7eae3          	bltu	a5,a4,81a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 82a:	ff852583          	lw	a1,-8(a0)
 82e:	6390                	ld	a2,0(a5)
 830:	02059813          	slli	a6,a1,0x20
 834:	01c85713          	srli	a4,a6,0x1c
 838:	9736                	add	a4,a4,a3
 83a:	fae60de3          	beq	a2,a4,7f4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 83e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 842:	4790                	lw	a2,8(a5)
 844:	02061593          	slli	a1,a2,0x20
 848:	01c5d713          	srli	a4,a1,0x1c
 84c:	973e                	add	a4,a4,a5
 84e:	fae68ae3          	beq	a3,a4,802 <free+0x22>
    p->s.ptr = bp->s.ptr;
 852:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 854:	00000717          	auipc	a4,0x0
 858:	7af73623          	sd	a5,1964(a4) # 1000 <freep>
}
 85c:	6422                	ld	s0,8(sp)
 85e:	0141                	addi	sp,sp,16
 860:	8082                	ret

0000000000000862 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 862:	7139                	addi	sp,sp,-64
 864:	fc06                	sd	ra,56(sp)
 866:	f822                	sd	s0,48(sp)
 868:	f426                	sd	s1,40(sp)
 86a:	ec4e                	sd	s3,24(sp)
 86c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86e:	02051493          	slli	s1,a0,0x20
 872:	9081                	srli	s1,s1,0x20
 874:	04bd                	addi	s1,s1,15
 876:	8091                	srli	s1,s1,0x4
 878:	0014899b          	addiw	s3,s1,1
 87c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87e:	00000517          	auipc	a0,0x0
 882:	78253503          	ld	a0,1922(a0) # 1000 <freep>
 886:	c915                	beqz	a0,8ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88a:	4798                	lw	a4,8(a5)
 88c:	08977a63          	bgeu	a4,s1,920 <malloc+0xbe>
 890:	f04a                	sd	s2,32(sp)
 892:	e852                	sd	s4,16(sp)
 894:	e456                	sd	s5,8(sp)
 896:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 898:	8a4e                	mv	s4,s3
 89a:	0009871b          	sext.w	a4,s3
 89e:	6685                	lui	a3,0x1
 8a0:	00d77363          	bgeu	a4,a3,8a6 <malloc+0x44>
 8a4:	6a05                	lui	s4,0x1
 8a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ae:	00000917          	auipc	s2,0x0
 8b2:	75290913          	addi	s2,s2,1874 # 1000 <freep>
  if(p == SBRK_ERROR)
 8b6:	5afd                	li	s5,-1
 8b8:	a081                	j	8f8 <malloc+0x96>
 8ba:	f04a                	sd	s2,32(sp)
 8bc:	e852                	sd	s4,16(sp)
 8be:	e456                	sd	s5,8(sp)
 8c0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8c2:	00001797          	auipc	a5,0x1
 8c6:	94678793          	addi	a5,a5,-1722 # 1208 <base>
 8ca:	00000717          	auipc	a4,0x0
 8ce:	72f73b23          	sd	a5,1846(a4) # 1000 <freep>
 8d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d8:	b7c1                	j	898 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	e118                	sd	a4,0(a0)
 8de:	a8a9                	j	938 <malloc+0xd6>
  hp->s.size = nu;
 8e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e4:	0541                	addi	a0,a0,16
 8e6:	efbff0ef          	jal	7e0 <free>
  return freep;
 8ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ee:	c12d                	beqz	a0,950 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	02977263          	bgeu	a4,s1,918 <malloc+0xb6>
    if(p == freep)
 8f8:	00093703          	ld	a4,0(s2)
 8fc:	853e                	mv	a0,a5
 8fe:	fef719e3          	bne	a4,a5,8f0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 902:	8552                	mv	a0,s4
 904:	a23ff0ef          	jal	326 <sbrk>
  if(p == SBRK_ERROR)
 908:	fd551ce3          	bne	a0,s5,8e0 <malloc+0x7e>
        return 0;
 90c:	4501                	li	a0,0
 90e:	7902                	ld	s2,32(sp)
 910:	6a42                	ld	s4,16(sp)
 912:	6aa2                	ld	s5,8(sp)
 914:	6b02                	ld	s6,0(sp)
 916:	a03d                	j	944 <malloc+0xe2>
 918:	7902                	ld	s2,32(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 920:	fae48de3          	beq	s1,a4,8da <malloc+0x78>
        p->s.size -= nunits;
 924:	4137073b          	subw	a4,a4,s3
 928:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92a:	02071693          	slli	a3,a4,0x20
 92e:	01c6d713          	srli	a4,a3,0x1c
 932:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 934:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 938:	00000717          	auipc	a4,0x0
 93c:	6ca73423          	sd	a0,1736(a4) # 1000 <freep>
      return (void*)(p + 1);
 940:	01078513          	addi	a0,a5,16
  }
}
 944:	70e2                	ld	ra,56(sp)
 946:	7442                	ld	s0,48(sp)
 948:	74a2                	ld	s1,40(sp)
 94a:	69e2                	ld	s3,24(sp)
 94c:	6121                	addi	sp,sp,64
 94e:	8082                	ret
 950:	7902                	ld	s2,32(sp)
 952:	6a42                	ld	s4,16(sp)
 954:	6aa2                	ld	s5,8(sp)
 956:	6b02                	ld	s6,0(sp)
 958:	b7f5                	j	944 <malloc+0xe2>
