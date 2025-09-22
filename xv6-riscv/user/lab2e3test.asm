
user/_lab2e3test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32

// If there is no arguments print this scripts process priority information for testing. 
 if(argc == 1){
   c:	4785                	li	a5,1
   e:	00f50c63          	beq	a0,a5,26 <main+0x26>
  12:	84ae                	mv	s1,a1
        set_priority(pid, 10);
        printf("New priority level is %d.\n", get_priority(pid));
    }

// If there is an argument assume its a process id and print out priority.
else if(argc == 2){
  14:	4789                	li	a5,2
  16:	04f50f63          	beq	a0,a5,74 <main+0x74>
        }
        printf("Priority level of PID %d is %d.\n", pid, priority);
    }

// Change Pid to priority 
else if(argc == 3){
  1a:	478d                	li	a5,3
  1c:	08f50863          	beq	a0,a5,ac <main+0xac>
        printf("Previous Priority level of PID %d is %d.\n", pid, old_priority);
        set_priority(pid, new_priority);
        printf("New priority level is %d.\n", get_priority(pid));
    }
    
exit(0);
  20:	4501                	li	a0,0
  22:	39e000ef          	jal	3c0 <exit>
        int pid = getpid();
  26:	41a000ef          	jal	440 <getpid>
  2a:	84aa                	mv	s1,a0
        int priority = get_priority(pid);
  2c:	37c000ef          	jal	3a8 <get_priority>
  30:	85aa                	mv	a1,a0
        if(priority < 0){
  32:	02054763          	bltz	a0,60 <main+0x60>
        printf("Priority level of this process is %d.\n", priority);
  36:	00001517          	auipc	a0,0x1
  3a:	99a50513          	addi	a0,a0,-1638 # 9d0 <malloc+0x128>
  3e:	7b6000ef          	jal	7f4 <printf>
        set_priority(pid, 10);
  42:	45a9                	li	a1,10
  44:	8526                	mv	a0,s1
  46:	35a000ef          	jal	3a0 <set_priority>
        printf("New priority level is %d.\n", get_priority(pid));
  4a:	8526                	mv	a0,s1
  4c:	35c000ef          	jal	3a8 <get_priority>
  50:	85aa                	mv	a1,a0
  52:	00001517          	auipc	a0,0x1
  56:	9ae50513          	addi	a0,a0,-1618 # a00 <malloc+0x158>
  5a:	79a000ef          	jal	7f4 <printf>
  5e:	b7c9                	j	20 <main+0x20>
            fprintf(2, "Error: could not get priority of this process.\n");
  60:	00001597          	auipc	a1,0x1
  64:	94058593          	addi	a1,a1,-1728 # 9a0 <malloc+0xf8>
  68:	4509                	li	a0,2
  6a:	760000ef          	jal	7ca <fprintf>
            exit(1);
  6e:	4505                	li	a0,1
  70:	350000ef          	jal	3c0 <exit>
        int pid = atoi(argv[1]);
  74:	6588                	ld	a0,8(a1)
  76:	208000ef          	jal	27e <atoi>
  7a:	84aa                	mv	s1,a0
        int priority = get_priority(pid);
  7c:	32c000ef          	jal	3a8 <get_priority>
  80:	862a                	mv	a2,a0
        if(priority < 0){
  82:	00054a63          	bltz	a0,96 <main+0x96>
        printf("Priority level of PID %d is %d.\n", pid, priority);
  86:	85a6                	mv	a1,s1
  88:	00001517          	auipc	a0,0x1
  8c:	9c850513          	addi	a0,a0,-1592 # a50 <malloc+0x1a8>
  90:	764000ef          	jal	7f4 <printf>
  94:	b771                	j	20 <main+0x20>
            fprintf(2, "Error: could not get priority of PID %d.\n", pid);
  96:	8626                	mv	a2,s1
  98:	00001597          	auipc	a1,0x1
  9c:	98858593          	addi	a1,a1,-1656 # a20 <malloc+0x178>
  a0:	4509                	li	a0,2
  a2:	728000ef          	jal	7ca <fprintf>
            exit(1);
  a6:	4505                	li	a0,1
  a8:	318000ef          	jal	3c0 <exit>
        int pid = atoi(argv[1]);
  ac:	6588                	ld	a0,8(a1)
  ae:	1d0000ef          	jal	27e <atoi>
  b2:	892a                	mv	s2,a0
        int new_priority = atoi(argv[2]);
  b4:	6888                	ld	a0,16(s1)
  b6:	1c8000ef          	jal	27e <atoi>
  ba:	84aa                	mv	s1,a0
        int old_priority = get_priority(pid);
  bc:	854a                	mv	a0,s2
  be:	2ea000ef          	jal	3a8 <get_priority>
  c2:	862a                	mv	a2,a0
        if(old_priority < 0){
  c4:	02054863          	bltz	a0,f4 <main+0xf4>
        printf("Previous Priority level of PID %d is %d.\n", pid, old_priority);
  c8:	85ca                	mv	a1,s2
  ca:	00001517          	auipc	a0,0x1
  ce:	9ae50513          	addi	a0,a0,-1618 # a78 <malloc+0x1d0>
  d2:	722000ef          	jal	7f4 <printf>
        set_priority(pid, new_priority);
  d6:	85a6                	mv	a1,s1
  d8:	854a                	mv	a0,s2
  da:	2c6000ef          	jal	3a0 <set_priority>
        printf("New priority level is %d.\n", get_priority(pid));
  de:	854a                	mv	a0,s2
  e0:	2c8000ef          	jal	3a8 <get_priority>
  e4:	85aa                	mv	a1,a0
  e6:	00001517          	auipc	a0,0x1
  ea:	91a50513          	addi	a0,a0,-1766 # a00 <malloc+0x158>
  ee:	706000ef          	jal	7f4 <printf>
  f2:	b73d                	j	20 <main+0x20>
            fprintf(2, "Error: could not get priority of PID %d.\n", pid);
  f4:	864a                	mv	a2,s2
  f6:	00001597          	auipc	a1,0x1
  fa:	92a58593          	addi	a1,a1,-1750 # a20 <malloc+0x178>
  fe:	4509                	li	a0,2
 100:	6ca000ef          	jal	7ca <fprintf>
            exit(1);
 104:	4505                	li	a0,1
 106:	2ba000ef          	jal	3c0 <exit>

000000000000010a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 10a:	1141                	addi	sp,sp,-16
 10c:	e406                	sd	ra,8(sp)
 10e:	e022                	sd	s0,0(sp)
 110:	0800                	addi	s0,sp,16
  extern int main();
  main();
 112:	eefff0ef          	jal	0 <main>
  exit(0);
 116:	4501                	li	a0,0
 118:	2a8000ef          	jal	3c0 <exit>

000000000000011c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e422                	sd	s0,8(sp)
 120:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 122:	87aa                	mv	a5,a0
 124:	0585                	addi	a1,a1,1
 126:	0785                	addi	a5,a5,1
 128:	fff5c703          	lbu	a4,-1(a1)
 12c:	fee78fa3          	sb	a4,-1(a5)
 130:	fb75                	bnez	a4,124 <strcpy+0x8>
    ;
  return os;
}
 132:	6422                	ld	s0,8(sp)
 134:	0141                	addi	sp,sp,16
 136:	8082                	ret

0000000000000138 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13e:	00054783          	lbu	a5,0(a0)
 142:	cb91                	beqz	a5,156 <strcmp+0x1e>
 144:	0005c703          	lbu	a4,0(a1)
 148:	00f71763          	bne	a4,a5,156 <strcmp+0x1e>
    p++, q++;
 14c:	0505                	addi	a0,a0,1
 14e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 150:	00054783          	lbu	a5,0(a0)
 154:	fbe5                	bnez	a5,144 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 156:	0005c503          	lbu	a0,0(a1)
}
 15a:	40a7853b          	subw	a0,a5,a0
 15e:	6422                	ld	s0,8(sp)
 160:	0141                	addi	sp,sp,16
 162:	8082                	ret

0000000000000164 <strlen>:

uint
strlen(const char *s)
{
 164:	1141                	addi	sp,sp,-16
 166:	e422                	sd	s0,8(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x26>
 170:	0505                	addi	a0,a0,1
 172:	87aa                	mv	a5,a0
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x10>
 17e:	40a6853b          	subw	a0,a3,a0
 182:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 184:	6422                	ld	s0,8(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  for(n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfe5                	j	184 <strlen+0x20>

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 194:	ca19                	beqz	a2,1aa <memset+0x1c>
 196:	87aa                	mv	a5,a0
 198:	1602                	slli	a2,a2,0x20
 19a:	9201                	srli	a2,a2,0x20
 19c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a4:	0785                	addi	a5,a5,1
 1a6:	fee79de3          	bne	a5,a4,1a0 <memset+0x12>
  }
  return dst;
}
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret

00000000000001b0 <strchr>:

char*
strchr(const char *s, char c)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e422                	sd	s0,8(sp)
 1b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cb99                	beqz	a5,1d0 <strchr+0x20>
    if(*s == c)
 1bc:	00f58763          	beq	a1,a5,1ca <strchr+0x1a>
  for(; *s; s++)
 1c0:	0505                	addi	a0,a0,1
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbfd                	bnez	a5,1bc <strchr+0xc>
      return (char*)s;
  return 0;
 1c8:	4501                	li	a0,0
}
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret
  return 0;
 1d0:	4501                	li	a0,0
 1d2:	bfe5                	j	1ca <strchr+0x1a>

00000000000001d4 <gets>:

char*
gets(char *buf, int max)
{
 1d4:	711d                	addi	sp,sp,-96
 1d6:	ec86                	sd	ra,88(sp)
 1d8:	e8a2                	sd	s0,80(sp)
 1da:	e4a6                	sd	s1,72(sp)
 1dc:	e0ca                	sd	s2,64(sp)
 1de:	fc4e                	sd	s3,56(sp)
 1e0:	f852                	sd	s4,48(sp)
 1e2:	f456                	sd	s5,40(sp)
 1e4:	f05a                	sd	s6,32(sp)
 1e6:	ec5e                	sd	s7,24(sp)
 1e8:	1080                	addi	s0,sp,96
 1ea:	8baa                	mv	s7,a0
 1ec:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	892a                	mv	s2,a0
 1f0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f2:	4aa9                	li	s5,10
 1f4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f6:	89a6                	mv	s3,s1
 1f8:	2485                	addiw	s1,s1,1
 1fa:	0344d663          	bge	s1,s4,226 <gets+0x52>
    cc = read(0, &c, 1);
 1fe:	4605                	li	a2,1
 200:	faf40593          	addi	a1,s0,-81
 204:	4501                	li	a0,0
 206:	1d2000ef          	jal	3d8 <read>
    if(cc < 1)
 20a:	00a05e63          	blez	a0,226 <gets+0x52>
    buf[i++] = c;
 20e:	faf44783          	lbu	a5,-81(s0)
 212:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 216:	01578763          	beq	a5,s5,224 <gets+0x50>
 21a:	0905                	addi	s2,s2,1
 21c:	fd679de3          	bne	a5,s6,1f6 <gets+0x22>
    buf[i++] = c;
 220:	89a6                	mv	s3,s1
 222:	a011                	j	226 <gets+0x52>
 224:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 226:	99de                	add	s3,s3,s7
 228:	00098023          	sb	zero,0(s3)
  return buf;
}
 22c:	855e                	mv	a0,s7
 22e:	60e6                	ld	ra,88(sp)
 230:	6446                	ld	s0,80(sp)
 232:	64a6                	ld	s1,72(sp)
 234:	6906                	ld	s2,64(sp)
 236:	79e2                	ld	s3,56(sp)
 238:	7a42                	ld	s4,48(sp)
 23a:	7aa2                	ld	s5,40(sp)
 23c:	7b02                	ld	s6,32(sp)
 23e:	6be2                	ld	s7,24(sp)
 240:	6125                	addi	sp,sp,96
 242:	8082                	ret

0000000000000244 <stat>:

int
stat(const char *n, struct stat *st)
{
 244:	1101                	addi	sp,sp,-32
 246:	ec06                	sd	ra,24(sp)
 248:	e822                	sd	s0,16(sp)
 24a:	e04a                	sd	s2,0(sp)
 24c:	1000                	addi	s0,sp,32
 24e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 250:	4581                	li	a1,0
 252:	1ae000ef          	jal	400 <open>
  if(fd < 0)
 256:	02054263          	bltz	a0,27a <stat+0x36>
 25a:	e426                	sd	s1,8(sp)
 25c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25e:	85ca                	mv	a1,s2
 260:	1b8000ef          	jal	418 <fstat>
 264:	892a                	mv	s2,a0
  close(fd);
 266:	8526                	mv	a0,s1
 268:	180000ef          	jal	3e8 <close>
  return r;
 26c:	64a2                	ld	s1,8(sp)
}
 26e:	854a                	mv	a0,s2
 270:	60e2                	ld	ra,24(sp)
 272:	6442                	ld	s0,16(sp)
 274:	6902                	ld	s2,0(sp)
 276:	6105                	addi	sp,sp,32
 278:	8082                	ret
    return -1;
 27a:	597d                	li	s2,-1
 27c:	bfcd                	j	26e <stat+0x2a>

000000000000027e <atoi>:

int
atoi(const char *s)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e422                	sd	s0,8(sp)
 282:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 284:	00054683          	lbu	a3,0(a0)
 288:	fd06879b          	addiw	a5,a3,-48
 28c:	0ff7f793          	zext.b	a5,a5
 290:	4625                	li	a2,9
 292:	02f66863          	bltu	a2,a5,2c2 <atoi+0x44>
 296:	872a                	mv	a4,a0
  n = 0;
 298:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 29a:	0705                	addi	a4,a4,1
 29c:	0025179b          	slliw	a5,a0,0x2
 2a0:	9fa9                	addw	a5,a5,a0
 2a2:	0017979b          	slliw	a5,a5,0x1
 2a6:	9fb5                	addw	a5,a5,a3
 2a8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ac:	00074683          	lbu	a3,0(a4)
 2b0:	fd06879b          	addiw	a5,a3,-48
 2b4:	0ff7f793          	zext.b	a5,a5
 2b8:	fef671e3          	bgeu	a2,a5,29a <atoi+0x1c>
  return n;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
  n = 0;
 2c2:	4501                	li	a0,0
 2c4:	bfe5                	j	2bc <atoi+0x3e>

00000000000002c6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e422                	sd	s0,8(sp)
 2ca:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2cc:	02b57463          	bgeu	a0,a1,2f4 <memmove+0x2e>
    while(n-- > 0)
 2d0:	00c05f63          	blez	a2,2ee <memmove+0x28>
 2d4:	1602                	slli	a2,a2,0x20
 2d6:	9201                	srli	a2,a2,0x20
 2d8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2dc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2de:	0585                	addi	a1,a1,1
 2e0:	0705                	addi	a4,a4,1
 2e2:	fff5c683          	lbu	a3,-1(a1)
 2e6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ea:	fef71ae3          	bne	a4,a5,2de <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
    dst += n;
 2f4:	00c50733          	add	a4,a0,a2
    src += n;
 2f8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2fa:	fec05ae3          	blez	a2,2ee <memmove+0x28>
 2fe:	fff6079b          	addiw	a5,a2,-1
 302:	1782                	slli	a5,a5,0x20
 304:	9381                	srli	a5,a5,0x20
 306:	fff7c793          	not	a5,a5
 30a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30c:	15fd                	addi	a1,a1,-1
 30e:	177d                	addi	a4,a4,-1
 310:	0005c683          	lbu	a3,0(a1)
 314:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 318:	fee79ae3          	bne	a5,a4,30c <memmove+0x46>
 31c:	bfc9                	j	2ee <memmove+0x28>

000000000000031e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e422                	sd	s0,8(sp)
 322:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 324:	ca05                	beqz	a2,354 <memcmp+0x36>
 326:	fff6069b          	addiw	a3,a2,-1
 32a:	1682                	slli	a3,a3,0x20
 32c:	9281                	srli	a3,a3,0x20
 32e:	0685                	addi	a3,a3,1
 330:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 332:	00054783          	lbu	a5,0(a0)
 336:	0005c703          	lbu	a4,0(a1)
 33a:	00e79863          	bne	a5,a4,34a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 33e:	0505                	addi	a0,a0,1
    p2++;
 340:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 342:	fed518e3          	bne	a0,a3,332 <memcmp+0x14>
  }
  return 0;
 346:	4501                	li	a0,0
 348:	a019                	j	34e <memcmp+0x30>
      return *p1 - *p2;
 34a:	40e7853b          	subw	a0,a5,a4
}
 34e:	6422                	ld	s0,8(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret
  return 0;
 354:	4501                	li	a0,0
 356:	bfe5                	j	34e <memcmp+0x30>

0000000000000358 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 358:	1141                	addi	sp,sp,-16
 35a:	e406                	sd	ra,8(sp)
 35c:	e022                	sd	s0,0(sp)
 35e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 360:	f67ff0ef          	jal	2c6 <memmove>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <sbrk>:

char *
sbrk(int n) {
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 374:	4585                	li	a1,1
 376:	0d2000ef          	jal	448 <sys_sbrk>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <sbrklazy>:

char *
sbrklazy(int n) {
 382:	1141                	addi	sp,sp,-16
 384:	e406                	sd	ra,8(sp)
 386:	e022                	sd	s0,0(sp)
 388:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 38a:	4589                	li	a1,2
 38c:	0bc000ef          	jal	448 <sys_sbrk>
}
 390:	60a2                	ld	ra,8(sp)
 392:	6402                	ld	s0,0(sp)
 394:	0141                	addi	sp,sp,16
 396:	8082                	ret

0000000000000398 <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
 398:	48e5                	li	a7,25
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
 3a0:	48e1                	li	a7,24
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
 3a8:	48dd                	li	a7,23
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3b0:	48d9                	li	a7,22
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <fork>:
.global fork
fork:
 li a7, SYS_fork
 3b8:	4885                	li	a7,1
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3c0:	4889                	li	a7,2
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c8:	488d                	li	a7,3
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3d0:	4891                	li	a7,4
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <read>:
.global read
read:
 li a7, SYS_read
 3d8:	4895                	li	a7,5
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <write>:
.global write
write:
 li a7, SYS_write
 3e0:	48c1                	li	a7,16
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <close>:
.global close
close:
 li a7, SYS_close
 3e8:	48d5                	li	a7,21
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3f0:	4899                	li	a7,6
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f8:	489d                	li	a7,7
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <open>:
.global open
open:
 li a7, SYS_open
 400:	48bd                	li	a7,15
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 408:	48c5                	li	a7,17
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 410:	48c9                	li	a7,18
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 418:	48a1                	li	a7,8
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <link>:
.global link
link:
 li a7, SYS_link
 420:	48cd                	li	a7,19
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 428:	48d1                	li	a7,20
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 430:	48a5                	li	a7,9
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <dup>:
.global dup
dup:
 li a7, SYS_dup
 438:	48a9                	li	a7,10
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 440:	48ad                	li	a7,11
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 448:	48b1                	li	a7,12
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <pause>:
.global pause
pause:
 li a7, SYS_pause
 450:	48b5                	li	a7,13
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 458:	48b9                	li	a7,14
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 460:	1101                	addi	sp,sp,-32
 462:	ec06                	sd	ra,24(sp)
 464:	e822                	sd	s0,16(sp)
 466:	1000                	addi	s0,sp,32
 468:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 46c:	4605                	li	a2,1
 46e:	fef40593          	addi	a1,s0,-17
 472:	f6fff0ef          	jal	3e0 <write>
}
 476:	60e2                	ld	ra,24(sp)
 478:	6442                	ld	s0,16(sp)
 47a:	6105                	addi	sp,sp,32
 47c:	8082                	ret

000000000000047e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 47e:	715d                	addi	sp,sp,-80
 480:	e486                	sd	ra,72(sp)
 482:	e0a2                	sd	s0,64(sp)
 484:	fc26                	sd	s1,56(sp)
 486:	0880                	addi	s0,sp,80
 488:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 48a:	c299                	beqz	a3,490 <printint+0x12>
 48c:	0805c963          	bltz	a1,51e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 490:	2581                	sext.w	a1,a1
  neg = 0;
 492:	4881                	li	a7,0
 494:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	2601                	sext.w	a2,a2
 49c:	00000517          	auipc	a0,0x0
 4a0:	61450513          	addi	a0,a0,1556 # ab0 <digits>
 4a4:	883a                	mv	a6,a4
 4a6:	2705                	addiw	a4,a4,1
 4a8:	02c5f7bb          	remuw	a5,a1,a2
 4ac:	1782                	slli	a5,a5,0x20
 4ae:	9381                	srli	a5,a5,0x20
 4b0:	97aa                	add	a5,a5,a0
 4b2:	0007c783          	lbu	a5,0(a5)
 4b6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ba:	0005879b          	sext.w	a5,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	addi	a3,a3,1
 4c4:	fec7f0e3          	bgeu	a5,a2,4a4 <printint+0x26>
  if(neg)
 4c8:	00088c63          	beqz	a7,4e0 <printint+0x62>
    buf[i++] = '-';
 4cc:	fd070793          	addi	a5,a4,-48
 4d0:	00878733          	add	a4,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef70423          	sb	a5,-24(a4)
 4dc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4e0:	02e05a63          	blez	a4,514 <printint+0x96>
 4e4:	f84a                	sd	s2,48(sp)
 4e6:	f44e                	sd	s3,40(sp)
 4e8:	fb840793          	addi	a5,s0,-72
 4ec:	00e78933          	add	s2,a5,a4
 4f0:	fff78993          	addi	s3,a5,-1
 4f4:	99ba                	add	s3,s3,a4
 4f6:	377d                	addiw	a4,a4,-1
 4f8:	1702                	slli	a4,a4,0x20
 4fa:	9301                	srli	a4,a4,0x20
 4fc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 500:	fff94583          	lbu	a1,-1(s2)
 504:	8526                	mv	a0,s1
 506:	f5bff0ef          	jal	460 <putc>
  while(--i >= 0)
 50a:	197d                	addi	s2,s2,-1
 50c:	ff391ae3          	bne	s2,s3,500 <printint+0x82>
 510:	7942                	ld	s2,48(sp)
 512:	79a2                	ld	s3,40(sp)
}
 514:	60a6                	ld	ra,72(sp)
 516:	6406                	ld	s0,64(sp)
 518:	74e2                	ld	s1,56(sp)
 51a:	6161                	addi	sp,sp,80
 51c:	8082                	ret
    x = -xx;
 51e:	40b005bb          	negw	a1,a1
    neg = 1;
 522:	4885                	li	a7,1
    x = -xx;
 524:	bf85                	j	494 <printint+0x16>

0000000000000526 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 526:	711d                	addi	sp,sp,-96
 528:	ec86                	sd	ra,88(sp)
 52a:	e8a2                	sd	s0,80(sp)
 52c:	e0ca                	sd	s2,64(sp)
 52e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 530:	0005c903          	lbu	s2,0(a1)
 534:	28090663          	beqz	s2,7c0 <vprintf+0x29a>
 538:	e4a6                	sd	s1,72(sp)
 53a:	fc4e                	sd	s3,56(sp)
 53c:	f852                	sd	s4,48(sp)
 53e:	f456                	sd	s5,40(sp)
 540:	f05a                	sd	s6,32(sp)
 542:	ec5e                	sd	s7,24(sp)
 544:	e862                	sd	s8,16(sp)
 546:	e466                	sd	s9,8(sp)
 548:	8b2a                	mv	s6,a0
 54a:	8a2e                	mv	s4,a1
 54c:	8bb2                	mv	s7,a2
  state = 0;
 54e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 550:	4481                	li	s1,0
 552:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 554:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 558:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 55c:	06c00c93          	li	s9,108
 560:	a005                	j	580 <vprintf+0x5a>
        putc(fd, c0);
 562:	85ca                	mv	a1,s2
 564:	855a                	mv	a0,s6
 566:	efbff0ef          	jal	460 <putc>
 56a:	a019                	j	570 <vprintf+0x4a>
    } else if(state == '%'){
 56c:	03598263          	beq	s3,s5,590 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 570:	2485                	addiw	s1,s1,1
 572:	8726                	mv	a4,s1
 574:	009a07b3          	add	a5,s4,s1
 578:	0007c903          	lbu	s2,0(a5)
 57c:	22090a63          	beqz	s2,7b0 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
 580:	0009079b          	sext.w	a5,s2
    if(state == 0){
 584:	fe0994e3          	bnez	s3,56c <vprintf+0x46>
      if(c0 == '%'){
 588:	fd579de3          	bne	a5,s5,562 <vprintf+0x3c>
        state = '%';
 58c:	89be                	mv	s3,a5
 58e:	b7cd                	j	570 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 590:	00ea06b3          	add	a3,s4,a4
 594:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 598:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 59a:	c681                	beqz	a3,5a2 <vprintf+0x7c>
 59c:	9752                	add	a4,a4,s4
 59e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5a2:	05878363          	beq	a5,s8,5e8 <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
 5a6:	05978d63          	beq	a5,s9,600 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5aa:	07500713          	li	a4,117
 5ae:	0ee78763          	beq	a5,a4,69c <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5b2:	07800713          	li	a4,120
 5b6:	12e78963          	beq	a5,a4,6e8 <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5ba:	07000713          	li	a4,112
 5be:	14e78e63          	beq	a5,a4,71a <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
 5c2:	06300713          	li	a4,99
 5c6:	18e78e63          	beq	a5,a4,762 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
 5ca:	07300713          	li	a4,115
 5ce:	1ae78463          	beq	a5,a4,776 <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5d2:	02500713          	li	a4,37
 5d6:	04e79563          	bne	a5,a4,620 <vprintf+0xfa>
        putc(fd, '%');
 5da:	02500593          	li	a1,37
 5de:	855a                	mv	a0,s6
 5e0:	e81ff0ef          	jal	460 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b769                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e89ff0ef          	jal	47e <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bf8d                	j	570 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 600:	06400793          	li	a5,100
 604:	02f68963          	beq	a3,a5,636 <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 608:	06c00793          	li	a5,108
 60c:	04f68263          	beq	a3,a5,650 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
 610:	07500793          	li	a5,117
 614:	0af68063          	beq	a3,a5,6b4 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
 618:	07800793          	li	a5,120
 61c:	0ef68263          	beq	a3,a5,700 <vprintf+0x1da>
        putc(fd, '%');
 620:	02500593          	li	a1,37
 624:	855a                	mv	a0,s6
 626:	e3bff0ef          	jal	460 <putc>
        putc(fd, c0);
 62a:	85ca                	mv	a1,s2
 62c:	855a                	mv	a0,s6
 62e:	e33ff0ef          	jal	460 <putc>
      state = 0;
 632:	4981                	li	s3,0
 634:	bf35                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 636:	008b8913          	addi	s2,s7,8
 63a:	4685                	li	a3,1
 63c:	4629                	li	a2,10
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	e3bff0ef          	jal	47e <printint>
        i += 1;
 648:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64a:	8bca                	mv	s7,s2
      state = 0;
 64c:	4981                	li	s3,0
        i += 1;
 64e:	b70d                	j	570 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 650:	06400793          	li	a5,100
 654:	02f60763          	beq	a2,a5,682 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 658:	07500793          	li	a5,117
 65c:	06f60963          	beq	a2,a5,6ce <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 660:	07800793          	li	a5,120
 664:	faf61ee3          	bne	a2,a5,620 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	008b8913          	addi	s2,s7,8
 66c:	4681                	li	a3,0
 66e:	4641                	li	a2,16
 670:	000bb583          	ld	a1,0(s7)
 674:	855a                	mv	a0,s6
 676:	e09ff0ef          	jal	47e <printint>
        i += 2;
 67a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	8bca                	mv	s7,s2
      state = 0;
 67e:	4981                	li	s3,0
        i += 2;
 680:	bdc5                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 682:	008b8913          	addi	s2,s7,8
 686:	4685                	li	a3,1
 688:	4629                	li	a2,10
 68a:	000bb583          	ld	a1,0(s7)
 68e:	855a                	mv	a0,s6
 690:	defff0ef          	jal	47e <printint>
        i += 2;
 694:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 696:	8bca                	mv	s7,s2
      state = 0;
 698:	4981                	li	s3,0
        i += 2;
 69a:	bdd9                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4681                	li	a3,0
 6a2:	4629                	li	a2,10
 6a4:	000be583          	lwu	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	dd5ff0ef          	jal	47e <printint>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bd7d                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000bb583          	ld	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dbdff0ef          	jal	47e <printint>
        i += 1;
 6c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c8:	8bca                	mv	s7,s2
      state = 0;
 6ca:	4981                	li	s3,0
        i += 1;
 6cc:	b555                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ce:	008b8913          	addi	s2,s7,8
 6d2:	4681                	li	a3,0
 6d4:	4629                	li	a2,10
 6d6:	000bb583          	ld	a1,0(s7)
 6da:	855a                	mv	a0,s6
 6dc:	da3ff0ef          	jal	47e <printint>
        i += 2;
 6e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e2:	8bca                	mv	s7,s2
      state = 0;
 6e4:	4981                	li	s3,0
        i += 2;
 6e6:	b569                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6e8:	008b8913          	addi	s2,s7,8
 6ec:	4681                	li	a3,0
 6ee:	4641                	li	a2,16
 6f0:	000be583          	lwu	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	d89ff0ef          	jal	47e <printint>
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	bd8d                	j	570 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4641                	li	a2,16
 708:	000bb583          	ld	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	d71ff0ef          	jal	47e <printint>
        i += 1;
 712:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
        i += 1;
 718:	bda1                	j	570 <vprintf+0x4a>
 71a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 71c:	008b8d13          	addi	s10,s7,8
 720:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 724:	03000593          	li	a1,48
 728:	855a                	mv	a0,s6
 72a:	d37ff0ef          	jal	460 <putc>
  putc(fd, 'x');
 72e:	07800593          	li	a1,120
 732:	855a                	mv	a0,s6
 734:	d2dff0ef          	jal	460 <putc>
 738:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73a:	00000b97          	auipc	s7,0x0
 73e:	376b8b93          	addi	s7,s7,886 # ab0 <digits>
 742:	03c9d793          	srli	a5,s3,0x3c
 746:	97de                	add	a5,a5,s7
 748:	0007c583          	lbu	a1,0(a5)
 74c:	855a                	mv	a0,s6
 74e:	d13ff0ef          	jal	460 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	0992                	slli	s3,s3,0x4
 754:	397d                	addiw	s2,s2,-1
 756:	fe0916e3          	bnez	s2,742 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
 75a:	8bea                	mv	s7,s10
      state = 0;
 75c:	4981                	li	s3,0
 75e:	6d02                	ld	s10,0(sp)
 760:	bd01                	j	570 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
 762:	008b8913          	addi	s2,s7,8
 766:	000bc583          	lbu	a1,0(s7)
 76a:	855a                	mv	a0,s6
 76c:	cf5ff0ef          	jal	460 <putc>
 770:	8bca                	mv	s7,s2
      state = 0;
 772:	4981                	li	s3,0
 774:	bbf5                	j	570 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 776:	008b8993          	addi	s3,s7,8
 77a:	000bb903          	ld	s2,0(s7)
 77e:	00090f63          	beqz	s2,79c <vprintf+0x276>
        for(; *s; s++)
 782:	00094583          	lbu	a1,0(s2)
 786:	c195                	beqz	a1,7aa <vprintf+0x284>
          putc(fd, *s);
 788:	855a                	mv	a0,s6
 78a:	cd7ff0ef          	jal	460 <putc>
        for(; *s; s++)
 78e:	0905                	addi	s2,s2,1
 790:	00094583          	lbu	a1,0(s2)
 794:	f9f5                	bnez	a1,788 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 796:	8bce                	mv	s7,s3
      state = 0;
 798:	4981                	li	s3,0
 79a:	bbd9                	j	570 <vprintf+0x4a>
          s = "(null)";
 79c:	00000917          	auipc	s2,0x0
 7a0:	30c90913          	addi	s2,s2,780 # aa8 <malloc+0x200>
        for(; *s; s++)
 7a4:	02800593          	li	a1,40
 7a8:	b7c5                	j	788 <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
 7aa:	8bce                	mv	s7,s3
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b3c9                	j	570 <vprintf+0x4a>
 7b0:	64a6                	ld	s1,72(sp)
 7b2:	79e2                	ld	s3,56(sp)
 7b4:	7a42                	ld	s4,48(sp)
 7b6:	7aa2                	ld	s5,40(sp)
 7b8:	7b02                	ld	s6,32(sp)
 7ba:	6be2                	ld	s7,24(sp)
 7bc:	6c42                	ld	s8,16(sp)
 7be:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7c0:	60e6                	ld	ra,88(sp)
 7c2:	6446                	ld	s0,80(sp)
 7c4:	6906                	ld	s2,64(sp)
 7c6:	6125                	addi	sp,sp,96
 7c8:	8082                	ret

00000000000007ca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ca:	715d                	addi	sp,sp,-80
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e010                	sd	a2,0(s0)
 7d4:	e414                	sd	a3,8(s0)
 7d6:	e818                	sd	a4,16(s0)
 7d8:	ec1c                	sd	a5,24(s0)
 7da:	03043023          	sd	a6,32(s0)
 7de:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e6:	8622                	mv	a2,s0
 7e8:	d3fff0ef          	jal	526 <vprintf>
}
 7ec:	60e2                	ld	ra,24(sp)
 7ee:	6442                	ld	s0,16(sp)
 7f0:	6161                	addi	sp,sp,80
 7f2:	8082                	ret

00000000000007f4 <printf>:

void
printf(const char *fmt, ...)
{
 7f4:	711d                	addi	sp,sp,-96
 7f6:	ec06                	sd	ra,24(sp)
 7f8:	e822                	sd	s0,16(sp)
 7fa:	1000                	addi	s0,sp,32
 7fc:	e40c                	sd	a1,8(s0)
 7fe:	e810                	sd	a2,16(s0)
 800:	ec14                	sd	a3,24(s0)
 802:	f018                	sd	a4,32(s0)
 804:	f41c                	sd	a5,40(s0)
 806:	03043823          	sd	a6,48(s0)
 80a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80e:	00840613          	addi	a2,s0,8
 812:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 816:	85aa                	mv	a1,a0
 818:	4505                	li	a0,1
 81a:	d0dff0ef          	jal	526 <vprintf>
}
 81e:	60e2                	ld	ra,24(sp)
 820:	6442                	ld	s0,16(sp)
 822:	6125                	addi	sp,sp,96
 824:	8082                	ret

0000000000000826 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 826:	1141                	addi	sp,sp,-16
 828:	e422                	sd	s0,8(sp)
 82a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 82c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	00000797          	auipc	a5,0x0
 834:	7d07b783          	ld	a5,2000(a5) # 1000 <freep>
 838:	a02d                	j	862 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83a:	4618                	lw	a4,8(a2)
 83c:	9f2d                	addw	a4,a4,a1
 83e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 842:	6398                	ld	a4,0(a5)
 844:	6310                	ld	a2,0(a4)
 846:	a83d                	j	884 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 848:	ff852703          	lw	a4,-8(a0)
 84c:	9f31                	addw	a4,a4,a2
 84e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 850:	ff053683          	ld	a3,-16(a0)
 854:	a091                	j	898 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	6398                	ld	a4,0(a5)
 858:	00e7e463          	bltu	a5,a4,860 <free+0x3a>
 85c:	00e6ea63          	bltu	a3,a4,870 <free+0x4a>
{
 860:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	fed7fae3          	bgeu	a5,a3,856 <free+0x30>
 866:	6398                	ld	a4,0(a5)
 868:	00e6e463          	bltu	a3,a4,870 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	fee7eae3          	bltu	a5,a4,860 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 870:	ff852583          	lw	a1,-8(a0)
 874:	6390                	ld	a2,0(a5)
 876:	02059813          	slli	a6,a1,0x20
 87a:	01c85713          	srli	a4,a6,0x1c
 87e:	9736                	add	a4,a4,a3
 880:	fae60de3          	beq	a2,a4,83a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 888:	4790                	lw	a2,8(a5)
 88a:	02061593          	slli	a1,a2,0x20
 88e:	01c5d713          	srli	a4,a1,0x1c
 892:	973e                	add	a4,a4,a5
 894:	fae68ae3          	beq	a3,a4,848 <free+0x22>
    p->s.ptr = bp->s.ptr;
 898:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89a:	00000717          	auipc	a4,0x0
 89e:	76f73323          	sd	a5,1894(a4) # 1000 <freep>
}
 8a2:	6422                	ld	s0,8(sp)
 8a4:	0141                	addi	sp,sp,16
 8a6:	8082                	ret

00000000000008a8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8a8:	7139                	addi	sp,sp,-64
 8aa:	fc06                	sd	ra,56(sp)
 8ac:	f822                	sd	s0,48(sp)
 8ae:	f426                	sd	s1,40(sp)
 8b0:	ec4e                	sd	s3,24(sp)
 8b2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b4:	02051493          	slli	s1,a0,0x20
 8b8:	9081                	srli	s1,s1,0x20
 8ba:	04bd                	addi	s1,s1,15
 8bc:	8091                	srli	s1,s1,0x4
 8be:	0014899b          	addiw	s3,s1,1
 8c2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c4:	00000517          	auipc	a0,0x0
 8c8:	73c53503          	ld	a0,1852(a0) # 1000 <freep>
 8cc:	c915                	beqz	a0,900 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	08977a63          	bgeu	a4,s1,966 <malloc+0xbe>
 8d6:	f04a                	sd	s2,32(sp)
 8d8:	e852                	sd	s4,16(sp)
 8da:	e456                	sd	s5,8(sp)
 8dc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8de:	8a4e                	mv	s4,s3
 8e0:	0009871b          	sext.w	a4,s3
 8e4:	6685                	lui	a3,0x1
 8e6:	00d77363          	bgeu	a4,a3,8ec <malloc+0x44>
 8ea:	6a05                	lui	s4,0x1
 8ec:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f4:	00000917          	auipc	s2,0x0
 8f8:	70c90913          	addi	s2,s2,1804 # 1000 <freep>
  if(p == SBRK_ERROR)
 8fc:	5afd                	li	s5,-1
 8fe:	a081                	j	93e <malloc+0x96>
 900:	f04a                	sd	s2,32(sp)
 902:	e852                	sd	s4,16(sp)
 904:	e456                	sd	s5,8(sp)
 906:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 908:	00000797          	auipc	a5,0x0
 90c:	70878793          	addi	a5,a5,1800 # 1010 <base>
 910:	00000717          	auipc	a4,0x0
 914:	6ef73823          	sd	a5,1776(a4) # 1000 <freep>
 918:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 91e:	b7c1                	j	8de <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 920:	6398                	ld	a4,0(a5)
 922:	e118                	sd	a4,0(a0)
 924:	a8a9                	j	97e <malloc+0xd6>
  hp->s.size = nu;
 926:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92a:	0541                	addi	a0,a0,16
 92c:	efbff0ef          	jal	826 <free>
  return freep;
 930:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 934:	c12d                	beqz	a0,996 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 936:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 938:	4798                	lw	a4,8(a5)
 93a:	02977263          	bgeu	a4,s1,95e <malloc+0xb6>
    if(p == freep)
 93e:	00093703          	ld	a4,0(s2)
 942:	853e                	mv	a0,a5
 944:	fef719e3          	bne	a4,a5,936 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 948:	8552                	mv	a0,s4
 94a:	a23ff0ef          	jal	36c <sbrk>
  if(p == SBRK_ERROR)
 94e:	fd551ce3          	bne	a0,s5,926 <malloc+0x7e>
        return 0;
 952:	4501                	li	a0,0
 954:	7902                	ld	s2,32(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	a03d                	j	98a <malloc+0xe2>
 95e:	7902                	ld	s2,32(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 966:	fae48de3          	beq	s1,a4,920 <malloc+0x78>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	02071693          	slli	a3,a4,0x20
 974:	01c6d713          	srli	a4,a3,0x1c
 978:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97e:	00000717          	auipc	a4,0x0
 982:	68a73123          	sd	a0,1666(a4) # 1000 <freep>
      return (void*)(p + 1);
 986:	01078513          	addi	a0,a5,16
  }
}
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	74a2                	ld	s1,40(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
 996:	7902                	ld	s2,32(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
 99e:	b7f5                	j	98a <malloc+0xe2>
