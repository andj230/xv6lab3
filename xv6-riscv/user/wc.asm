
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	addi	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	9c8a0a13          	addi	s4,s4,-1592 # a00 <malloc+0x106>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a035                	j	6e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	1bc000ef          	jal	202 <strchr>
  4a:	c919                	beqz	a0,60 <wc+0x60>
        inword = 0;
  4c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  4e:	0485                	addi	s1,s1,1
  50:	01348d63          	beq	s1,s3,6a <wc+0x6a>
      if(buf[i] == '\n')
  54:	0004c583          	lbu	a1,0(s1)
  58:	ff5596e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  5c:	2c05                	addiw	s8,s8,1
  5e:	b7dd                	j	44 <wc+0x44>
      else if(!inword){
  60:	fe0917e3          	bnez	s2,4e <wc+0x4e>
        w++;
  64:	2c85                	addiw	s9,s9,1
        inword = 1;
  66:	4905                	li	s2,1
  68:	b7dd                	j	4e <wc+0x4e>
  6a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  6e:	20000613          	li	a2,512
  72:	85ee                	mv	a1,s11
  74:	f8843503          	ld	a0,-120(s0)
  78:	3b2000ef          	jal	42a <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
    for(i=0; i<n; i++){
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009509b3          	add	s3,a0,s1
  8e:	b7d9                	j	54 <wc+0x54>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86ea                	mv	a3,s10
  9a:	8666                	mv	a2,s9
  9c:	85e2                	mv	a1,s8
  9e:	00001517          	auipc	a0,0x1
  a2:	98250513          	addi	a0,a0,-1662 # a20 <malloc+0x126>
  a6:	7a0000ef          	jal	846 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	94850513          	addi	a0,a0,-1720 # a10 <malloc+0x116>
  d0:	776000ef          	jal	846 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	33c000ef          	jal	412 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	34a000ef          	jal	452 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	31e000ef          	jal	43a <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ea000ef          	jal	412 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	8d658593          	addi	a1,a1,-1834 # a08 <malloc+0x10e>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d0000ef          	jal	412 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	8e650513          	addi	a0,a0,-1818 # a30 <malloc+0x136>
 152:	6f4000ef          	jal	846 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2ba000ef          	jal	412 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  extern int main();
  main();
 164:	f77ff0ef          	jal	da <main>
  exit(0);
 168:	4501                	li	a0,0
 16a:	2a8000ef          	jal	412 <exit>

000000000000016e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0x8>
    ;
  return os;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret

000000000000018a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18a:	1141                	addi	sp,sp,-16
 18c:	e422                	sd	s0,8(sp)
 18e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	cb91                	beqz	a5,1a8 <strcmp+0x1e>
 196:	0005c703          	lbu	a4,0(a1)
 19a:	00f71763          	bne	a4,a5,1a8 <strcmp+0x1e>
    p++, q++;
 19e:	0505                	addi	a0,a0,1
 1a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbe5                	bnez	a5,196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1a8:	0005c503          	lbu	a0,0(a1)
}
 1ac:	40a7853b          	subw	a0,a5,a0
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strlen>:

uint
strlen(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf91                	beqz	a5,1dc <strlen+0x26>
 1c2:	0505                	addi	a0,a0,1
 1c4:	87aa                	mv	a5,a0
 1c6:	86be                	mv	a3,a5
 1c8:	0785                	addi	a5,a5,1
 1ca:	fff7c703          	lbu	a4,-1(a5)
 1ce:	ff65                	bnez	a4,1c6 <strlen+0x10>
 1d0:	40a6853b          	subw	a0,a3,a0
 1d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1d6:	6422                	ld	s0,8(sp)
 1d8:	0141                	addi	sp,sp,16
 1da:	8082                	ret
  for(n = 0; s[n]; n++)
 1dc:	4501                	li	a0,0
 1de:	bfe5                	j	1d6 <strlen+0x20>

00000000000001e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e0:	1141                	addi	sp,sp,-16
 1e2:	e422                	sd	s0,8(sp)
 1e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e6:	ca19                	beqz	a2,1fc <memset+0x1c>
 1e8:	87aa                	mv	a5,a0
 1ea:	1602                	slli	a2,a2,0x20
 1ec:	9201                	srli	a2,a2,0x20
 1ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f6:	0785                	addi	a5,a5,1
 1f8:	fee79de3          	bne	a5,a4,1f2 <memset+0x12>
  }
  return dst;
}
 1fc:	6422                	ld	s0,8(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strchr>:

char*
strchr(const char *s, char c)
{
 202:	1141                	addi	sp,sp,-16
 204:	e422                	sd	s0,8(sp)
 206:	0800                	addi	s0,sp,16
  for(; *s; s++)
 208:	00054783          	lbu	a5,0(a0)
 20c:	cb99                	beqz	a5,222 <strchr+0x20>
    if(*s == c)
 20e:	00f58763          	beq	a1,a5,21c <strchr+0x1a>
  for(; *s; s++)
 212:	0505                	addi	a0,a0,1
 214:	00054783          	lbu	a5,0(a0)
 218:	fbfd                	bnez	a5,20e <strchr+0xc>
      return (char*)s;
  return 0;
 21a:	4501                	li	a0,0
}
 21c:	6422                	ld	s0,8(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  return 0;
 222:	4501                	li	a0,0
 224:	bfe5                	j	21c <strchr+0x1a>

0000000000000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	711d                	addi	sp,sp,-96
 228:	ec86                	sd	ra,88(sp)
 22a:	e8a2                	sd	s0,80(sp)
 22c:	e4a6                	sd	s1,72(sp)
 22e:	e0ca                	sd	s2,64(sp)
 230:	fc4e                	sd	s3,56(sp)
 232:	f852                	sd	s4,48(sp)
 234:	f456                	sd	s5,40(sp)
 236:	f05a                	sd	s6,32(sp)
 238:	ec5e                	sd	s7,24(sp)
 23a:	1080                	addi	s0,sp,96
 23c:	8baa                	mv	s7,a0
 23e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 240:	892a                	mv	s2,a0
 242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 244:	4aa9                	li	s5,10
 246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 248:	89a6                	mv	s3,s1
 24a:	2485                	addiw	s1,s1,1
 24c:	0344d663          	bge	s1,s4,278 <gets+0x52>
    cc = read(0, &c, 1);
 250:	4605                	li	a2,1
 252:	faf40593          	addi	a1,s0,-81
 256:	4501                	li	a0,0
 258:	1d2000ef          	jal	42a <read>
    if(cc < 1)
 25c:	00a05e63          	blez	a0,278 <gets+0x52>
    buf[i++] = c;
 260:	faf44783          	lbu	a5,-81(s0)
 264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 268:	01578763          	beq	a5,s5,276 <gets+0x50>
 26c:	0905                	addi	s2,s2,1
 26e:	fd679de3          	bne	a5,s6,248 <gets+0x22>
    buf[i++] = c;
 272:	89a6                	mv	s3,s1
 274:	a011                	j	278 <gets+0x52>
 276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 278:	99de                	add	s3,s3,s7
 27a:	00098023          	sb	zero,0(s3)
  return buf;
}
 27e:	855e                	mv	a0,s7
 280:	60e6                	ld	ra,88(sp)
 282:	6446                	ld	s0,80(sp)
 284:	64a6                	ld	s1,72(sp)
 286:	6906                	ld	s2,64(sp)
 288:	79e2                	ld	s3,56(sp)
 28a:	7a42                	ld	s4,48(sp)
 28c:	7aa2                	ld	s5,40(sp)
 28e:	7b02                	ld	s6,32(sp)
 290:	6be2                	ld	s7,24(sp)
 292:	6125                	addi	sp,sp,96
 294:	8082                	ret

0000000000000296 <stat>:

int
stat(const char *n, struct stat *st)
{
 296:	1101                	addi	sp,sp,-32
 298:	ec06                	sd	ra,24(sp)
 29a:	e822                	sd	s0,16(sp)
 29c:	e04a                	sd	s2,0(sp)
 29e:	1000                	addi	s0,sp,32
 2a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	4581                	li	a1,0
 2a4:	1ae000ef          	jal	452 <open>
  if(fd < 0)
 2a8:	02054263          	bltz	a0,2cc <stat+0x36>
 2ac:	e426                	sd	s1,8(sp)
 2ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2b0:	85ca                	mv	a1,s2
 2b2:	1b8000ef          	jal	46a <fstat>
 2b6:	892a                	mv	s2,a0
  close(fd);
 2b8:	8526                	mv	a0,s1
 2ba:	180000ef          	jal	43a <close>
  return r;
 2be:	64a2                	ld	s1,8(sp)
}
 2c0:	854a                	mv	a0,s2
 2c2:	60e2                	ld	ra,24(sp)
 2c4:	6442                	ld	s0,16(sp)
 2c6:	6902                	ld	s2,0(sp)
 2c8:	6105                	addi	sp,sp,32
 2ca:	8082                	ret
    return -1;
 2cc:	597d                	li	s2,-1
 2ce:	bfcd                	j	2c0 <stat+0x2a>

00000000000002d0 <atoi>:

int
atoi(const char *s)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2d6:	00054683          	lbu	a3,0(a0)
 2da:	fd06879b          	addiw	a5,a3,-48
 2de:	0ff7f793          	zext.b	a5,a5
 2e2:	4625                	li	a2,9
 2e4:	02f66863          	bltu	a2,a5,314 <atoi+0x44>
 2e8:	872a                	mv	a4,a0
  n = 0;
 2ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ec:	0705                	addi	a4,a4,1
 2ee:	0025179b          	slliw	a5,a0,0x2
 2f2:	9fa9                	addw	a5,a5,a0
 2f4:	0017979b          	slliw	a5,a5,0x1
 2f8:	9fb5                	addw	a5,a5,a3
 2fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2fe:	00074683          	lbu	a3,0(a4)
 302:	fd06879b          	addiw	a5,a3,-48
 306:	0ff7f793          	zext.b	a5,a5
 30a:	fef671e3          	bgeu	a2,a5,2ec <atoi+0x1c>
  return n;
}
 30e:	6422                	ld	s0,8(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret
  n = 0;
 314:	4501                	li	a0,0
 316:	bfe5                	j	30e <atoi+0x3e>

0000000000000318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 318:	1141                	addi	sp,sp,-16
 31a:	e422                	sd	s0,8(sp)
 31c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 31e:	02b57463          	bgeu	a0,a1,346 <memmove+0x2e>
    while(n-- > 0)
 322:	00c05f63          	blez	a2,340 <memmove+0x28>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 32e:	872a                	mv	a4,a0
      *dst++ = *src++;
 330:	0585                	addi	a1,a1,1
 332:	0705                	addi	a4,a4,1
 334:	fff5c683          	lbu	a3,-1(a1)
 338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 33c:	fef71ae3          	bne	a4,a5,330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
    dst += n;
 346:	00c50733          	add	a4,a0,a2
    src += n;
 34a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 34c:	fec05ae3          	blez	a2,340 <memmove+0x28>
 350:	fff6079b          	addiw	a5,a2,-1
 354:	1782                	slli	a5,a5,0x20
 356:	9381                	srli	a5,a5,0x20
 358:	fff7c793          	not	a5,a5
 35c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 35e:	15fd                	addi	a1,a1,-1
 360:	177d                	addi	a4,a4,-1
 362:	0005c683          	lbu	a3,0(a1)
 366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 36a:	fee79ae3          	bne	a5,a4,35e <memmove+0x46>
 36e:	bfc9                	j	340 <memmove+0x28>

0000000000000370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e422                	sd	s0,8(sp)
 374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 376:	ca05                	beqz	a2,3a6 <memcmp+0x36>
 378:	fff6069b          	addiw	a3,a2,-1
 37c:	1682                	slli	a3,a3,0x20
 37e:	9281                	srli	a3,a3,0x20
 380:	0685                	addi	a3,a3,1
 382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 384:	00054783          	lbu	a5,0(a0)
 388:	0005c703          	lbu	a4,0(a1)
 38c:	00e79863          	bne	a5,a4,39c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 390:	0505                	addi	a0,a0,1
    p2++;
 392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 394:	fed518e3          	bne	a0,a3,384 <memcmp+0x14>
  }
  return 0;
 398:	4501                	li	a0,0
 39a:	a019                	j	3a0 <memcmp+0x30>
      return *p1 - *p2;
 39c:	40e7853b          	subw	a0,a5,a4
}
 3a0:	6422                	ld	s0,8(sp)
 3a2:	0141                	addi	sp,sp,16
 3a4:	8082                	ret
  return 0;
 3a6:	4501                	li	a0,0
 3a8:	bfe5                	j	3a0 <memcmp+0x30>

00000000000003aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3aa:	1141                	addi	sp,sp,-16
 3ac:	e406                	sd	ra,8(sp)
 3ae:	e022                	sd	s0,0(sp)
 3b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3b2:	f67ff0ef          	jal	318 <memmove>
}
 3b6:	60a2                	ld	ra,8(sp)
 3b8:	6402                	ld	s0,0(sp)
 3ba:	0141                	addi	sp,sp,16
 3bc:	8082                	ret

00000000000003be <sbrk>:

char *
sbrk(int n) {
 3be:	1141                	addi	sp,sp,-16
 3c0:	e406                	sd	ra,8(sp)
 3c2:	e022                	sd	s0,0(sp)
 3c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3c6:	4585                	li	a1,1
 3c8:	0d2000ef          	jal	49a <sys_sbrk>
}
 3cc:	60a2                	ld	ra,8(sp)
 3ce:	6402                	ld	s0,0(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret

00000000000003d4 <sbrklazy>:

char *
sbrklazy(int n) {
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3dc:	4589                	li	a1,2
 3de:	0bc000ef          	jal	49a <sys_sbrk>
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret

00000000000003ea <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 3ea:	48e5                	li	a7,25
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 3f2:	48e1                	li	a7,24
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 3fa:	48dd                	li	a7,23
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <trace>:
.global trace
trace:
 li a7, SYS_trace
 402:	48d9                	li	a7,22
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <fork>:
.global fork
fork:
 li a7, SYS_fork
 40a:	4885                	li	a7,1
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exit>:
.global exit
exit:
 li a7, SYS_exit
 412:	4889                	li	a7,2
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <wait>:
.global wait
wait:
 li a7, SYS_wait
 41a:	488d                	li	a7,3
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 422:	4891                	li	a7,4
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <read>:
.global read
read:
 li a7, SYS_read
 42a:	4895                	li	a7,5
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <write>:
.global write
write:
 li a7, SYS_write
 432:	48c1                	li	a7,16
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <close>:
.global close
close:
 li a7, SYS_close
 43a:	48d5                	li	a7,21
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <kill>:
.global kill
kill:
 li a7, SYS_kill
 442:	4899                	li	a7,6
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exec>:
.global exec
exec:
 li a7, SYS_exec
 44a:	489d                	li	a7,7
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <open>:
.global open
open:
 li a7, SYS_open
 452:	48bd                	li	a7,15
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45a:	48c5                	li	a7,17
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 462:	48c9                	li	a7,18
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46a:	48a1                	li	a7,8
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <link>:
.global link
link:
 li a7, SYS_link
 472:	48cd                	li	a7,19
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47a:	48d1                	li	a7,20
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 482:	48a5                	li	a7,9
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <dup>:
.global dup
dup:
 li a7, SYS_dup
 48a:	48a9                	li	a7,10
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 492:	48ad                	li	a7,11
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 49a:	48b1                	li	a7,12
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4a2:	48b5                	li	a7,13
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4aa:	48b9                	li	a7,14
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b2:	1101                	addi	sp,sp,-32
 4b4:	ec06                	sd	ra,24(sp)
 4b6:	e822                	sd	s0,16(sp)
 4b8:	1000                	addi	s0,sp,32
 4ba:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4be:	4605                	li	a2,1
 4c0:	fef40593          	addi	a1,s0,-17
 4c4:	f6fff0ef          	jal	432 <write>
}
 4c8:	60e2                	ld	ra,24(sp)
 4ca:	6442                	ld	s0,16(sp)
 4cc:	6105                	addi	sp,sp,32
 4ce:	8082                	ret

00000000000004d0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4d0:	715d                	addi	sp,sp,-80
 4d2:	e486                	sd	ra,72(sp)
 4d4:	e0a2                	sd	s0,64(sp)
 4d6:	fc26                	sd	s1,56(sp)
 4d8:	0880                	addi	s0,sp,80
 4da:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4dc:	c299                	beqz	a3,4e2 <printint+0x12>
 4de:	0805c963          	bltz	a1,570 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e2:	2581                	sext.w	a1,a1
  neg = 0;
 4e4:	4881                	li	a7,0
 4e6:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 4ea:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ec:	2601                	sext.w	a2,a2
 4ee:	00000517          	auipc	a0,0x0
 4f2:	56250513          	addi	a0,a0,1378 # a50 <digits>
 4f6:	883a                	mv	a6,a4
 4f8:	2705                	addiw	a4,a4,1
 4fa:	02c5f7bb          	remuw	a5,a1,a2
 4fe:	1782                	slli	a5,a5,0x20
 500:	9381                	srli	a5,a5,0x20
 502:	97aa                	add	a5,a5,a0
 504:	0007c783          	lbu	a5,0(a5)
 508:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 50c:	0005879b          	sext.w	a5,a1
 510:	02c5d5bb          	divuw	a1,a1,a2
 514:	0685                	addi	a3,a3,1
 516:	fec7f0e3          	bgeu	a5,a2,4f6 <printint+0x26>
  if(neg)
 51a:	00088c63          	beqz	a7,532 <printint+0x62>
    buf[i++] = '-';
 51e:	fd070793          	addi	a5,a4,-48
 522:	00878733          	add	a4,a5,s0
 526:	02d00793          	li	a5,45
 52a:	fef70423          	sb	a5,-24(a4)
 52e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 532:	02e05a63          	blez	a4,566 <printint+0x96>
 536:	f84a                	sd	s2,48(sp)
 538:	f44e                	sd	s3,40(sp)
 53a:	fb840793          	addi	a5,s0,-72
 53e:	00e78933          	add	s2,a5,a4
 542:	fff78993          	addi	s3,a5,-1
 546:	99ba                	add	s3,s3,a4
 548:	377d                	addiw	a4,a4,-1
 54a:	1702                	slli	a4,a4,0x20
 54c:	9301                	srli	a4,a4,0x20
 54e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 552:	fff94583          	lbu	a1,-1(s2)
 556:	8526                	mv	a0,s1
 558:	f5bff0ef          	jal	4b2 <putc>
  while(--i >= 0)
 55c:	197d                	addi	s2,s2,-1
 55e:	ff391ae3          	bne	s2,s3,552 <printint+0x82>
 562:	7942                	ld	s2,48(sp)
 564:	79a2                	ld	s3,40(sp)
}
 566:	60a6                	ld	ra,72(sp)
 568:	6406                	ld	s0,64(sp)
 56a:	74e2                	ld	s1,56(sp)
 56c:	6161                	addi	sp,sp,80
 56e:	8082                	ret
    x = -xx;
 570:	40b005bb          	negw	a1,a1
    neg = 1;
 574:	4885                	li	a7,1
    x = -xx;
 576:	bf85                	j	4e6 <printint+0x16>

0000000000000578 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 578:	711d                	addi	sp,sp,-96
 57a:	ec86                	sd	ra,88(sp)
 57c:	e8a2                	sd	s0,80(sp)
 57e:	e0ca                	sd	s2,64(sp)
 580:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 582:	0005c903          	lbu	s2,0(a1)
 586:	28090663          	beqz	s2,812 <vprintf+0x29a>
 58a:	e4a6                	sd	s1,72(sp)
 58c:	fc4e                	sd	s3,56(sp)
 58e:	f852                	sd	s4,48(sp)
 590:	f456                	sd	s5,40(sp)
 592:	f05a                	sd	s6,32(sp)
 594:	ec5e                	sd	s7,24(sp)
 596:	e862                	sd	s8,16(sp)
 598:	e466                	sd	s9,8(sp)
 59a:	8b2a                	mv	s6,a0
 59c:	8a2e                	mv	s4,a1
 59e:	8bb2                	mv	s7,a2
  state = 0;
 5a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5a2:	4481                	li	s1,0
 5a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5aa:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ae:	06c00c93          	li	s9,108
 5b2:	a005                	j	5d2 <vprintf+0x5a>
        putc(fd, c0);
 5b4:	85ca                	mv	a1,s2
 5b6:	855a                	mv	a0,s6
 5b8:	efbff0ef          	jal	4b2 <putc>
 5bc:	a019                	j	5c2 <vprintf+0x4a>
    } else if(state == '%'){
 5be:	03598263          	beq	s3,s5,5e2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 5c2:	2485                	addiw	s1,s1,1
 5c4:	8726                	mv	a4,s1
 5c6:	009a07b3          	add	a5,s4,s1
 5ca:	0007c903          	lbu	s2,0(a5)
 5ce:	22090a63          	beqz	s2,802 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 5d2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d6:	fe0994e3          	bnez	s3,5be <vprintf+0x46>
      if(c0 == '%'){
 5da:	fd579de3          	bne	a5,s5,5b4 <vprintf+0x3c>
        state = '%';
 5de:	89be                	mv	s3,a5
 5e0:	b7cd                	j	5c2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5e2:	00ea06b3          	add	a3,s4,a4
 5e6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5ea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ec:	c681                	beqz	a3,5f4 <vprintf+0x7c>
 5ee:	9752                	add	a4,a4,s4
 5f0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5f4:	05878363          	beq	a5,s8,63a <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5f8:	05978d63          	beq	a5,s9,652 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5fc:	07500713          	li	a4,117
 600:	0ee78763          	beq	a5,a4,6ee <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 604:	07800713          	li	a4,120
 608:	12e78963          	beq	a5,a4,73a <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 60c:	07000713          	li	a4,112
 610:	14e78e63          	beq	a5,a4,76c <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 614:	06300713          	li	a4,99
 618:	18e78e63          	beq	a5,a4,7b4 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 61c:	07300713          	li	a4,115
 620:	1ae78463          	beq	a5,a4,7c8 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 624:	02500713          	li	a4,37
 628:	04e79563          	bne	a5,a4,672 <vprintf+0xfa>
        putc(fd, '%');
 62c:	02500593          	li	a1,37
 630:	855a                	mv	a0,s6
 632:	e81ff0ef          	jal	4b2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 636:	4981                	li	s3,0
 638:	b769                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 63a:	008b8913          	addi	s2,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000ba583          	lw	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e89ff0ef          	jal	4d0 <printint>
 64c:	8bca                	mv	s7,s2
      state = 0;
 64e:	4981                	li	s3,0
 650:	bf8d                	j	5c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 652:	06400793          	li	a5,100
 656:	02f68963          	beq	a3,a5,688 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 65a:	06c00793          	li	a5,108
 65e:	04f68263          	beq	a3,a5,6a2 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 662:	07500793          	li	a5,117
 666:	0af68063          	beq	a3,a5,706 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 66a:	07800793          	li	a5,120
 66e:	0ef68263          	beq	a3,a5,752 <vprintf+0x1da>
        putc(fd, '%');
 672:	02500593          	li	a1,37
 676:	855a                	mv	a0,s6
 678:	e3bff0ef          	jal	4b2 <putc>
        putc(fd, c0);
 67c:	85ca                	mv	a1,s2
 67e:	855a                	mv	a0,s6
 680:	e33ff0ef          	jal	4b2 <putc>
      state = 0;
 684:	4981                	li	s3,0
 686:	bf35                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 688:	008b8913          	addi	s2,s7,8
 68c:	4685                	li	a3,1
 68e:	4629                	li	a2,10
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	e3bff0ef          	jal	4d0 <printint>
        i += 1;
 69a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 69c:	8bca                	mv	s7,s2
      state = 0;
 69e:	4981                	li	s3,0
        i += 1;
 6a0:	b70d                	j	5c2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a2:	06400793          	li	a5,100
 6a6:	02f60763          	beq	a2,a5,6d4 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6aa:	07500793          	li	a5,117
 6ae:	06f60963          	beq	a2,a5,720 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b2:	07800793          	li	a5,120
 6b6:	faf61ee3          	bne	a2,a5,672 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ba:	008b8913          	addi	s2,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	e09ff0ef          	jal	4d0 <printint>
        i += 2;
 6cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ce:	8bca                	mv	s7,s2
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	bdc5                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d4:	008b8913          	addi	s2,s7,8
 6d8:	4685                	li	a3,1
 6da:	4629                	li	a2,10
 6dc:	000bb583          	ld	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	defff0ef          	jal	4d0 <printint>
        i += 2;
 6e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
        i += 2;
 6ec:	bdd9                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6ee:	008b8913          	addi	s2,s7,8
 6f2:	4681                	li	a3,0
 6f4:	4629                	li	a2,10
 6f6:	000be583          	lwu	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	dd5ff0ef          	jal	4d0 <printint>
 700:	8bca                	mv	s7,s2
      state = 0;
 702:	4981                	li	s3,0
 704:	bd7d                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	008b8913          	addi	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4629                	li	a2,10
 70e:	000bb583          	ld	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	dbdff0ef          	jal	4d0 <printint>
        i += 1;
 718:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	8bca                	mv	s7,s2
      state = 0;
 71c:	4981                	li	s3,0
        i += 1;
 71e:	b555                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 720:	008b8913          	addi	s2,s7,8
 724:	4681                	li	a3,0
 726:	4629                	li	a2,10
 728:	000bb583          	ld	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	da3ff0ef          	jal	4d0 <printint>
        i += 2;
 732:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 734:	8bca                	mv	s7,s2
      state = 0;
 736:	4981                	li	s3,0
        i += 2;
 738:	b569                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4681                	li	a3,0
 740:	4641                	li	a2,16
 742:	000be583          	lwu	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	d89ff0ef          	jal	4d0 <printint>
 74c:	8bca                	mv	s7,s2
      state = 0;
 74e:	4981                	li	s3,0
 750:	bd8d                	j	5c2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 752:	008b8913          	addi	s2,s7,8
 756:	4681                	li	a3,0
 758:	4641                	li	a2,16
 75a:	000bb583          	ld	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	d71ff0ef          	jal	4d0 <printint>
        i += 1;
 764:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	8bca                	mv	s7,s2
      state = 0;
 768:	4981                	li	s3,0
        i += 1;
 76a:	bda1                	j	5c2 <vprintf+0x4a>
 76c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 76e:	008b8d13          	addi	s10,s7,8
 772:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 776:	03000593          	li	a1,48
 77a:	855a                	mv	a0,s6
 77c:	d37ff0ef          	jal	4b2 <putc>
  putc(fd, 'x');
 780:	07800593          	li	a1,120
 784:	855a                	mv	a0,s6
 786:	d2dff0ef          	jal	4b2 <putc>
 78a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78c:	00000b97          	auipc	s7,0x0
 790:	2c4b8b93          	addi	s7,s7,708 # a50 <digits>
 794:	03c9d793          	srli	a5,s3,0x3c
 798:	97de                	add	a5,a5,s7
 79a:	0007c583          	lbu	a1,0(a5)
 79e:	855a                	mv	a0,s6
 7a0:	d13ff0ef          	jal	4b2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a4:	0992                	slli	s3,s3,0x4
 7a6:	397d                	addiw	s2,s2,-1
 7a8:	fe0916e3          	bnez	s2,794 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 7ac:	8bea                	mv	s7,s10
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	6d02                	ld	s10,0(sp)
 7b2:	bd01                	j	5c2 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	000bc583          	lbu	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	cf5ff0ef          	jal	4b2 <putc>
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	bbf5                	j	5c2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	008b8993          	addi	s3,s7,8
 7cc:	000bb903          	ld	s2,0(s7)
 7d0:	00090f63          	beqz	s2,7ee <vprintf+0x276>
        for(; *s; s++)
 7d4:	00094583          	lbu	a1,0(s2)
 7d8:	c195                	beqz	a1,7fc <vprintf+0x284>
          putc(fd, *s);
 7da:	855a                	mv	a0,s6
 7dc:	cd7ff0ef          	jal	4b2 <putc>
        for(; *s; s++)
 7e0:	0905                	addi	s2,s2,1
 7e2:	00094583          	lbu	a1,0(s2)
 7e6:	f9f5                	bnez	a1,7da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7e8:	8bce                	mv	s7,s3
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	bbd9                	j	5c2 <vprintf+0x4a>
          s = "(null)";
 7ee:	00000917          	auipc	s2,0x0
 7f2:	25a90913          	addi	s2,s2,602 # a48 <malloc+0x14e>
        for(; *s; s++)
 7f6:	02800593          	li	a1,40
 7fa:	b7c5                	j	7da <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7fc:	8bce                	mv	s7,s3
      state = 0;
 7fe:	4981                	li	s3,0
 800:	b3c9                	j	5c2 <vprintf+0x4a>
 802:	64a6                	ld	s1,72(sp)
 804:	79e2                	ld	s3,56(sp)
 806:	7a42                	ld	s4,48(sp)
 808:	7aa2                	ld	s5,40(sp)
 80a:	7b02                	ld	s6,32(sp)
 80c:	6be2                	ld	s7,24(sp)
 80e:	6c42                	ld	s8,16(sp)
 810:	6ca2                	ld	s9,8(sp)
    }
  }
}
 812:	60e6                	ld	ra,88(sp)
 814:	6446                	ld	s0,80(sp)
 816:	6906                	ld	s2,64(sp)
 818:	6125                	addi	sp,sp,96
 81a:	8082                	ret

000000000000081c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81c:	715d                	addi	sp,sp,-80
 81e:	ec06                	sd	ra,24(sp)
 820:	e822                	sd	s0,16(sp)
 822:	1000                	addi	s0,sp,32
 824:	e010                	sd	a2,0(s0)
 826:	e414                	sd	a3,8(s0)
 828:	e818                	sd	a4,16(s0)
 82a:	ec1c                	sd	a5,24(s0)
 82c:	03043023          	sd	a6,32(s0)
 830:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 834:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 838:	8622                	mv	a2,s0
 83a:	d3fff0ef          	jal	578 <vprintf>
}
 83e:	60e2                	ld	ra,24(sp)
 840:	6442                	ld	s0,16(sp)
 842:	6161                	addi	sp,sp,80
 844:	8082                	ret

0000000000000846 <printf>:

void
printf(const char *fmt, ...)
{
 846:	711d                	addi	sp,sp,-96
 848:	ec06                	sd	ra,24(sp)
 84a:	e822                	sd	s0,16(sp)
 84c:	1000                	addi	s0,sp,32
 84e:	e40c                	sd	a1,8(s0)
 850:	e810                	sd	a2,16(s0)
 852:	ec14                	sd	a3,24(s0)
 854:	f018                	sd	a4,32(s0)
 856:	f41c                	sd	a5,40(s0)
 858:	03043823          	sd	a6,48(s0)
 85c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 860:	00840613          	addi	a2,s0,8
 864:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 868:	85aa                	mv	a1,a0
 86a:	4505                	li	a0,1
 86c:	d0dff0ef          	jal	578 <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6125                	addi	sp,sp,96
 876:	8082                	ret

0000000000000878 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 878:	1141                	addi	sp,sp,-16
 87a:	e422                	sd	s0,8(sp)
 87c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	00000797          	auipc	a5,0x0
 886:	77e7b783          	ld	a5,1918(a5) # 1000 <freep>
 88a:	a02d                	j	8b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 88c:	4618                	lw	a4,8(a2)
 88e:	9f2d                	addw	a4,a4,a1
 890:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 894:	6398                	ld	a4,0(a5)
 896:	6310                	ld	a2,0(a4)
 898:	a83d                	j	8d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 89a:	ff852703          	lw	a4,-8(a0)
 89e:	9f31                	addw	a4,a4,a2
 8a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8a2:	ff053683          	ld	a3,-16(a0)
 8a6:	a091                	j	8ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a8:	6398                	ld	a4,0(a5)
 8aa:	00e7e463          	bltu	a5,a4,8b2 <free+0x3a>
 8ae:	00e6ea63          	bltu	a3,a4,8c2 <free+0x4a>
{
 8b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b4:	fed7fae3          	bgeu	a5,a3,8a8 <free+0x30>
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e6e463          	bltu	a3,a4,8c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8be:	fee7eae3          	bltu	a5,a4,8b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8c2:	ff852583          	lw	a1,-8(a0)
 8c6:	6390                	ld	a2,0(a5)
 8c8:	02059813          	slli	a6,a1,0x20
 8cc:	01c85713          	srli	a4,a6,0x1c
 8d0:	9736                	add	a4,a4,a3
 8d2:	fae60de3          	beq	a2,a4,88c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8da:	4790                	lw	a2,8(a5)
 8dc:	02061593          	slli	a1,a2,0x20
 8e0:	01c5d713          	srli	a4,a1,0x1c
 8e4:	973e                	add	a4,a4,a5
 8e6:	fae68ae3          	beq	a3,a4,89a <free+0x22>
    p->s.ptr = bp->s.ptr;
 8ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70f73a23          	sd	a5,1812(a4) # 1000 <freep>
}
 8f4:	6422                	ld	s0,8(sp)
 8f6:	0141                	addi	sp,sp,16
 8f8:	8082                	ret

00000000000008fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8fa:	7139                	addi	sp,sp,-64
 8fc:	fc06                	sd	ra,56(sp)
 8fe:	f822                	sd	s0,48(sp)
 900:	f426                	sd	s1,40(sp)
 902:	ec4e                	sd	s3,24(sp)
 904:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 906:	02051493          	slli	s1,a0,0x20
 90a:	9081                	srli	s1,s1,0x20
 90c:	04bd                	addi	s1,s1,15
 90e:	8091                	srli	s1,s1,0x4
 910:	0014899b          	addiw	s3,s1,1
 914:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 916:	00000517          	auipc	a0,0x0
 91a:	6ea53503          	ld	a0,1770(a0) # 1000 <freep>
 91e:	c915                	beqz	a0,952 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 920:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 922:	4798                	lw	a4,8(a5)
 924:	08977a63          	bgeu	a4,s1,9b8 <malloc+0xbe>
 928:	f04a                	sd	s2,32(sp)
 92a:	e852                	sd	s4,16(sp)
 92c:	e456                	sd	s5,8(sp)
 92e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 930:	8a4e                	mv	s4,s3
 932:	0009871b          	sext.w	a4,s3
 936:	6685                	lui	a3,0x1
 938:	00d77363          	bgeu	a4,a3,93e <malloc+0x44>
 93c:	6a05                	lui	s4,0x1
 93e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 942:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 946:	00000917          	auipc	s2,0x0
 94a:	6ba90913          	addi	s2,s2,1722 # 1000 <freep>
  if(p == SBRK_ERROR)
 94e:	5afd                	li	s5,-1
 950:	a081                	j	990 <malloc+0x96>
 952:	f04a                	sd	s2,32(sp)
 954:	e852                	sd	s4,16(sp)
 956:	e456                	sd	s5,8(sp)
 958:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95a:	00001797          	auipc	a5,0x1
 95e:	8b678793          	addi	a5,a5,-1866 # 1210 <base>
 962:	00000717          	auipc	a4,0x0
 966:	68f73f23          	sd	a5,1694(a4) # 1000 <freep>
 96a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 96c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 970:	b7c1                	j	930 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 972:	6398                	ld	a4,0(a5)
 974:	e118                	sd	a4,0(a0)
 976:	a8a9                	j	9d0 <malloc+0xd6>
  hp->s.size = nu;
 978:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 97c:	0541                	addi	a0,a0,16
 97e:	efbff0ef          	jal	878 <free>
  return freep;
 982:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 986:	c12d                	beqz	a0,9e8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98a:	4798                	lw	a4,8(a5)
 98c:	02977263          	bgeu	a4,s1,9b0 <malloc+0xb6>
    if(p == freep)
 990:	00093703          	ld	a4,0(s2)
 994:	853e                	mv	a0,a5
 996:	fef719e3          	bne	a4,a5,988 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 99a:	8552                	mv	a0,s4
 99c:	a23ff0ef          	jal	3be <sbrk>
  if(p == SBRK_ERROR)
 9a0:	fd551ce3          	bne	a0,s5,978 <malloc+0x7e>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	7902                	ld	s2,32(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	a03d                	j	9dc <malloc+0xe2>
 9b0:	7902                	ld	s2,32(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b8:	fae48de3          	beq	s1,a4,972 <malloc+0x78>
        p->s.size -= nunits;
 9bc:	4137073b          	subw	a4,a4,s3
 9c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c2:	02071693          	slli	a3,a4,0x20
 9c6:	01c6d713          	srli	a4,a3,0x1c
 9ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62a73823          	sd	a0,1584(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d8:	01078513          	addi	a0,a5,16
  }
}
 9dc:	70e2                	ld	ra,56(sp)
 9de:	7442                	ld	s0,48(sp)
 9e0:	74a2                	ld	s1,40(sp)
 9e2:	69e2                	ld	s3,24(sp)
 9e4:	6121                	addi	sp,sp,64
 9e6:	8082                	ret
 9e8:	7902                	ld	s2,32(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	b7f5                	j	9dc <malloc+0xe2>
