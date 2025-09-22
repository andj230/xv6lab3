
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	70a78793          	addi	a5,a5,1802 # 7718 <malloc+0x258a>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	4a1040ef          	jal	4ce6 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	22a50513          	addi	a0,a0,554 # 5290 <malloc+0x102>
      6e:	06c050ef          	jal	50da <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	433040ef          	jal	4ca6 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	0000a797          	auipc	a5,0xa
      7c:	52078793          	addi	a5,a5,1312 # a598 <uninit>
      80:	0000d697          	auipc	a3,0xd
      84:	c2868693          	addi	a3,a3,-984 # cca8 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	21050513          	addi	a0,a0,528 # 52b0 <malloc+0x122>
      a8:	032050ef          	jal	50da <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	3f9040ef          	jal	4ca6 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	20850513          	addi	a0,a0,520 # 52c8 <malloc+0x13a>
      c8:	41f040ef          	jal	4ce6 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	3ff040ef          	jal	4cce <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	21250513          	addi	a0,a0,530 # 52e8 <malloc+0x15a>
      de:	409040ef          	jal	4ce6 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	1de50513          	addi	a0,a0,478 # 52d0 <malloc+0x142>
      fa:	7e1040ef          	jal	50da <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	3a7040ef          	jal	4ca6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	1f250513          	addi	a0,a0,498 # 52f8 <malloc+0x16a>
     10e:	7cd040ef          	jal	50da <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	393040ef          	jal	4ca6 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	1f850513          	addi	a0,a0,504 # 5320 <malloc+0x192>
     130:	3c7040ef          	jal	4cf6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	1e850513          	addi	a0,a0,488 # 5320 <malloc+0x192>
     140:	3a7040ef          	jal	4ce6 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	1e858593          	addi	a1,a1,488 # 5330 <malloc+0x1a2>
     150:	377040ef          	jal	4cc6 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	1c850513          	addi	a0,a0,456 # 5320 <malloc+0x192>
     160:	387040ef          	jal	4ce6 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	1d058593          	addi	a1,a1,464 # 5338 <malloc+0x1aa>
     170:	8526                	mv	a0,s1
     172:	355040ef          	jal	4cc6 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	1a450513          	addi	a0,a0,420 # 5320 <malloc+0x192>
     184:	373040ef          	jal	4cf6 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	345040ef          	jal	4cce <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	33f040ef          	jal	4cce <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	19a50513          	addi	a0,a0,410 # 5340 <malloc+0x1b2>
     1ae:	72d040ef          	jal	50da <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	2f3040ef          	jal	4ca6 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	303040ef          	jal	4ce6 <open>
    close(fd);
     1e8:	2e7040ef          	jal	4cce <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	2e5040ef          	jal	4cf6 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	12450513          	addi	a0,a0,292 # 5368 <malloc+0x1da>
     24c:	2ab040ef          	jal	4cf6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	114a8a93          	addi	s5,s5,276 # 5368 <malloc+0x1da>
      int cc = write(fd, buf, sz);
     25c:	0000da17          	auipc	s4,0xd
     260:	a4ca0a13          	addi	s4,s4,-1460 # cca8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <rmdot+0x19>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	277040ef          	jal	4ce6 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	249040ef          	jal	4cc6 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	239040ef          	jal	4cc6 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	237040ef          	jal	4cce <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	259040ef          	jal	4cf6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	0b650513          	addi	a0,a0,182 # 5378 <malloc+0x1ea>
     2ca:	611040ef          	jal	50da <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	1d7040ef          	jal	4ca6 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	0bc50513          	addi	a0,a0,188 # 5398 <malloc+0x20a>
     2e4:	5f7040ef          	jal	50da <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	1bd040ef          	jal	4ca6 <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	0b250513          	addi	a0,a0,178 # 53b0 <malloc+0x222>
     306:	1f1040ef          	jal	4cf6 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	0a298993          	addi	s3,s3,162 # 53b0 <malloc+0x222>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	1c5040ef          	jal	4ce6 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	197040ef          	jal	4cc6 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	199040ef          	jal	4cce <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	1bb040ef          	jal	4cf6 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	06650513          	addi	a0,a0,102 # 53b0 <malloc+0x222>
     352:	195040ef          	jal	4ce6 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	fda58593          	addi	a1,a1,-38 # 5338 <malloc+0x1aa>
     366:	161040ef          	jal	4cc6 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	06050513          	addi	a0,a0,96 # 53d0 <malloc+0x242>
     378:	563040ef          	jal	50da <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	129040ef          	jal	4ca6 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	03650513          	addi	a0,a0,54 # 53b8 <malloc+0x22a>
     38a:	551040ef          	jal	50da <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	117040ef          	jal	4ca6 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	02450513          	addi	a0,a0,36 # 53b8 <malloc+0x22a>
     39c:	53f040ef          	jal	50da <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	105040ef          	jal	4ca6 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	127040ef          	jal	4cce <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	00450513          	addi	a0,a0,4 # 53b0 <malloc+0x222>
     3b4:	143040ef          	jal	4cf6 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	0ed040ef          	jal	4ca6 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	0ed040ef          	jal	4cf6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	0d1040ef          	jal	4ce6 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	0b1040ef          	jal	4cce <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	091040ef          	jal	4cf6 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	28878793          	addi	a5,a5,648 # 7718 <malloc+0x258a>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	f22a0a13          	addi	s4,s4,-222 # 53e0 <malloc+0x252>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	017040ef          	jal	4ce6 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	7e8040ef          	jal	4cc6 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	7e6040ef          	jal	4cce <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	009040ef          	jal	4cf6 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	7ce040ef          	jal	4cc6 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	7b2040ef          	jal	4cb6 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	7b2040ef          	jal	4cc6 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	7ae040ef          	jal	4cce <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	7a6040ef          	jal	4cce <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	ea450513          	addi	a0,a0,-348 # 53e8 <malloc+0x25a>
     54c:	38f040ef          	jal	50da <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	754040ef          	jal	4ca6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	ea650513          	addi	a0,a0,-346 # 5400 <malloc+0x272>
     562:	379040ef          	jal	50da <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	73e040ef          	jal	4ca6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	ec050513          	addi	a0,a0,-320 # 5430 <malloc+0x2a2>
     578:	363040ef          	jal	50da <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	728040ef          	jal	4ca6 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	ede50513          	addi	a0,a0,-290 # 5460 <malloc+0x2d2>
     58a:	351040ef          	jal	50da <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	716040ef          	jal	4ca6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	ed850513          	addi	a0,a0,-296 # 5470 <malloc+0x2e2>
     5a0:	33b040ef          	jal	50da <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	700040ef          	jal	4ca6 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	15a78793          	addi	a5,a5,346 # 7718 <malloc+0x258a>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	eaea0a13          	addi	s4,s4,-338 # 54a0 <malloc+0x312>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	d3ea8a93          	addi	s5,s5,-706 # 5338 <malloc+0x1aa>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	6dc040ef          	jal	4ce6 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	6a6040ef          	jal	4cbe <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	6ac040ef          	jal	4cce <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	68c040ef          	jal	4cb6 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	68c040ef          	jal	4cc6 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	672040ef          	jal	4cbe <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	676040ef          	jal	4cce <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	66e040ef          	jal	4cce <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	e2a50513          	addi	a0,a0,-470 # 54a8 <malloc+0x31a>
     686:	255040ef          	jal	50da <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	61a040ef          	jal	4ca6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	e2c50513          	addi	a0,a0,-468 # 54c0 <malloc+0x332>
     69c:	23f040ef          	jal	50da <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	604040ef          	jal	4ca6 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	dba50513          	addi	a0,a0,-582 # 5460 <malloc+0x2d2>
     6ae:	22d040ef          	jal	50da <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	5f2040ef          	jal	4ca6 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	e3850513          	addi	a0,a0,-456 # 54f0 <malloc+0x362>
     6c0:	21b040ef          	jal	50da <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	5e0040ef          	jal	4ca6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	e3a50513          	addi	a0,a0,-454 # 5508 <malloc+0x37a>
     6d6:	205040ef          	jal	50da <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	5ca040ef          	jal	4ca6 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	c2c50513          	addi	a0,a0,-980 # 5320 <malloc+0x192>
     6fc:	5fa040ef          	jal	4cf6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	c1c50513          	addi	a0,a0,-996 # 5320 <malloc+0x192>
     70c:	5da040ef          	jal	4ce6 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	c1c58593          	addi	a1,a1,-996 # 5330 <malloc+0x1a2>
     71c:	5aa040ef          	jal	4cc6 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	5ac040ef          	jal	4cce <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	bf850513          	addi	a0,a0,-1032 # 5320 <malloc+0x192>
     730:	5b6040ef          	jal	4ce6 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	580040ef          	jal	4cbe <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	bd450513          	addi	a0,a0,-1068 # 5320 <malloc+0x192>
     754:	592040ef          	jal	4ce6 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	bc450513          	addi	a0,a0,-1084 # 5320 <malloc+0x192>
     764:	582040ef          	jal	4ce6 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	54c040ef          	jal	4cbe <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	53a040ef          	jal	4cbe <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	e0a58593          	addi	a1,a1,-502 # 5598 <malloc+0x40a>
     796:	854e                	mv	a0,s3
     798:	52e040ef          	jal	4cc6 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	518040ef          	jal	4cbe <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	504040ef          	jal	4cbe <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	b5c50513          	addi	a0,a0,-1188 # 5320 <malloc+0x192>
     7cc:	52a040ef          	jal	4cf6 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	4fc040ef          	jal	4cce <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	4f6040ef          	jal	4cce <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	4f0040ef          	jal	4cce <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	d4050513          	addi	a0,a0,-704 # 5538 <malloc+0x3aa>
     800:	0db040ef          	jal	50da <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	4a0040ef          	jal	4ca6 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	d4c50513          	addi	a0,a0,-692 # 5558 <malloc+0x3ca>
     814:	0c7040ef          	jal	50da <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	d4c50513          	addi	a0,a0,-692 # 5568 <malloc+0x3da>
     824:	0b7040ef          	jal	50da <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	47c040ef          	jal	4ca6 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	d5850513          	addi	a0,a0,-680 # 5588 <malloc+0x3fa>
     838:	0a3040ef          	jal	50da <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	d2850513          	addi	a0,a0,-728 # 5568 <malloc+0x3da>
     848:	093040ef          	jal	50da <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	458040ef          	jal	4ca6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	d4a50513          	addi	a0,a0,-694 # 55a0 <malloc+0x412>
     85e:	07d040ef          	jal	50da <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	442040ef          	jal	4ca6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	d5450513          	addi	a0,a0,-684 # 55c0 <malloc+0x432>
     874:	067040ef          	jal	50da <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	42c040ef          	jal	4ca6 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	d4850513          	addi	a0,a0,-696 # 55e0 <malloc+0x452>
     8a0:	446040ef          	jal	4ce6 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	d5c98993          	addi	s3,s3,-676 # 5608 <malloc+0x47a>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	d8ca8a93          	addi	s5,s5,-628 # 5640 <malloc+0x4b2>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	400040ef          	jal	4cc6 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	3f0040ef          	jal	4cc6 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	3e6040ef          	jal	4cce <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	cf250513          	addi	a0,a0,-782 # 55e0 <malloc+0x452>
     8f6:	3f0040ef          	jal	4ce6 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	3a458593          	addi	a1,a1,932 # cca8 <buf>
     90c:	3b2040ef          	jal	4cbe <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	3b4040ef          	jal	4cce <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	cc250513          	addi	a0,a0,-830 # 55e0 <malloc+0x452>
     926:	3d0040ef          	jal	4cf6 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	ca450513          	addi	a0,a0,-860 # 55e8 <malloc+0x45a>
     94c:	78e040ef          	jal	50da <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	354040ef          	jal	4ca6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	cbe50513          	addi	a0,a0,-834 # 5618 <malloc+0x48a>
     962:	778040ef          	jal	50da <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	33e040ef          	jal	4ca6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	ce050513          	addi	a0,a0,-800 # 5650 <malloc+0x4c2>
     978:	762040ef          	jal	50da <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	328040ef          	jal	4ca6 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	cf450513          	addi	a0,a0,-780 # 5678 <malloc+0x4ea>
     98c:	74e040ef          	jal	50da <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	314040ef          	jal	4ca6 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	d0050513          	addi	a0,a0,-768 # 5698 <malloc+0x50a>
     9a0:	73a040ef          	jal	50da <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	300040ef          	jal	4ca6 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	d0450513          	addi	a0,a0,-764 # 56b0 <malloc+0x522>
     9b4:	726040ef          	jal	50da <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	2ec040ef          	jal	4ca6 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	cfa50513          	addi	a0,a0,-774 # 56d0 <malloc+0x542>
     9de:	308040ef          	jal	4ce6 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	2c290913          	addi	s2,s2,706 # cca8 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	2c4040ef          	jal	4cc6 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	2b8040ef          	jal	4cce <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	cb450513          	addi	a0,a0,-844 # 56d0 <malloc+0x542>
     a24:	2c2040ef          	jal	4ce6 <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000c917          	auipc	s2,0xc
     a30:	27c90913          	addi	s2,s2,636 # cca8 <buf>
  if(fd < 0){
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	27e040ef          	jal	4cbe <read>
    if(i == 0){
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	c7c50513          	addi	a0,a0,-900 # 56d8 <malloc+0x54a>
     a64:	676040ef          	jal	50da <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	23c040ef          	jal	4ca6 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	c8650513          	addi	a0,a0,-890 # 56f8 <malloc+0x56a>
     a7a:	660040ef          	jal	50da <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	226040ef          	jal	4ca6 <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	c9a50513          	addi	a0,a0,-870 # 5720 <malloc+0x592>
     a8e:	64c040ef          	jal	50da <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	212040ef          	jal	4ca6 <exit>
      if(n != MAXFILE){
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	22c040ef          	jal	4cce <close>
  if(unlink("big") < 0){
     aa6:	00005517          	auipc	a0,0x5
     aaa:	c2a50513          	addi	a0,a0,-982 # 56d0 <malloc+0x542>
     aae:	248040ef          	jal	4cf6 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	c7450513          	addi	a0,a0,-908 # 5740 <malloc+0x5b2>
     ad4:	606040ef          	jal	50da <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	1cc040ef          	jal	4ca6 <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	c8650513          	addi	a0,a0,-890 # 5768 <malloc+0x5da>
     aea:	5f0040ef          	jal	50da <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	1b6040ef          	jal	4ca6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	c8850513          	addi	a0,a0,-888 # 5780 <malloc+0x5f2>
     b00:	5da040ef          	jal	50da <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	1a0040ef          	jal	4ca6 <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	c9c50513          	addi	a0,a0,-868 # 57a8 <malloc+0x61a>
     b14:	5c6040ef          	jal	50da <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	18c040ef          	jal	4ca6 <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	c8e50513          	addi	a0,a0,-882 # 57c0 <malloc+0x632>
     b3a:	1ac040ef          	jal	4ce6 <open>
  if(fd < 0){
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	caa58593          	addi	a1,a1,-854 # 57f0 <malloc+0x662>
     b4e:	178040ef          	jal	4cc6 <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	17a040ef          	jal	4cce <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	c6650513          	addi	a0,a0,-922 # 57c0 <malloc+0x632>
     b62:	184040ef          	jal	4ce6 <open>
     b66:	84aa                	mv	s1,a0
  if(fd < 0){
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6c:	00005517          	auipc	a0,0x5
     b70:	c5450513          	addi	a0,a0,-940 # 57c0 <malloc+0x632>
     b74:	182040ef          	jal	4cf6 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	c4250513          	addi	a0,a0,-958 # 57c0 <malloc+0x632>
     b86:	160040ef          	jal	4ce6 <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	caa58593          	addi	a1,a1,-854 # 5838 <malloc+0x6aa>
     b96:	130040ef          	jal	4cc6 <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	132040ef          	jal	4cce <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba0:	660d                	lui	a2,0x3
     ba2:	0000c597          	auipc	a1,0xc
     ba6:	10658593          	addi	a1,a1,262 # cca8 <buf>
     baa:	8526                	mv	a0,s1
     bac:	112040ef          	jal	4cbe <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb6:	0000c717          	auipc	a4,0xc
     bba:	0f274703          	lbu	a4,242(a4) # cca8 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc6:	4629                	li	a2,10
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0e058593          	addi	a1,a1,224 # cca8 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	0f4040ef          	jal	4cc6 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	0f0040ef          	jal	4cce <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	bde50513          	addi	a0,a0,-1058 # 57c0 <malloc+0x632>
     bea:	10c040ef          	jal	4cf6 <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	bd250513          	addi	a0,a0,-1070 # 57d0 <malloc+0x642>
     c06:	4d4040ef          	jal	50da <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	09a040ef          	jal	4ca6 <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	be650513          	addi	a0,a0,-1050 # 57f8 <malloc+0x66a>
     c1a:	4c0040ef          	jal	50da <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	086040ef          	jal	4ca6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	bf250513          	addi	a0,a0,-1038 # 5818 <malloc+0x68a>
     c2e:	4ac040ef          	jal	50da <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	072040ef          	jal	4ca6 <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	c0650513          	addi	a0,a0,-1018 # 5840 <malloc+0x6b2>
     c42:	498040ef          	jal	50da <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	05e040ef          	jal	4ca6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	c1250513          	addi	a0,a0,-1006 # 5860 <malloc+0x6d2>
     c56:	484040ef          	jal	50da <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	04a040ef          	jal	4ca6 <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	c1e50513          	addi	a0,a0,-994 # 5880 <malloc+0x6f2>
     c6a:	470040ef          	jal	50da <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	036040ef          	jal	4ca6 <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	c1e50513          	addi	a0,a0,-994 # 58a0 <malloc+0x712>
     c8a:	06c040ef          	jal	4cf6 <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	c1a50513          	addi	a0,a0,-998 # 58a8 <malloc+0x71a>
     c96:	060040ef          	jal	4cf6 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	c0250513          	addi	a0,a0,-1022 # 58a0 <malloc+0x712>
     ca6:	040040ef          	jal	4ce6 <open>
  if(fd < 0){
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	b3e58593          	addi	a1,a1,-1218 # 57f0 <malloc+0x662>
     cba:	00c040ef          	jal	4cc6 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	008040ef          	jal	4cce <close>
  if(link("lf1", "lf2") < 0){
     cca:	00005597          	auipc	a1,0x5
     cce:	bde58593          	addi	a1,a1,-1058 # 58a8 <malloc+0x71a>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	bce50513          	addi	a0,a0,-1074 # 58a0 <malloc+0x712>
     cda:	02c040ef          	jal	4d06 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	bbe50513          	addi	a0,a0,-1090 # 58a0 <malloc+0x712>
     cea:	00c040ef          	jal	4cf6 <unlink>
  if(open("lf1", 0) >= 0){
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	bb050513          	addi	a0,a0,-1104 # 58a0 <malloc+0x712>
     cf8:	7ef030ef          	jal	4ce6 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	ba650513          	addi	a0,a0,-1114 # 58a8 <malloc+0x71a>
     d0a:	7dd030ef          	jal	4ce6 <open>
     d0e:	84aa                	mv	s1,a0
  if(fd < 0){
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d14:	660d                	lui	a2,0x3
     d16:	0000c597          	auipc	a1,0xc
     d1a:	f9258593          	addi	a1,a1,-110 # cca8 <buf>
     d1e:	7a1030ef          	jal	4cbe <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	7a5030ef          	jal	4cce <close>
  if(link("lf2", "lf2") >= 0){
     d2e:	00005597          	auipc	a1,0x5
     d32:	b7a58593          	addi	a1,a1,-1158 # 58a8 <malloc+0x71a>
     d36:	852e                	mv	a0,a1
     d38:	7cf030ef          	jal	4d06 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	b6850513          	addi	a0,a0,-1176 # 58a8 <malloc+0x71a>
     d48:	7af030ef          	jal	4cf6 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4c:	00005597          	auipc	a1,0x5
     d50:	b5458593          	addi	a1,a1,-1196 # 58a0 <malloc+0x712>
     d54:	00005517          	auipc	a0,0x5
     d58:	b5450513          	addi	a0,a0,-1196 # 58a8 <malloc+0x71a>
     d5c:	7ab030ef          	jal	4d06 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d64:	00005597          	auipc	a1,0x5
     d68:	b3c58593          	addi	a1,a1,-1220 # 58a0 <malloc+0x712>
     d6c:	00005517          	auipc	a0,0x5
     d70:	c4450513          	addi	a0,a0,-956 # 59b0 <malloc+0x822>
     d74:	793030ef          	jal	4d06 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	b2650513          	addi	a0,a0,-1242 # 58b0 <malloc+0x722>
     d92:	348040ef          	jal	50da <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	70f030ef          	jal	4ca6 <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	b2a50513          	addi	a0,a0,-1238 # 58c8 <malloc+0x73a>
     da6:	334040ef          	jal	50da <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	6fb030ef          	jal	4ca6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	b2e50513          	addi	a0,a0,-1234 # 58e0 <malloc+0x752>
     dba:	320040ef          	jal	50da <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	6e7030ef          	jal	4ca6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	b3a50513          	addi	a0,a0,-1222 # 5900 <malloc+0x772>
     dce:	30c040ef          	jal	50da <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	6d3030ef          	jal	4ca6 <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	b5650513          	addi	a0,a0,-1194 # 5930 <malloc+0x7a2>
     de2:	2f8040ef          	jal	50da <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	6bf030ef          	jal	4ca6 <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	b5a50513          	addi	a0,a0,-1190 # 5948 <malloc+0x7ba>
     df6:	2e4040ef          	jal	50da <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	6ab030ef          	jal	4ca6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	b5e50513          	addi	a0,a0,-1186 # 5960 <malloc+0x7d2>
     e0a:	2d0040ef          	jal	50da <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	697030ef          	jal	4ca6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	b7250513          	addi	a0,a0,-1166 # 5988 <malloc+0x7fa>
     e1e:	2bc040ef          	jal	50da <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	683030ef          	jal	4ca6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	b8e50513          	addi	a0,a0,-1138 # 59b8 <malloc+0x82a>
     e32:	2a8040ef          	jal	50da <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	66f030ef          	jal	4ca6 <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e54:	00005997          	auipc	s3,0x5
     e58:	b8498993          	addi	s3,s3,-1148 # 59d8 <malloc+0x84a>
     e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	69f030ef          	jal	4d06 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	b5c50513          	addi	a0,a0,-1188 # 59e8 <malloc+0x85a>
     e94:	246040ef          	jal	50da <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	60d030ef          	jal	4ca6 <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	b5450513          	addi	a0,a0,-1196 # 5a08 <malloc+0x87a>
     ebc:	63b030ef          	jal	4cf6 <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	b4450513          	addi	a0,a0,-1212 # 5a08 <malloc+0x87a>
     ecc:	61b030ef          	jal	4ce6 <open>
  if(fd < 0){
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	5fb030ef          	jal	4cce <close>
  for(i = 0; i < N; i++){
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ede:	00005a17          	auipc	s4,0x5
     ee2:	b2aa0a13          	addi	s4,s4,-1238 # 5a08 <malloc+0x87a>
  for(i = 0; i < N; i++){
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	5e9030ef          	jal	4d06 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	adc50513          	addi	a0,a0,-1316 # 5a08 <malloc+0x87a>
     f34:	5c3030ef          	jal	4cf6 <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	585030ef          	jal	4cf6 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	a7c50513          	addi	a0,a0,-1412 # 5a10 <malloc+0x882>
     f9c:	13e040ef          	jal	50da <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	505030ef          	jal	4ca6 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	a8250513          	addi	a0,a0,-1406 # 5a30 <malloc+0x8a2>
     fb6:	124040ef          	jal	50da <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	4eb030ef          	jal	4ca6 <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	a9650513          	addi	a0,a0,-1386 # 5a58 <malloc+0x8ca>
     fca:	110040ef          	jal	50da <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	4d7030ef          	jal	4ca6 <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00008497          	auipc	s1,0x8
     fe6:	01e48493          	addi	s1,s1,30 # 9000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	4ef030ef          	jal	4cde <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	4c1030ef          	jal	4cb6 <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	4ab030ef          	jal	4ca6 <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1db8>
    argv[0] = (char*)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	2ae98993          	addi	s3,s3,686 # 52c8 <malloc+0x13a>
    argv[0] = (char*)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	4af030ef          	jal	4cde <exec>
  for(int i = 0; i < 50000; i++){
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	46d030ef          	jal	4ca6 <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	addi	a0,s0,-152
    1064:	493030ef          	jal	4cf6 <unlink>
  if(ret != -1){
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	471030ef          	jal	4ce6 <open>
  if(fd != -1){
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
  ret = link(b, b);
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	481030ef          	jal	4d06 <link>
  if(ret != -1){
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1090:	00006797          	auipc	a5,0x6
    1094:	b1878793          	addi	a5,a5,-1256 # 6ba8 <malloc+0x1a1a>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	437030ef          	jal	4cde <exec>
  if(ret != -1){
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
  int pid = fork();
    10b2:	3ed030ef          	jal	4c9e <fork>
  if(pid < 0){
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
  if(pid == 0){
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00008797          	auipc	a5,0x8
    10c2:	4d278793          	addi	a5,a5,1234 # 9590 <big.0>
    10c6:	00009697          	auipc	a3,0x9
    10ca:	4ca68693          	addi	a3,a3,1226 # a590 <big.0+0x1000>
      big[i] = 'x';
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d6:	0785                	addi	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10dc:	00009797          	auipc	a5,0x9
    10e0:	4a078a23          	sb	zero,1204(a5) # a590 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e4:	00006797          	auipc	a5,0x6
    10e8:	63478793          	addi	a5,a5,1588 # 7718 <malloc+0x258a>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1104:	f3040593          	addi	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	1c050513          	addi	a0,a0,448 # 52c8 <malloc+0x13a>
    1110:	3cf030ef          	jal	4cde <exec>
    if(ret != -1){
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111a:	55fd                	li	a1,-1
    111c:	00005517          	auipc	a0,0x5
    1120:	9e450513          	addi	a0,a0,-1564 # 5b00 <malloc+0x972>
    1124:	7b7030ef          	jal	50da <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	37d030ef          	jal	4ca6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	addi	a1,s0,-152
    1134:	00005517          	auipc	a0,0x5
    1138:	94450513          	addi	a0,a0,-1724 # 5a78 <malloc+0x8ea>
    113c:	79f030ef          	jal	50da <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	365030ef          	jal	4ca6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	addi	a1,s0,-152
    114c:	00005517          	auipc	a0,0x5
    1150:	94c50513          	addi	a0,a0,-1716 # 5a98 <malloc+0x90a>
    1154:	787030ef          	jal	50da <printf>
    exit(1);
    1158:	4505                	li	a0,1
    115a:	34d030ef          	jal	4ca6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	addi	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00005517          	auipc	a0,0x5
    116a:	95250513          	addi	a0,a0,-1710 # 5ab8 <malloc+0x92a>
    116e:	76d030ef          	jal	50da <printf>
    exit(1);
    1172:	4505                	li	a0,1
    1174:	333030ef          	jal	4ca6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1178:	567d                	li	a2,-1
    117a:	f6840593          	addi	a1,s0,-152
    117e:	00005517          	auipc	a0,0x5
    1182:	96250513          	addi	a0,a0,-1694 # 5ae0 <malloc+0x952>
    1186:	755030ef          	jal	50da <printf>
    exit(1);
    118a:	4505                	li	a0,1
    118c:	31b030ef          	jal	4ca6 <exit>
    printf("fork failed\n");
    1190:	00006517          	auipc	a0,0x6
    1194:	f7050513          	addi	a0,a0,-144 # 7100 <malloc+0x1f72>
    1198:	743030ef          	jal	50da <printf>
    exit(1);
    119c:	4505                	li	a0,1
    119e:	309030ef          	jal	4ca6 <exit>
    exit(747); // OK
    11a2:	2eb00513          	li	a0,747
    11a6:	301030ef          	jal	4ca6 <exit>
  int st = 0;
    11aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11ae:	f5440513          	addi	a0,s0,-172
    11b2:	2fd030ef          	jal	4cae <wait>
  if(st != 747){
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
}
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	addi	sp,sp,208
    11c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ca:	00005517          	auipc	a0,0x5
    11ce:	95e50513          	addi	a0,a0,-1698 # 5b28 <malloc+0x99a>
    11d2:	709030ef          	jal	50da <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	2cf030ef          	jal	4ca6 <exit>

00000000000011dc <truncate3>:
{
    11dc:	7159                	addi	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	e8ca                	sd	s2,80(sp)
    11e4:	1880                	addi	s0,sp,112
    11e6:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11e8:	60100593          	li	a1,1537
    11ec:	00004517          	auipc	a0,0x4
    11f0:	13450513          	addi	a0,a0,308 # 5320 <malloc+0x192>
    11f4:	2f3030ef          	jal	4ce6 <open>
    11f8:	2d7030ef          	jal	4cce <close>
  pid = fork();
    11fc:	2a3030ef          	jal	4c9e <fork>
  if(pid < 0){
    1200:	06054663          	bltz	a0,126c <truncate3+0x90>
  if(pid == 0){
    1204:	e55d                	bnez	a0,12b2 <truncate3+0xd6>
    1206:	eca6                	sd	s1,88(sp)
    1208:	e4ce                	sd	s3,72(sp)
    120a:	e0d2                	sd	s4,64(sp)
    120c:	fc56                	sd	s5,56(sp)
    120e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1212:	00004a17          	auipc	s4,0x4
    1216:	10ea0a13          	addi	s4,s4,270 # 5320 <malloc+0x192>
      int n = write(fd, "1234567890", 10);
    121a:	00005a97          	auipc	s5,0x5
    121e:	96ea8a93          	addi	s5,s5,-1682 # 5b88 <malloc+0x9fa>
      int fd = open("truncfile", O_WRONLY);
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	2c1030ef          	jal	4ce6 <open>
    122a:	84aa                	mv	s1,a0
      if(fd < 0){
    122c:	04054e63          	bltz	a0,1288 <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	293030ef          	jal	4cc6 <write>
      if(n != 10){
    1238:	47a9                	li	a5,10
    123a:	06f51163          	bne	a0,a5,129c <truncate3+0xc0>
      close(fd);
    123e:	8526                	mv	a0,s1
    1240:	28f030ef          	jal	4cce <close>
      fd = open("truncfile", O_RDONLY);
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	29f030ef          	jal	4ce6 <open>
    124c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    124e:	02000613          	li	a2,32
    1252:	f9840593          	addi	a1,s0,-104
    1256:	269030ef          	jal	4cbe <read>
      close(fd);
    125a:	8526                	mv	a0,s1
    125c:	273030ef          	jal	4cce <close>
    for(int i = 0; i < 100; i++){
    1260:	39fd                	addiw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    exit(0);
    1266:	4501                	li	a0,0
    1268:	23f030ef          	jal	4ca6 <exit>
    126c:	eca6                	sd	s1,88(sp)
    126e:	e4ce                	sd	s3,72(sp)
    1270:	e0d2                	sd	s4,64(sp)
    1272:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1274:	85ca                	mv	a1,s2
    1276:	00005517          	auipc	a0,0x5
    127a:	8e250513          	addi	a0,a0,-1822 # 5b58 <malloc+0x9ca>
    127e:	65d030ef          	jal	50da <printf>
    exit(1);
    1282:	4505                	li	a0,1
    1284:	223030ef          	jal	4ca6 <exit>
        printf("%s: open failed\n", s);
    1288:	85ca                	mv	a1,s2
    128a:	00005517          	auipc	a0,0x5
    128e:	8e650513          	addi	a0,a0,-1818 # 5b70 <malloc+0x9e2>
    1292:	649030ef          	jal	50da <printf>
        exit(1);
    1296:	4505                	li	a0,1
    1298:	20f030ef          	jal	4ca6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    129c:	862a                	mv	a2,a0
    129e:	85ca                	mv	a1,s2
    12a0:	00005517          	auipc	a0,0x5
    12a4:	8f850513          	addi	a0,a0,-1800 # 5b98 <malloc+0xa0a>
    12a8:	633030ef          	jal	50da <printf>
        exit(1);
    12ac:	4505                	li	a0,1
    12ae:	1f9030ef          	jal	4ca6 <exit>
    12b2:	eca6                	sd	s1,88(sp)
    12b4:	e4ce                	sd	s3,72(sp)
    12b6:	e0d2                	sd	s4,64(sp)
    12b8:	fc56                	sd	s5,56(sp)
    12ba:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12be:	00004a17          	auipc	s4,0x4
    12c2:	062a0a13          	addi	s4,s4,98 # 5320 <malloc+0x192>
    int n = write(fd, "xxx", 3);
    12c6:	00005a97          	auipc	s5,0x5
    12ca:	8f2a8a93          	addi	s5,s5,-1806 # 5bb8 <malloc+0xa2a>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12ce:	60100593          	li	a1,1537
    12d2:	8552                	mv	a0,s4
    12d4:	213030ef          	jal	4ce6 <open>
    12d8:	84aa                	mv	s1,a0
    if(fd < 0){
    12da:	02054d63          	bltz	a0,1314 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    12de:	460d                	li	a2,3
    12e0:	85d6                	mv	a1,s5
    12e2:	1e5030ef          	jal	4cc6 <write>
    if(n != 3){
    12e6:	478d                	li	a5,3
    12e8:	04f51063          	bne	a0,a5,1328 <truncate3+0x14c>
    close(fd);
    12ec:	8526                	mv	a0,s1
    12ee:	1e1030ef          	jal	4cce <close>
  for(int i = 0; i < 150; i++){
    12f2:	39fd                	addiw	s3,s3,-1
    12f4:	fc099de3          	bnez	s3,12ce <truncate3+0xf2>
  wait(&xstatus);
    12f8:	fbc40513          	addi	a0,s0,-68
    12fc:	1b3030ef          	jal	4cae <wait>
  unlink("truncfile");
    1300:	00004517          	auipc	a0,0x4
    1304:	02050513          	addi	a0,a0,32 # 5320 <malloc+0x192>
    1308:	1ef030ef          	jal	4cf6 <unlink>
  exit(xstatus);
    130c:	fbc42503          	lw	a0,-68(s0)
    1310:	197030ef          	jal	4ca6 <exit>
      printf("%s: open failed\n", s);
    1314:	85ca                	mv	a1,s2
    1316:	00005517          	auipc	a0,0x5
    131a:	85a50513          	addi	a0,a0,-1958 # 5b70 <malloc+0x9e2>
    131e:	5bd030ef          	jal	50da <printf>
      exit(1);
    1322:	4505                	li	a0,1
    1324:	183030ef          	jal	4ca6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1328:	862a                	mv	a2,a0
    132a:	85ca                	mv	a1,s2
    132c:	00005517          	auipc	a0,0x5
    1330:	89450513          	addi	a0,a0,-1900 # 5bc0 <malloc+0xa32>
    1334:	5a7030ef          	jal	50da <printf>
      exit(1);
    1338:	4505                	li	a0,1
    133a:	16d030ef          	jal	4ca6 <exit>

000000000000133e <exectest>:
{
    133e:	715d                	addi	sp,sp,-80
    1340:	e486                	sd	ra,72(sp)
    1342:	e0a2                	sd	s0,64(sp)
    1344:	f84a                	sd	s2,48(sp)
    1346:	0880                	addi	s0,sp,80
    1348:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    134a:	00004797          	auipc	a5,0x4
    134e:	f7e78793          	addi	a5,a5,-130 # 52c8 <malloc+0x13a>
    1352:	fcf43023          	sd	a5,-64(s0)
    1356:	00005797          	auipc	a5,0x5
    135a:	88a78793          	addi	a5,a5,-1910 # 5be0 <malloc+0xa52>
    135e:	fcf43423          	sd	a5,-56(s0)
    1362:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1366:	00005517          	auipc	a0,0x5
    136a:	88250513          	addi	a0,a0,-1918 # 5be8 <malloc+0xa5a>
    136e:	189030ef          	jal	4cf6 <unlink>
  pid = fork();
    1372:	12d030ef          	jal	4c9e <fork>
  if(pid < 0) {
    1376:	02054f63          	bltz	a0,13b4 <exectest+0x76>
    137a:	fc26                	sd	s1,56(sp)
    137c:	84aa                	mv	s1,a0
  if(pid == 0) {
    137e:	e935                	bnez	a0,13f2 <exectest+0xb4>
    close(1);
    1380:	4505                	li	a0,1
    1382:	14d030ef          	jal	4cce <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1386:	20100593          	li	a1,513
    138a:	00005517          	auipc	a0,0x5
    138e:	85e50513          	addi	a0,a0,-1954 # 5be8 <malloc+0xa5a>
    1392:	155030ef          	jal	4ce6 <open>
    if(fd < 0) {
    1396:	02054a63          	bltz	a0,13ca <exectest+0x8c>
    if(fd != 1) {
    139a:	4785                	li	a5,1
    139c:	04f50163          	beq	a0,a5,13de <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    13a0:	85ca                	mv	a1,s2
    13a2:	00005517          	auipc	a0,0x5
    13a6:	86650513          	addi	a0,a0,-1946 # 5c08 <malloc+0xa7a>
    13aa:	531030ef          	jal	50da <printf>
      exit(1);
    13ae:	4505                	li	a0,1
    13b0:	0f7030ef          	jal	4ca6 <exit>
    13b4:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    13b6:	85ca                	mv	a1,s2
    13b8:	00004517          	auipc	a0,0x4
    13bc:	7a050513          	addi	a0,a0,1952 # 5b58 <malloc+0x9ca>
    13c0:	51b030ef          	jal	50da <printf>
     exit(1);
    13c4:	4505                	li	a0,1
    13c6:	0e1030ef          	jal	4ca6 <exit>
      printf("%s: create failed\n", s);
    13ca:	85ca                	mv	a1,s2
    13cc:	00005517          	auipc	a0,0x5
    13d0:	82450513          	addi	a0,a0,-2012 # 5bf0 <malloc+0xa62>
    13d4:	507030ef          	jal	50da <printf>
      exit(1);
    13d8:	4505                	li	a0,1
    13da:	0cd030ef          	jal	4ca6 <exit>
    if(exec("echo", echoargv) < 0){
    13de:	fc040593          	addi	a1,s0,-64
    13e2:	00004517          	auipc	a0,0x4
    13e6:	ee650513          	addi	a0,a0,-282 # 52c8 <malloc+0x13a>
    13ea:	0f5030ef          	jal	4cde <exec>
    13ee:	00054d63          	bltz	a0,1408 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    13f2:	fdc40513          	addi	a0,s0,-36
    13f6:	0b9030ef          	jal	4cae <wait>
    13fa:	02951163          	bne	a0,s1,141c <exectest+0xde>
  if(xstatus != 0)
    13fe:	fdc42503          	lw	a0,-36(s0)
    1402:	c50d                	beqz	a0,142c <exectest+0xee>
    exit(xstatus);
    1404:	0a3030ef          	jal	4ca6 <exit>
      printf("%s: exec echo failed\n", s);
    1408:	85ca                	mv	a1,s2
    140a:	00005517          	auipc	a0,0x5
    140e:	80e50513          	addi	a0,a0,-2034 # 5c18 <malloc+0xa8a>
    1412:	4c9030ef          	jal	50da <printf>
      exit(1);
    1416:	4505                	li	a0,1
    1418:	08f030ef          	jal	4ca6 <exit>
    printf("%s: wait failed!\n", s);
    141c:	85ca                	mv	a1,s2
    141e:	00005517          	auipc	a0,0x5
    1422:	81250513          	addi	a0,a0,-2030 # 5c30 <malloc+0xaa2>
    1426:	4b5030ef          	jal	50da <printf>
    142a:	bfd1                	j	13fe <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    142c:	4581                	li	a1,0
    142e:	00004517          	auipc	a0,0x4
    1432:	7ba50513          	addi	a0,a0,1978 # 5be8 <malloc+0xa5a>
    1436:	0b1030ef          	jal	4ce6 <open>
  if(fd < 0) {
    143a:	02054463          	bltz	a0,1462 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    143e:	4609                	li	a2,2
    1440:	fb840593          	addi	a1,s0,-72
    1444:	07b030ef          	jal	4cbe <read>
    1448:	4789                	li	a5,2
    144a:	02f50663          	beq	a0,a5,1476 <exectest+0x138>
    printf("%s: read failed\n", s);
    144e:	85ca                	mv	a1,s2
    1450:	00004517          	auipc	a0,0x4
    1454:	24850513          	addi	a0,a0,584 # 5698 <malloc+0x50a>
    1458:	483030ef          	jal	50da <printf>
    exit(1);
    145c:	4505                	li	a0,1
    145e:	049030ef          	jal	4ca6 <exit>
    printf("%s: open failed\n", s);
    1462:	85ca                	mv	a1,s2
    1464:	00004517          	auipc	a0,0x4
    1468:	70c50513          	addi	a0,a0,1804 # 5b70 <malloc+0x9e2>
    146c:	46f030ef          	jal	50da <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	035030ef          	jal	4ca6 <exit>
  unlink("echo-ok");
    1476:	00004517          	auipc	a0,0x4
    147a:	77250513          	addi	a0,a0,1906 # 5be8 <malloc+0xa5a>
    147e:	079030ef          	jal	4cf6 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1482:	fb844703          	lbu	a4,-72(s0)
    1486:	04f00793          	li	a5,79
    148a:	00f71863          	bne	a4,a5,149a <exectest+0x15c>
    148e:	fb944703          	lbu	a4,-71(s0)
    1492:	04b00793          	li	a5,75
    1496:	00f70c63          	beq	a4,a5,14ae <exectest+0x170>
    printf("%s: wrong output\n", s);
    149a:	85ca                	mv	a1,s2
    149c:	00004517          	auipc	a0,0x4
    14a0:	7ac50513          	addi	a0,a0,1964 # 5c48 <malloc+0xaba>
    14a4:	437030ef          	jal	50da <printf>
    exit(1);
    14a8:	4505                	li	a0,1
    14aa:	7fc030ef          	jal	4ca6 <exit>
    exit(0);
    14ae:	4501                	li	a0,0
    14b0:	7f6030ef          	jal	4ca6 <exit>

00000000000014b4 <pipe1>:
{
    14b4:	711d                	addi	sp,sp,-96
    14b6:	ec86                	sd	ra,88(sp)
    14b8:	e8a2                	sd	s0,80(sp)
    14ba:	fc4e                	sd	s3,56(sp)
    14bc:	1080                	addi	s0,sp,96
    14be:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    14c0:	fa840513          	addi	a0,s0,-88
    14c4:	7f2030ef          	jal	4cb6 <pipe>
    14c8:	e92d                	bnez	a0,153a <pipe1+0x86>
    14ca:	e4a6                	sd	s1,72(sp)
    14cc:	f852                	sd	s4,48(sp)
    14ce:	84aa                	mv	s1,a0
  pid = fork();
    14d0:	7ce030ef          	jal	4c9e <fork>
    14d4:	8a2a                	mv	s4,a0
  if(pid == 0){
    14d6:	c151                	beqz	a0,155a <pipe1+0xa6>
  } else if(pid > 0){
    14d8:	14a05e63          	blez	a0,1634 <pipe1+0x180>
    14dc:	e0ca                	sd	s2,64(sp)
    14de:	f456                	sd	s5,40(sp)
    close(fds[1]);
    14e0:	fac42503          	lw	a0,-84(s0)
    14e4:	7ea030ef          	jal	4cce <close>
    total = 0;
    14e8:	8a26                	mv	s4,s1
    cc = 1;
    14ea:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    14ec:	0000ba97          	auipc	s5,0xb
    14f0:	7bca8a93          	addi	s5,s5,1980 # cca8 <buf>
    14f4:	864a                	mv	a2,s2
    14f6:	85d6                	mv	a1,s5
    14f8:	fa842503          	lw	a0,-88(s0)
    14fc:	7c2030ef          	jal	4cbe <read>
    1500:	0ea05a63          	blez	a0,15f4 <pipe1+0x140>
      for(i = 0; i < n; i++){
    1504:	0000b717          	auipc	a4,0xb
    1508:	7a470713          	addi	a4,a4,1956 # cca8 <buf>
    150c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1510:	00074683          	lbu	a3,0(a4)
    1514:	0ff4f793          	zext.b	a5,s1
    1518:	2485                	addiw	s1,s1,1
    151a:	0af69d63          	bne	a3,a5,15d4 <pipe1+0x120>
      for(i = 0; i < n; i++){
    151e:	0705                	addi	a4,a4,1
    1520:	fec498e3          	bne	s1,a2,1510 <pipe1+0x5c>
      total += n;
    1524:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1528:	0019179b          	slliw	a5,s2,0x1
    152c:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1530:	670d                	lui	a4,0x3
    1532:	fd2771e3          	bgeu	a4,s2,14f4 <pipe1+0x40>
        cc = sizeof(buf);
    1536:	690d                	lui	s2,0x3
    1538:	bf75                	j	14f4 <pipe1+0x40>
    153a:	e4a6                	sd	s1,72(sp)
    153c:	e0ca                	sd	s2,64(sp)
    153e:	f852                	sd	s4,48(sp)
    1540:	f456                	sd	s5,40(sp)
    1542:	f05a                	sd	s6,32(sp)
    1544:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    1546:	85ce                	mv	a1,s3
    1548:	00004517          	auipc	a0,0x4
    154c:	71850513          	addi	a0,a0,1816 # 5c60 <malloc+0xad2>
    1550:	38b030ef          	jal	50da <printf>
    exit(1);
    1554:	4505                	li	a0,1
    1556:	750030ef          	jal	4ca6 <exit>
    155a:	e0ca                	sd	s2,64(sp)
    155c:	f456                	sd	s5,40(sp)
    155e:	f05a                	sd	s6,32(sp)
    1560:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1562:	fa842503          	lw	a0,-88(s0)
    1566:	768030ef          	jal	4cce <close>
    for(n = 0; n < N; n++){
    156a:	0000bb17          	auipc	s6,0xb
    156e:	73eb0b13          	addi	s6,s6,1854 # cca8 <buf>
    1572:	416004bb          	negw	s1,s6
    1576:	0ff4f493          	zext.b	s1,s1
    157a:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    157e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1580:	6a85                	lui	s5,0x1
    1582:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xef>
{
    1586:	87da                	mv	a5,s6
        buf[i] = seq++;
    1588:	0097873b          	addw	a4,a5,s1
    158c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1590:	0785                	addi	a5,a5,1
    1592:	ff279be3          	bne	a5,s2,1588 <pipe1+0xd4>
    1596:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    159a:	40900613          	li	a2,1033
    159e:	85de                	mv	a1,s7
    15a0:	fac42503          	lw	a0,-84(s0)
    15a4:	722030ef          	jal	4cc6 <write>
    15a8:	40900793          	li	a5,1033
    15ac:	00f51a63          	bne	a0,a5,15c0 <pipe1+0x10c>
    for(n = 0; n < N; n++){
    15b0:	24a5                	addiw	s1,s1,9
    15b2:	0ff4f493          	zext.b	s1,s1
    15b6:	fd5a18e3          	bne	s4,s5,1586 <pipe1+0xd2>
    exit(0);
    15ba:	4501                	li	a0,0
    15bc:	6ea030ef          	jal	4ca6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15c0:	85ce                	mv	a1,s3
    15c2:	00004517          	auipc	a0,0x4
    15c6:	6b650513          	addi	a0,a0,1718 # 5c78 <malloc+0xaea>
    15ca:	311030ef          	jal	50da <printf>
        exit(1);
    15ce:	4505                	li	a0,1
    15d0:	6d6030ef          	jal	4ca6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15d4:	85ce                	mv	a1,s3
    15d6:	00004517          	auipc	a0,0x4
    15da:	6ba50513          	addi	a0,a0,1722 # 5c90 <malloc+0xb02>
    15de:	2fd030ef          	jal	50da <printf>
          return;
    15e2:	64a6                	ld	s1,72(sp)
    15e4:	6906                	ld	s2,64(sp)
    15e6:	7a42                	ld	s4,48(sp)
    15e8:	7aa2                	ld	s5,40(sp)
}
    15ea:	60e6                	ld	ra,88(sp)
    15ec:	6446                	ld	s0,80(sp)
    15ee:	79e2                	ld	s3,56(sp)
    15f0:	6125                	addi	sp,sp,96
    15f2:	8082                	ret
    if(total != N * SZ){
    15f4:	6785                	lui	a5,0x1
    15f6:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xef>
    15fa:	00fa0f63          	beq	s4,a5,1618 <pipe1+0x164>
    15fe:	f05a                	sd	s6,32(sp)
    1600:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1602:	8652                	mv	a2,s4
    1604:	85ce                	mv	a1,s3
    1606:	00004517          	auipc	a0,0x4
    160a:	6a250513          	addi	a0,a0,1698 # 5ca8 <malloc+0xb1a>
    160e:	2cd030ef          	jal	50da <printf>
      exit(1);
    1612:	4505                	li	a0,1
    1614:	692030ef          	jal	4ca6 <exit>
    1618:	f05a                	sd	s6,32(sp)
    161a:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    161c:	fa842503          	lw	a0,-88(s0)
    1620:	6ae030ef          	jal	4cce <close>
    wait(&xstatus);
    1624:	fa440513          	addi	a0,s0,-92
    1628:	686030ef          	jal	4cae <wait>
    exit(xstatus);
    162c:	fa442503          	lw	a0,-92(s0)
    1630:	676030ef          	jal	4ca6 <exit>
    1634:	e0ca                	sd	s2,64(sp)
    1636:	f456                	sd	s5,40(sp)
    1638:	f05a                	sd	s6,32(sp)
    163a:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    163c:	85ce                	mv	a1,s3
    163e:	00004517          	auipc	a0,0x4
    1642:	68a50513          	addi	a0,a0,1674 # 5cc8 <malloc+0xb3a>
    1646:	295030ef          	jal	50da <printf>
    exit(1);
    164a:	4505                	li	a0,1
    164c:	65a030ef          	jal	4ca6 <exit>

0000000000001650 <exitwait>:
{
    1650:	7139                	addi	sp,sp,-64
    1652:	fc06                	sd	ra,56(sp)
    1654:	f822                	sd	s0,48(sp)
    1656:	f426                	sd	s1,40(sp)
    1658:	f04a                	sd	s2,32(sp)
    165a:	ec4e                	sd	s3,24(sp)
    165c:	e852                	sd	s4,16(sp)
    165e:	0080                	addi	s0,sp,64
    1660:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1662:	4901                	li	s2,0
    1664:	06400993          	li	s3,100
    pid = fork();
    1668:	636030ef          	jal	4c9e <fork>
    166c:	84aa                	mv	s1,a0
    if(pid < 0){
    166e:	02054863          	bltz	a0,169e <exitwait+0x4e>
    if(pid){
    1672:	c525                	beqz	a0,16da <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1674:	fcc40513          	addi	a0,s0,-52
    1678:	636030ef          	jal	4cae <wait>
    167c:	02951b63          	bne	a0,s1,16b2 <exitwait+0x62>
      if(i != xstate) {
    1680:	fcc42783          	lw	a5,-52(s0)
    1684:	05279163          	bne	a5,s2,16c6 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    1688:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x43f>
    168a:	fd391fe3          	bne	s2,s3,1668 <exitwait+0x18>
}
    168e:	70e2                	ld	ra,56(sp)
    1690:	7442                	ld	s0,48(sp)
    1692:	74a2                	ld	s1,40(sp)
    1694:	7902                	ld	s2,32(sp)
    1696:	69e2                	ld	s3,24(sp)
    1698:	6a42                	ld	s4,16(sp)
    169a:	6121                	addi	sp,sp,64
    169c:	8082                	ret
      printf("%s: fork failed\n", s);
    169e:	85d2                	mv	a1,s4
    16a0:	00004517          	auipc	a0,0x4
    16a4:	4b850513          	addi	a0,a0,1208 # 5b58 <malloc+0x9ca>
    16a8:	233030ef          	jal	50da <printf>
      exit(1);
    16ac:	4505                	li	a0,1
    16ae:	5f8030ef          	jal	4ca6 <exit>
        printf("%s: wait wrong pid\n", s);
    16b2:	85d2                	mv	a1,s4
    16b4:	00004517          	auipc	a0,0x4
    16b8:	62c50513          	addi	a0,a0,1580 # 5ce0 <malloc+0xb52>
    16bc:	21f030ef          	jal	50da <printf>
        exit(1);
    16c0:	4505                	li	a0,1
    16c2:	5e4030ef          	jal	4ca6 <exit>
        printf("%s: wait wrong exit status\n", s);
    16c6:	85d2                	mv	a1,s4
    16c8:	00004517          	auipc	a0,0x4
    16cc:	63050513          	addi	a0,a0,1584 # 5cf8 <malloc+0xb6a>
    16d0:	20b030ef          	jal	50da <printf>
        exit(1);
    16d4:	4505                	li	a0,1
    16d6:	5d0030ef          	jal	4ca6 <exit>
      exit(i);
    16da:	854a                	mv	a0,s2
    16dc:	5ca030ef          	jal	4ca6 <exit>

00000000000016e0 <twochildren>:
{
    16e0:	1101                	addi	sp,sp,-32
    16e2:	ec06                	sd	ra,24(sp)
    16e4:	e822                	sd	s0,16(sp)
    16e6:	e426                	sd	s1,8(sp)
    16e8:	e04a                	sd	s2,0(sp)
    16ea:	1000                	addi	s0,sp,32
    16ec:	892a                	mv	s2,a0
    16ee:	3e800493          	li	s1,1000
    int pid1 = fork();
    16f2:	5ac030ef          	jal	4c9e <fork>
    if(pid1 < 0){
    16f6:	02054663          	bltz	a0,1722 <twochildren+0x42>
    if(pid1 == 0){
    16fa:	cd15                	beqz	a0,1736 <twochildren+0x56>
      int pid2 = fork();
    16fc:	5a2030ef          	jal	4c9e <fork>
      if(pid2 < 0){
    1700:	02054d63          	bltz	a0,173a <twochildren+0x5a>
      if(pid2 == 0){
    1704:	c529                	beqz	a0,174e <twochildren+0x6e>
        wait(0);
    1706:	4501                	li	a0,0
    1708:	5a6030ef          	jal	4cae <wait>
        wait(0);
    170c:	4501                	li	a0,0
    170e:	5a0030ef          	jal	4cae <wait>
  for(int i = 0; i < 1000; i++){
    1712:	34fd                	addiw	s1,s1,-1
    1714:	fcf9                	bnez	s1,16f2 <twochildren+0x12>
}
    1716:	60e2                	ld	ra,24(sp)
    1718:	6442                	ld	s0,16(sp)
    171a:	64a2                	ld	s1,8(sp)
    171c:	6902                	ld	s2,0(sp)
    171e:	6105                	addi	sp,sp,32
    1720:	8082                	ret
      printf("%s: fork failed\n", s);
    1722:	85ca                	mv	a1,s2
    1724:	00004517          	auipc	a0,0x4
    1728:	43450513          	addi	a0,a0,1076 # 5b58 <malloc+0x9ca>
    172c:	1af030ef          	jal	50da <printf>
      exit(1);
    1730:	4505                	li	a0,1
    1732:	574030ef          	jal	4ca6 <exit>
      exit(0);
    1736:	570030ef          	jal	4ca6 <exit>
        printf("%s: fork failed\n", s);
    173a:	85ca                	mv	a1,s2
    173c:	00004517          	auipc	a0,0x4
    1740:	41c50513          	addi	a0,a0,1052 # 5b58 <malloc+0x9ca>
    1744:	197030ef          	jal	50da <printf>
        exit(1);
    1748:	4505                	li	a0,1
    174a:	55c030ef          	jal	4ca6 <exit>
        exit(0);
    174e:	558030ef          	jal	4ca6 <exit>

0000000000001752 <forkfork>:
{
    1752:	7179                	addi	sp,sp,-48
    1754:	f406                	sd	ra,40(sp)
    1756:	f022                	sd	s0,32(sp)
    1758:	ec26                	sd	s1,24(sp)
    175a:	1800                	addi	s0,sp,48
    175c:	84aa                	mv	s1,a0
    int pid = fork();
    175e:	540030ef          	jal	4c9e <fork>
    if(pid < 0){
    1762:	02054b63          	bltz	a0,1798 <forkfork+0x46>
    if(pid == 0){
    1766:	c139                	beqz	a0,17ac <forkfork+0x5a>
    int pid = fork();
    1768:	536030ef          	jal	4c9e <fork>
    if(pid < 0){
    176c:	02054663          	bltz	a0,1798 <forkfork+0x46>
    if(pid == 0){
    1770:	cd15                	beqz	a0,17ac <forkfork+0x5a>
    wait(&xstatus);
    1772:	fdc40513          	addi	a0,s0,-36
    1776:	538030ef          	jal	4cae <wait>
    if(xstatus != 0) {
    177a:	fdc42783          	lw	a5,-36(s0)
    177e:	ebb9                	bnez	a5,17d4 <forkfork+0x82>
    wait(&xstatus);
    1780:	fdc40513          	addi	a0,s0,-36
    1784:	52a030ef          	jal	4cae <wait>
    if(xstatus != 0) {
    1788:	fdc42783          	lw	a5,-36(s0)
    178c:	e7a1                	bnez	a5,17d4 <forkfork+0x82>
}
    178e:	70a2                	ld	ra,40(sp)
    1790:	7402                	ld	s0,32(sp)
    1792:	64e2                	ld	s1,24(sp)
    1794:	6145                	addi	sp,sp,48
    1796:	8082                	ret
      printf("%s: fork failed", s);
    1798:	85a6                	mv	a1,s1
    179a:	00004517          	auipc	a0,0x4
    179e:	57e50513          	addi	a0,a0,1406 # 5d18 <malloc+0xb8a>
    17a2:	139030ef          	jal	50da <printf>
      exit(1);
    17a6:	4505                	li	a0,1
    17a8:	4fe030ef          	jal	4ca6 <exit>
{
    17ac:	0c800493          	li	s1,200
        int pid1 = fork();
    17b0:	4ee030ef          	jal	4c9e <fork>
        if(pid1 < 0){
    17b4:	00054b63          	bltz	a0,17ca <forkfork+0x78>
        if(pid1 == 0){
    17b8:	cd01                	beqz	a0,17d0 <forkfork+0x7e>
        wait(0);
    17ba:	4501                	li	a0,0
    17bc:	4f2030ef          	jal	4cae <wait>
      for(int j = 0; j < 200; j++){
    17c0:	34fd                	addiw	s1,s1,-1
    17c2:	f4fd                	bnez	s1,17b0 <forkfork+0x5e>
      exit(0);
    17c4:	4501                	li	a0,0
    17c6:	4e0030ef          	jal	4ca6 <exit>
          exit(1);
    17ca:	4505                	li	a0,1
    17cc:	4da030ef          	jal	4ca6 <exit>
          exit(0);
    17d0:	4d6030ef          	jal	4ca6 <exit>
      printf("%s: fork in child failed", s);
    17d4:	85a6                	mv	a1,s1
    17d6:	00004517          	auipc	a0,0x4
    17da:	55250513          	addi	a0,a0,1362 # 5d28 <malloc+0xb9a>
    17de:	0fd030ef          	jal	50da <printf>
      exit(1);
    17e2:	4505                	li	a0,1
    17e4:	4c2030ef          	jal	4ca6 <exit>

00000000000017e8 <reparent2>:
{
    17e8:	1101                	addi	sp,sp,-32
    17ea:	ec06                	sd	ra,24(sp)
    17ec:	e822                	sd	s0,16(sp)
    17ee:	e426                	sd	s1,8(sp)
    17f0:	1000                	addi	s0,sp,32
    17f2:	32000493          	li	s1,800
    int pid1 = fork();
    17f6:	4a8030ef          	jal	4c9e <fork>
    if(pid1 < 0){
    17fa:	00054b63          	bltz	a0,1810 <reparent2+0x28>
    if(pid1 == 0){
    17fe:	c115                	beqz	a0,1822 <reparent2+0x3a>
    wait(0);
    1800:	4501                	li	a0,0
    1802:	4ac030ef          	jal	4cae <wait>
  for(int i = 0; i < 800; i++){
    1806:	34fd                	addiw	s1,s1,-1
    1808:	f4fd                	bnez	s1,17f6 <reparent2+0xe>
  exit(0);
    180a:	4501                	li	a0,0
    180c:	49a030ef          	jal	4ca6 <exit>
      printf("fork failed\n");
    1810:	00006517          	auipc	a0,0x6
    1814:	8f050513          	addi	a0,a0,-1808 # 7100 <malloc+0x1f72>
    1818:	0c3030ef          	jal	50da <printf>
      exit(1);
    181c:	4505                	li	a0,1
    181e:	488030ef          	jal	4ca6 <exit>
      fork();
    1822:	47c030ef          	jal	4c9e <fork>
      fork();
    1826:	478030ef          	jal	4c9e <fork>
      exit(0);
    182a:	4501                	li	a0,0
    182c:	47a030ef          	jal	4ca6 <exit>

0000000000001830 <createdelete>:
{
    1830:	7175                	addi	sp,sp,-144
    1832:	e506                	sd	ra,136(sp)
    1834:	e122                	sd	s0,128(sp)
    1836:	fca6                	sd	s1,120(sp)
    1838:	f8ca                	sd	s2,112(sp)
    183a:	f4ce                	sd	s3,104(sp)
    183c:	f0d2                	sd	s4,96(sp)
    183e:	ecd6                	sd	s5,88(sp)
    1840:	e8da                	sd	s6,80(sp)
    1842:	e4de                	sd	s7,72(sp)
    1844:	e0e2                	sd	s8,64(sp)
    1846:	fc66                	sd	s9,56(sp)
    1848:	0900                	addi	s0,sp,144
    184a:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    184c:	4901                	li	s2,0
    184e:	4991                	li	s3,4
    pid = fork();
    1850:	44e030ef          	jal	4c9e <fork>
    1854:	84aa                	mv	s1,a0
    if(pid < 0){
    1856:	02054d63          	bltz	a0,1890 <createdelete+0x60>
    if(pid == 0){
    185a:	c529                	beqz	a0,18a4 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    185c:	2905                	addiw	s2,s2,1
    185e:	ff3919e3          	bne	s2,s3,1850 <createdelete+0x20>
    1862:	4491                	li	s1,4
    wait(&xstatus);
    1864:	f7c40513          	addi	a0,s0,-132
    1868:	446030ef          	jal	4cae <wait>
    if(xstatus != 0)
    186c:	f7c42903          	lw	s2,-132(s0)
    1870:	0a091e63          	bnez	s2,192c <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1874:	34fd                	addiw	s1,s1,-1
    1876:	f4fd                	bnez	s1,1864 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    1878:	f8040123          	sb	zero,-126(s0)
    187c:	03000993          	li	s3,48
    1880:	5a7d                	li	s4,-1
    1882:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1886:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1888:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    188a:	07400a93          	li	s5,116
    188e:	aa39                	j	19ac <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    1890:	85e6                	mv	a1,s9
    1892:	00004517          	auipc	a0,0x4
    1896:	2c650513          	addi	a0,a0,710 # 5b58 <malloc+0x9ca>
    189a:	041030ef          	jal	50da <printf>
      exit(1);
    189e:	4505                	li	a0,1
    18a0:	406030ef          	jal	4ca6 <exit>
      name[0] = 'p' + pi;
    18a4:	0709091b          	addiw	s2,s2,112
    18a8:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    18ac:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    18b0:	4951                	li	s2,20
    18b2:	a831                	j	18ce <createdelete+0x9e>
          printf("%s: create failed\n", s);
    18b4:	85e6                	mv	a1,s9
    18b6:	00004517          	auipc	a0,0x4
    18ba:	33a50513          	addi	a0,a0,826 # 5bf0 <malloc+0xa62>
    18be:	01d030ef          	jal	50da <printf>
          exit(1);
    18c2:	4505                	li	a0,1
    18c4:	3e2030ef          	jal	4ca6 <exit>
      for(i = 0; i < N; i++){
    18c8:	2485                	addiw	s1,s1,1
    18ca:	05248e63          	beq	s1,s2,1926 <createdelete+0xf6>
        name[1] = '0' + i;
    18ce:	0304879b          	addiw	a5,s1,48
    18d2:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18d6:	20200593          	li	a1,514
    18da:	f8040513          	addi	a0,s0,-128
    18de:	408030ef          	jal	4ce6 <open>
        if(fd < 0){
    18e2:	fc0549e3          	bltz	a0,18b4 <createdelete+0x84>
        close(fd);
    18e6:	3e8030ef          	jal	4cce <close>
        if(i > 0 && (i % 2 ) == 0){
    18ea:	10905063          	blez	s1,19ea <createdelete+0x1ba>
    18ee:	0014f793          	andi	a5,s1,1
    18f2:	fbf9                	bnez	a5,18c8 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18f4:	01f4d79b          	srliw	a5,s1,0x1f
    18f8:	9fa5                	addw	a5,a5,s1
    18fa:	4017d79b          	sraiw	a5,a5,0x1
    18fe:	0307879b          	addiw	a5,a5,48
    1902:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1906:	f8040513          	addi	a0,s0,-128
    190a:	3ec030ef          	jal	4cf6 <unlink>
    190e:	fa055de3          	bgez	a0,18c8 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    1912:	85e6                	mv	a1,s9
    1914:	00004517          	auipc	a0,0x4
    1918:	43450513          	addi	a0,a0,1076 # 5d48 <malloc+0xbba>
    191c:	7be030ef          	jal	50da <printf>
            exit(1);
    1920:	4505                	li	a0,1
    1922:	384030ef          	jal	4ca6 <exit>
      exit(0);
    1926:	4501                	li	a0,0
    1928:	37e030ef          	jal	4ca6 <exit>
      exit(1);
    192c:	4505                	li	a0,1
    192e:	378030ef          	jal	4ca6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1932:	f8040613          	addi	a2,s0,-128
    1936:	85e6                	mv	a1,s9
    1938:	00004517          	auipc	a0,0x4
    193c:	42850513          	addi	a0,a0,1064 # 5d60 <malloc+0xbd2>
    1940:	79a030ef          	jal	50da <printf>
        exit(1);
    1944:	4505                	li	a0,1
    1946:	360030ef          	jal	4ca6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194a:	034bfb63          	bgeu	s7,s4,1980 <createdelete+0x150>
      if(fd >= 0)
    194e:	02055663          	bgez	a0,197a <createdelete+0x14a>
    for(pi = 0; pi < NCHILD; pi++){
    1952:	2485                	addiw	s1,s1,1
    1954:	0ff4f493          	zext.b	s1,s1
    1958:	05548263          	beq	s1,s5,199c <createdelete+0x16c>
      name[0] = 'p' + pi;
    195c:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1960:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1964:	4581                	li	a1,0
    1966:	f8040513          	addi	a0,s0,-128
    196a:	37c030ef          	jal	4ce6 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    196e:	00090463          	beqz	s2,1976 <createdelete+0x146>
    1972:	fd2b5ce3          	bge	s6,s2,194a <createdelete+0x11a>
    1976:	fa054ee3          	bltz	a0,1932 <createdelete+0x102>
        close(fd);
    197a:	354030ef          	jal	4cce <close>
    197e:	bfd1                	j	1952 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1980:	fc0549e3          	bltz	a0,1952 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1984:	f8040613          	addi	a2,s0,-128
    1988:	85e6                	mv	a1,s9
    198a:	00004517          	auipc	a0,0x4
    198e:	3fe50513          	addi	a0,a0,1022 # 5d88 <malloc+0xbfa>
    1992:	748030ef          	jal	50da <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	30e030ef          	jal	4ca6 <exit>
  for(i = 0; i < N; i++){
    199c:	2905                	addiw	s2,s2,1
    199e:	2a05                	addiw	s4,s4,1
    19a0:	2985                	addiw	s3,s3,1
    19a2:	0ff9f993          	zext.b	s3,s3
    19a6:	47d1                	li	a5,20
    19a8:	02f90863          	beq	s2,a5,19d8 <createdelete+0x1a8>
    for(pi = 0; pi < NCHILD; pi++){
    19ac:	84e2                	mv	s1,s8
    19ae:	b77d                	j	195c <createdelete+0x12c>
  for(i = 0; i < N; i++){
    19b0:	2905                	addiw	s2,s2,1
    19b2:	0ff97913          	zext.b	s2,s2
    19b6:	03490c63          	beq	s2,s4,19ee <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    19ba:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    19bc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19c0:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19c4:	f8040513          	addi	a0,s0,-128
    19c8:	32e030ef          	jal	4cf6 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19cc:	2485                	addiw	s1,s1,1
    19ce:	0ff4f493          	zext.b	s1,s1
    19d2:	ff3495e3          	bne	s1,s3,19bc <createdelete+0x18c>
    19d6:	bfe9                	j	19b0 <createdelete+0x180>
    19d8:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19dc:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19e0:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19e4:	04400a13          	li	s4,68
    19e8:	bfc9                	j	19ba <createdelete+0x18a>
      for(i = 0; i < N; i++){
    19ea:	2485                	addiw	s1,s1,1
    19ec:	b5cd                	j	18ce <createdelete+0x9e>
}
    19ee:	60aa                	ld	ra,136(sp)
    19f0:	640a                	ld	s0,128(sp)
    19f2:	74e6                	ld	s1,120(sp)
    19f4:	7946                	ld	s2,112(sp)
    19f6:	79a6                	ld	s3,104(sp)
    19f8:	7a06                	ld	s4,96(sp)
    19fa:	6ae6                	ld	s5,88(sp)
    19fc:	6b46                	ld	s6,80(sp)
    19fe:	6ba6                	ld	s7,72(sp)
    1a00:	6c06                	ld	s8,64(sp)
    1a02:	7ce2                	ld	s9,56(sp)
    1a04:	6149                	addi	sp,sp,144
    1a06:	8082                	ret

0000000000001a08 <linkunlink>:
{
    1a08:	711d                	addi	sp,sp,-96
    1a0a:	ec86                	sd	ra,88(sp)
    1a0c:	e8a2                	sd	s0,80(sp)
    1a0e:	e4a6                	sd	s1,72(sp)
    1a10:	e0ca                	sd	s2,64(sp)
    1a12:	fc4e                	sd	s3,56(sp)
    1a14:	f852                	sd	s4,48(sp)
    1a16:	f456                	sd	s5,40(sp)
    1a18:	f05a                	sd	s6,32(sp)
    1a1a:	ec5e                	sd	s7,24(sp)
    1a1c:	e862                	sd	s8,16(sp)
    1a1e:	e466                	sd	s9,8(sp)
    1a20:	1080                	addi	s0,sp,96
    1a22:	84aa                	mv	s1,a0
  unlink("x");
    1a24:	00004517          	auipc	a0,0x4
    1a28:	91450513          	addi	a0,a0,-1772 # 5338 <malloc+0x1aa>
    1a2c:	2ca030ef          	jal	4cf6 <unlink>
  pid = fork();
    1a30:	26e030ef          	jal	4c9e <fork>
  if(pid < 0){
    1a34:	02054b63          	bltz	a0,1a6a <linkunlink+0x62>
    1a38:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1a3a:	06100913          	li	s2,97
    1a3e:	c111                	beqz	a0,1a42 <linkunlink+0x3a>
    1a40:	4905                	li	s2,1
    1a42:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a46:	41c65a37          	lui	s4,0x41c65
    1a4a:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551c5>
    1a4e:	698d                	lui	s3,0x3
    1a50:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x477>
    if((x % 3) == 0){
    1a54:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1a56:	4b85                	li	s7,1
      unlink("x");
    1a58:	00004b17          	auipc	s6,0x4
    1a5c:	8e0b0b13          	addi	s6,s6,-1824 # 5338 <malloc+0x1aa>
      link("cat", "x");
    1a60:	00004c17          	auipc	s8,0x4
    1a64:	350c0c13          	addi	s8,s8,848 # 5db0 <malloc+0xc22>
    1a68:	a025                	j	1a90 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a6a:	85a6                	mv	a1,s1
    1a6c:	00004517          	auipc	a0,0x4
    1a70:	0ec50513          	addi	a0,a0,236 # 5b58 <malloc+0x9ca>
    1a74:	666030ef          	jal	50da <printf>
    exit(1);
    1a78:	4505                	li	a0,1
    1a7a:	22c030ef          	jal	4ca6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a7e:	20200593          	li	a1,514
    1a82:	855a                	mv	a0,s6
    1a84:	262030ef          	jal	4ce6 <open>
    1a88:	246030ef          	jal	4cce <close>
  for(i = 0; i < 100; i++){
    1a8c:	34fd                	addiw	s1,s1,-1
    1a8e:	c495                	beqz	s1,1aba <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    1a90:	034907bb          	mulw	a5,s2,s4
    1a94:	013787bb          	addw	a5,a5,s3
    1a98:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1a9c:	0357f7bb          	remuw	a5,a5,s5
    1aa0:	2781                	sext.w	a5,a5
    1aa2:	dff1                	beqz	a5,1a7e <linkunlink+0x76>
    } else if((x % 3) == 1){
    1aa4:	01778663          	beq	a5,s7,1ab0 <linkunlink+0xa8>
      unlink("x");
    1aa8:	855a                	mv	a0,s6
    1aaa:	24c030ef          	jal	4cf6 <unlink>
    1aae:	bff9                	j	1a8c <linkunlink+0x84>
      link("cat", "x");
    1ab0:	85da                	mv	a1,s6
    1ab2:	8562                	mv	a0,s8
    1ab4:	252030ef          	jal	4d06 <link>
    1ab8:	bfd1                	j	1a8c <linkunlink+0x84>
  if(pid)
    1aba:	020c8263          	beqz	s9,1ade <linkunlink+0xd6>
    wait(0);
    1abe:	4501                	li	a0,0
    1ac0:	1ee030ef          	jal	4cae <wait>
}
    1ac4:	60e6                	ld	ra,88(sp)
    1ac6:	6446                	ld	s0,80(sp)
    1ac8:	64a6                	ld	s1,72(sp)
    1aca:	6906                	ld	s2,64(sp)
    1acc:	79e2                	ld	s3,56(sp)
    1ace:	7a42                	ld	s4,48(sp)
    1ad0:	7aa2                	ld	s5,40(sp)
    1ad2:	7b02                	ld	s6,32(sp)
    1ad4:	6be2                	ld	s7,24(sp)
    1ad6:	6c42                	ld	s8,16(sp)
    1ad8:	6ca2                	ld	s9,8(sp)
    1ada:	6125                	addi	sp,sp,96
    1adc:	8082                	ret
    exit(0);
    1ade:	4501                	li	a0,0
    1ae0:	1c6030ef          	jal	4ca6 <exit>

0000000000001ae4 <forktest>:
{
    1ae4:	7179                	addi	sp,sp,-48
    1ae6:	f406                	sd	ra,40(sp)
    1ae8:	f022                	sd	s0,32(sp)
    1aea:	ec26                	sd	s1,24(sp)
    1aec:	e84a                	sd	s2,16(sp)
    1aee:	e44e                	sd	s3,8(sp)
    1af0:	1800                	addi	s0,sp,48
    1af2:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1af4:	4481                	li	s1,0
    1af6:	3e800913          	li	s2,1000
    pid = fork();
    1afa:	1a4030ef          	jal	4c9e <fork>
    if(pid < 0)
    1afe:	06054063          	bltz	a0,1b5e <forktest+0x7a>
    if(pid == 0)
    1b02:	cd11                	beqz	a0,1b1e <forktest+0x3a>
  for(n=0; n<N; n++){
    1b04:	2485                	addiw	s1,s1,1
    1b06:	ff249ae3          	bne	s1,s2,1afa <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1b0a:	85ce                	mv	a1,s3
    1b0c:	00004517          	auipc	a0,0x4
    1b10:	2f450513          	addi	a0,a0,756 # 5e00 <malloc+0xc72>
    1b14:	5c6030ef          	jal	50da <printf>
    exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	18c030ef          	jal	4ca6 <exit>
      exit(0);
    1b1e:	188030ef          	jal	4ca6 <exit>
    printf("%s: no fork at all!\n", s);
    1b22:	85ce                	mv	a1,s3
    1b24:	00004517          	auipc	a0,0x4
    1b28:	29450513          	addi	a0,a0,660 # 5db8 <malloc+0xc2a>
    1b2c:	5ae030ef          	jal	50da <printf>
    exit(1);
    1b30:	4505                	li	a0,1
    1b32:	174030ef          	jal	4ca6 <exit>
      printf("%s: wait stopped early\n", s);
    1b36:	85ce                	mv	a1,s3
    1b38:	00004517          	auipc	a0,0x4
    1b3c:	29850513          	addi	a0,a0,664 # 5dd0 <malloc+0xc42>
    1b40:	59a030ef          	jal	50da <printf>
      exit(1);
    1b44:	4505                	li	a0,1
    1b46:	160030ef          	jal	4ca6 <exit>
    printf("%s: wait got too many\n", s);
    1b4a:	85ce                	mv	a1,s3
    1b4c:	00004517          	auipc	a0,0x4
    1b50:	29c50513          	addi	a0,a0,668 # 5de8 <malloc+0xc5a>
    1b54:	586030ef          	jal	50da <printf>
    exit(1);
    1b58:	4505                	li	a0,1
    1b5a:	14c030ef          	jal	4ca6 <exit>
  if (n == 0) {
    1b5e:	d0f1                	beqz	s1,1b22 <forktest+0x3e>
  for(; n > 0; n--){
    1b60:	00905963          	blez	s1,1b72 <forktest+0x8e>
    if(wait(0) < 0){
    1b64:	4501                	li	a0,0
    1b66:	148030ef          	jal	4cae <wait>
    1b6a:	fc0546e3          	bltz	a0,1b36 <forktest+0x52>
  for(; n > 0; n--){
    1b6e:	34fd                	addiw	s1,s1,-1
    1b70:	f8f5                	bnez	s1,1b64 <forktest+0x80>
  if(wait(0) != -1){
    1b72:	4501                	li	a0,0
    1b74:	13a030ef          	jal	4cae <wait>
    1b78:	57fd                	li	a5,-1
    1b7a:	fcf518e3          	bne	a0,a5,1b4a <forktest+0x66>
}
    1b7e:	70a2                	ld	ra,40(sp)
    1b80:	7402                	ld	s0,32(sp)
    1b82:	64e2                	ld	s1,24(sp)
    1b84:	6942                	ld	s2,16(sp)
    1b86:	69a2                	ld	s3,8(sp)
    1b88:	6145                	addi	sp,sp,48
    1b8a:	8082                	ret

0000000000001b8c <kernmem>:
{
    1b8c:	715d                	addi	sp,sp,-80
    1b8e:	e486                	sd	ra,72(sp)
    1b90:	e0a2                	sd	s0,64(sp)
    1b92:	fc26                	sd	s1,56(sp)
    1b94:	f84a                	sd	s2,48(sp)
    1b96:	f44e                	sd	s3,40(sp)
    1b98:	f052                	sd	s4,32(sp)
    1b9a:	ec56                	sd	s5,24(sp)
    1b9c:	0880                	addi	s0,sp,80
    1b9e:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba0:	4485                	li	s1,1
    1ba2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1ba4:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba6:	69b1                	lui	s3,0xc
    1ba8:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1db8>
    1bac:	1003d937          	lui	s2,0x1003d
    1bb0:	090e                	slli	s2,s2,0x3
    1bb2:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d7d8>
    pid = fork();
    1bb6:	0e8030ef          	jal	4c9e <fork>
    if(pid < 0){
    1bba:	02054763          	bltz	a0,1be8 <kernmem+0x5c>
    if(pid == 0){
    1bbe:	cd1d                	beqz	a0,1bfc <kernmem+0x70>
    wait(&xstatus);
    1bc0:	fbc40513          	addi	a0,s0,-68
    1bc4:	0ea030ef          	jal	4cae <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bc8:	fbc42783          	lw	a5,-68(s0)
    1bcc:	05479563          	bne	a5,s4,1c16 <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bd0:	94ce                	add	s1,s1,s3
    1bd2:	ff2492e3          	bne	s1,s2,1bb6 <kernmem+0x2a>
}
    1bd6:	60a6                	ld	ra,72(sp)
    1bd8:	6406                	ld	s0,64(sp)
    1bda:	74e2                	ld	s1,56(sp)
    1bdc:	7942                	ld	s2,48(sp)
    1bde:	79a2                	ld	s3,40(sp)
    1be0:	7a02                	ld	s4,32(sp)
    1be2:	6ae2                	ld	s5,24(sp)
    1be4:	6161                	addi	sp,sp,80
    1be6:	8082                	ret
      printf("%s: fork failed\n", s);
    1be8:	85d6                	mv	a1,s5
    1bea:	00004517          	auipc	a0,0x4
    1bee:	f6e50513          	addi	a0,a0,-146 # 5b58 <malloc+0x9ca>
    1bf2:	4e8030ef          	jal	50da <printf>
      exit(1);
    1bf6:	4505                	li	a0,1
    1bf8:	0ae030ef          	jal	4ca6 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bfc:	0004c683          	lbu	a3,0(s1)
    1c00:	8626                	mv	a2,s1
    1c02:	85d6                	mv	a1,s5
    1c04:	00004517          	auipc	a0,0x4
    1c08:	22450513          	addi	a0,a0,548 # 5e28 <malloc+0xc9a>
    1c0c:	4ce030ef          	jal	50da <printf>
      exit(1);
    1c10:	4505                	li	a0,1
    1c12:	094030ef          	jal	4ca6 <exit>
      exit(1);
    1c16:	4505                	li	a0,1
    1c18:	08e030ef          	jal	4ca6 <exit>

0000000000001c1c <MAXVAplus>:
{
    1c1c:	7179                	addi	sp,sp,-48
    1c1e:	f406                	sd	ra,40(sp)
    1c20:	f022                	sd	s0,32(sp)
    1c22:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c24:	4785                	li	a5,1
    1c26:	179a                	slli	a5,a5,0x26
    1c28:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c2c:	fd843783          	ld	a5,-40(s0)
    1c30:	cf85                	beqz	a5,1c68 <MAXVAplus+0x4c>
    1c32:	ec26                	sd	s1,24(sp)
    1c34:	e84a                	sd	s2,16(sp)
    1c36:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c38:	54fd                	li	s1,-1
    pid = fork();
    1c3a:	064030ef          	jal	4c9e <fork>
    if(pid < 0){
    1c3e:	02054963          	bltz	a0,1c70 <MAXVAplus+0x54>
    if(pid == 0){
    1c42:	c129                	beqz	a0,1c84 <MAXVAplus+0x68>
    wait(&xstatus);
    1c44:	fd440513          	addi	a0,s0,-44
    1c48:	066030ef          	jal	4cae <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c4c:	fd442783          	lw	a5,-44(s0)
    1c50:	04979c63          	bne	a5,s1,1ca8 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c54:	fd843783          	ld	a5,-40(s0)
    1c58:	0786                	slli	a5,a5,0x1
    1c5a:	fcf43c23          	sd	a5,-40(s0)
    1c5e:	fd843783          	ld	a5,-40(s0)
    1c62:	ffe1                	bnez	a5,1c3a <MAXVAplus+0x1e>
    1c64:	64e2                	ld	s1,24(sp)
    1c66:	6942                	ld	s2,16(sp)
}
    1c68:	70a2                	ld	ra,40(sp)
    1c6a:	7402                	ld	s0,32(sp)
    1c6c:	6145                	addi	sp,sp,48
    1c6e:	8082                	ret
      printf("%s: fork failed\n", s);
    1c70:	85ca                	mv	a1,s2
    1c72:	00004517          	auipc	a0,0x4
    1c76:	ee650513          	addi	a0,a0,-282 # 5b58 <malloc+0x9ca>
    1c7a:	460030ef          	jal	50da <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	026030ef          	jal	4ca6 <exit>
      *(char*)a = 99;
    1c84:	fd843783          	ld	a5,-40(s0)
    1c88:	06300713          	li	a4,99
    1c8c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c90:	fd843603          	ld	a2,-40(s0)
    1c94:	85ca                	mv	a1,s2
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	1b250513          	addi	a0,a0,434 # 5e48 <malloc+0xcba>
    1c9e:	43c030ef          	jal	50da <printf>
      exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	002030ef          	jal	4ca6 <exit>
      exit(1);
    1ca8:	4505                	li	a0,1
    1caa:	7fd020ef          	jal	4ca6 <exit>

0000000000001cae <stacktest>:
{
    1cae:	7179                	addi	sp,sp,-48
    1cb0:	f406                	sd	ra,40(sp)
    1cb2:	f022                	sd	s0,32(sp)
    1cb4:	ec26                	sd	s1,24(sp)
    1cb6:	1800                	addi	s0,sp,48
    1cb8:	84aa                	mv	s1,a0
  pid = fork();
    1cba:	7e5020ef          	jal	4c9e <fork>
  if(pid == 0) {
    1cbe:	cd11                	beqz	a0,1cda <stacktest+0x2c>
  } else if(pid < 0){
    1cc0:	02054c63          	bltz	a0,1cf8 <stacktest+0x4a>
  wait(&xstatus);
    1cc4:	fdc40513          	addi	a0,s0,-36
    1cc8:	7e7020ef          	jal	4cae <wait>
  if(xstatus == -1)  // kernel killed child?
    1ccc:	fdc42503          	lw	a0,-36(s0)
    1cd0:	57fd                	li	a5,-1
    1cd2:	02f50d63          	beq	a0,a5,1d0c <stacktest+0x5e>
    exit(xstatus);
    1cd6:	7d1020ef          	jal	4ca6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cda:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cdc:	77fd                	lui	a5,0xfffff
    1cde:	97ba                	add	a5,a5,a4
    1ce0:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef358>
    1ce4:	85a6                	mv	a1,s1
    1ce6:	00004517          	auipc	a0,0x4
    1cea:	17a50513          	addi	a0,a0,378 # 5e60 <malloc+0xcd2>
    1cee:	3ec030ef          	jal	50da <printf>
    exit(1);
    1cf2:	4505                	li	a0,1
    1cf4:	7b3020ef          	jal	4ca6 <exit>
    printf("%s: fork failed\n", s);
    1cf8:	85a6                	mv	a1,s1
    1cfa:	00004517          	auipc	a0,0x4
    1cfe:	e5e50513          	addi	a0,a0,-418 # 5b58 <malloc+0x9ca>
    1d02:	3d8030ef          	jal	50da <printf>
    exit(1);
    1d06:	4505                	li	a0,1
    1d08:	79f020ef          	jal	4ca6 <exit>
    exit(0);
    1d0c:	4501                	li	a0,0
    1d0e:	799020ef          	jal	4ca6 <exit>

0000000000001d12 <nowrite>:
{
    1d12:	7159                	addi	sp,sp,-112
    1d14:	f486                	sd	ra,104(sp)
    1d16:	f0a2                	sd	s0,96(sp)
    1d18:	eca6                	sd	s1,88(sp)
    1d1a:	e8ca                	sd	s2,80(sp)
    1d1c:	e4ce                	sd	s3,72(sp)
    1d1e:	1880                	addi	s0,sp,112
    1d20:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d22:	00006797          	auipc	a5,0x6
    1d26:	9f678793          	addi	a5,a5,-1546 # 7718 <malloc+0x258a>
    1d2a:	7788                	ld	a0,40(a5)
    1d2c:	7b8c                	ld	a1,48(a5)
    1d2e:	7f90                	ld	a2,56(a5)
    1d30:	63b4                	ld	a3,64(a5)
    1d32:	67b8                	ld	a4,72(a5)
    1d34:	6bbc                	ld	a5,80(a5)
    1d36:	f8a43c23          	sd	a0,-104(s0)
    1d3a:	fab43023          	sd	a1,-96(s0)
    1d3e:	fac43423          	sd	a2,-88(s0)
    1d42:	fad43823          	sd	a3,-80(s0)
    1d46:	fae43c23          	sd	a4,-72(s0)
    1d4a:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d4e:	4481                	li	s1,0
    1d50:	4919                	li	s2,6
    pid = fork();
    1d52:	74d020ef          	jal	4c9e <fork>
    if(pid == 0) {
    1d56:	c105                	beqz	a0,1d76 <nowrite+0x64>
    } else if(pid < 0){
    1d58:	04054263          	bltz	a0,1d9c <nowrite+0x8a>
    wait(&xstatus);
    1d5c:	fcc40513          	addi	a0,s0,-52
    1d60:	74f020ef          	jal	4cae <wait>
    if(xstatus == 0){
    1d64:	fcc42783          	lw	a5,-52(s0)
    1d68:	c7a1                	beqz	a5,1db0 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d6a:	2485                	addiw	s1,s1,1
    1d6c:	ff2493e3          	bne	s1,s2,1d52 <nowrite+0x40>
  exit(0);
    1d70:	4501                	li	a0,0
    1d72:	735020ef          	jal	4ca6 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d76:	048e                	slli	s1,s1,0x3
    1d78:	fd048793          	addi	a5,s1,-48
    1d7c:	008784b3          	add	s1,a5,s0
    1d80:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d84:	47a9                	li	a5,10
    1d86:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d88:	85ce                	mv	a1,s3
    1d8a:	00004517          	auipc	a0,0x4
    1d8e:	0fe50513          	addi	a0,a0,254 # 5e88 <malloc+0xcfa>
    1d92:	348030ef          	jal	50da <printf>
      exit(0);
    1d96:	4501                	li	a0,0
    1d98:	70f020ef          	jal	4ca6 <exit>
      printf("%s: fork failed\n", s);
    1d9c:	85ce                	mv	a1,s3
    1d9e:	00004517          	auipc	a0,0x4
    1da2:	dba50513          	addi	a0,a0,-582 # 5b58 <malloc+0x9ca>
    1da6:	334030ef          	jal	50da <printf>
      exit(1);
    1daa:	4505                	li	a0,1
    1dac:	6fb020ef          	jal	4ca6 <exit>
      exit(1);
    1db0:	4505                	li	a0,1
    1db2:	6f5020ef          	jal	4ca6 <exit>

0000000000001db6 <manywrites>:
{
    1db6:	711d                	addi	sp,sp,-96
    1db8:	ec86                	sd	ra,88(sp)
    1dba:	e8a2                	sd	s0,80(sp)
    1dbc:	e4a6                	sd	s1,72(sp)
    1dbe:	e0ca                	sd	s2,64(sp)
    1dc0:	fc4e                	sd	s3,56(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1dc8:	4981                	li	s3,0
    1dca:	4911                	li	s2,4
    int pid = fork();
    1dcc:	6d3020ef          	jal	4c9e <fork>
    1dd0:	84aa                	mv	s1,a0
    if(pid < 0){
    1dd2:	02054963          	bltz	a0,1e04 <manywrites+0x4e>
    if(pid == 0){
    1dd6:	c139                	beqz	a0,1e1c <manywrites+0x66>
  for(int ci = 0; ci < nchildren; ci++){
    1dd8:	2985                	addiw	s3,s3,1
    1dda:	ff2999e3          	bne	s3,s2,1dcc <manywrites+0x16>
    1dde:	f852                	sd	s4,48(sp)
    1de0:	f05a                	sd	s6,32(sp)
    1de2:	ec5e                	sd	s7,24(sp)
    1de4:	4491                	li	s1,4
    int st = 0;
    1de6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dea:	fa840513          	addi	a0,s0,-88
    1dee:	6c1020ef          	jal	4cae <wait>
    if(st != 0)
    1df2:	fa842503          	lw	a0,-88(s0)
    1df6:	0c051863          	bnez	a0,1ec6 <manywrites+0x110>
  for(int ci = 0; ci < nchildren; ci++){
    1dfa:	34fd                	addiw	s1,s1,-1
    1dfc:	f4ed                	bnez	s1,1de6 <manywrites+0x30>
  exit(0);
    1dfe:	4501                	li	a0,0
    1e00:	6a7020ef          	jal	4ca6 <exit>
    1e04:	f852                	sd	s4,48(sp)
    1e06:	f05a                	sd	s6,32(sp)
    1e08:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1e0a:	00005517          	auipc	a0,0x5
    1e0e:	2f650513          	addi	a0,a0,758 # 7100 <malloc+0x1f72>
    1e12:	2c8030ef          	jal	50da <printf>
      exit(1);
    1e16:	4505                	li	a0,1
    1e18:	68f020ef          	jal	4ca6 <exit>
    1e1c:	f852                	sd	s4,48(sp)
    1e1e:	f05a                	sd	s6,32(sp)
    1e20:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1e22:	06200793          	li	a5,98
    1e26:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1e2a:	0619879b          	addiw	a5,s3,97
    1e2e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e32:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e36:	fa840513          	addi	a0,s0,-88
    1e3a:	6bd020ef          	jal	4cf6 <unlink>
    1e3e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e40:	0000bb17          	auipc	s6,0xb
    1e44:	e68b0b13          	addi	s6,s6,-408 # cca8 <buf>
        for(int i = 0; i < ci+1; i++){
    1e48:	8a26                	mv	s4,s1
    1e4a:	0209c863          	bltz	s3,1e7a <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    1e4e:	20200593          	li	a1,514
    1e52:	fa840513          	addi	a0,s0,-88
    1e56:	691020ef          	jal	4ce6 <open>
    1e5a:	892a                	mv	s2,a0
          if(fd < 0){
    1e5c:	02054d63          	bltz	a0,1e96 <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    1e60:	660d                	lui	a2,0x3
    1e62:	85da                	mv	a1,s6
    1e64:	663020ef          	jal	4cc6 <write>
          if(cc != sz){
    1e68:	678d                	lui	a5,0x3
    1e6a:	04f51263          	bne	a0,a5,1eae <manywrites+0xf8>
          close(fd);
    1e6e:	854a                	mv	a0,s2
    1e70:	65f020ef          	jal	4cce <close>
        for(int i = 0; i < ci+1; i++){
    1e74:	2a05                	addiw	s4,s4,1
    1e76:	fd49dce3          	bge	s3,s4,1e4e <manywrites+0x98>
        unlink(name);
    1e7a:	fa840513          	addi	a0,s0,-88
    1e7e:	679020ef          	jal	4cf6 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e82:	3bfd                	addiw	s7,s7,-1
    1e84:	fc0b92e3          	bnez	s7,1e48 <manywrites+0x92>
      unlink(name);
    1e88:	fa840513          	addi	a0,s0,-88
    1e8c:	66b020ef          	jal	4cf6 <unlink>
      exit(0);
    1e90:	4501                	li	a0,0
    1e92:	615020ef          	jal	4ca6 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e96:	fa840613          	addi	a2,s0,-88
    1e9a:	85d6                	mv	a1,s5
    1e9c:	00004517          	auipc	a0,0x4
    1ea0:	00c50513          	addi	a0,a0,12 # 5ea8 <malloc+0xd1a>
    1ea4:	236030ef          	jal	50da <printf>
            exit(1);
    1ea8:	4505                	li	a0,1
    1eaa:	5fd020ef          	jal	4ca6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1eae:	86aa                	mv	a3,a0
    1eb0:	660d                	lui	a2,0x3
    1eb2:	85d6                	mv	a1,s5
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	4e450513          	addi	a0,a0,1252 # 5398 <malloc+0x20a>
    1ebc:	21e030ef          	jal	50da <printf>
            exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	5e5020ef          	jal	4ca6 <exit>
      exit(st);
    1ec6:	5e1020ef          	jal	4ca6 <exit>

0000000000001eca <copyinstr3>:
{
    1eca:	7179                	addi	sp,sp,-48
    1ecc:	f406                	sd	ra,40(sp)
    1ece:	f022                	sd	s0,32(sp)
    1ed0:	ec26                	sd	s1,24(sp)
    1ed2:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ed4:	6509                	lui	a0,0x2
    1ed6:	57d020ef          	jal	4c52 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1eda:	4501                	li	a0,0
    1edc:	577020ef          	jal	4c52 <sbrk>
  if((top % PGSIZE) != 0){
    1ee0:	03451793          	slli	a5,a0,0x34
    1ee4:	e7bd                	bnez	a5,1f52 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1ee6:	4501                	li	a0,0
    1ee8:	56b020ef          	jal	4c52 <sbrk>
  if(top % PGSIZE){
    1eec:	03451793          	slli	a5,a0,0x34
    1ef0:	ebad                	bnez	a5,1f62 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ef2:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x31>
  *b = 'x';
    1ef6:	07800793          	li	a5,120
    1efa:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1efe:	8526                	mv	a0,s1
    1f00:	5f7020ef          	jal	4cf6 <unlink>
  if(ret != -1){
    1f04:	57fd                	li	a5,-1
    1f06:	06f51763          	bne	a0,a5,1f74 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f0a:	20100593          	li	a1,513
    1f0e:	8526                	mv	a0,s1
    1f10:	5d7020ef          	jal	4ce6 <open>
  if(fd != -1){
    1f14:	57fd                	li	a5,-1
    1f16:	06f51a63          	bne	a0,a5,1f8a <copyinstr3+0xc0>
  ret = link(b, b);
    1f1a:	85a6                	mv	a1,s1
    1f1c:	8526                	mv	a0,s1
    1f1e:	5e9020ef          	jal	4d06 <link>
  if(ret != -1){
    1f22:	57fd                	li	a5,-1
    1f24:	06f51e63          	bne	a0,a5,1fa0 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1f28:	00005797          	auipc	a5,0x5
    1f2c:	c8078793          	addi	a5,a5,-896 # 6ba8 <malloc+0x1a1a>
    1f30:	fcf43823          	sd	a5,-48(s0)
    1f34:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f38:	fd040593          	addi	a1,s0,-48
    1f3c:	8526                	mv	a0,s1
    1f3e:	5a1020ef          	jal	4cde <exec>
  if(ret != -1){
    1f42:	57fd                	li	a5,-1
    1f44:	06f51a63          	bne	a0,a5,1fb8 <copyinstr3+0xee>
}
    1f48:	70a2                	ld	ra,40(sp)
    1f4a:	7402                	ld	s0,32(sp)
    1f4c:	64e2                	ld	s1,24(sp)
    1f4e:	6145                	addi	sp,sp,48
    1f50:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f52:	0347d513          	srli	a0,a5,0x34
    1f56:	6785                	lui	a5,0x1
    1f58:	40a7853b          	subw	a0,a5,a0
    1f5c:	4f7020ef          	jal	4c52 <sbrk>
    1f60:	b759                	j	1ee6 <copyinstr3+0x1c>
    printf("oops\n");
    1f62:	00004517          	auipc	a0,0x4
    1f66:	f5e50513          	addi	a0,a0,-162 # 5ec0 <malloc+0xd32>
    1f6a:	170030ef          	jal	50da <printf>
    exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	537020ef          	jal	4ca6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f74:	862a                	mv	a2,a0
    1f76:	85a6                	mv	a1,s1
    1f78:	00004517          	auipc	a0,0x4
    1f7c:	b0050513          	addi	a0,a0,-1280 # 5a78 <malloc+0x8ea>
    1f80:	15a030ef          	jal	50da <printf>
    exit(1);
    1f84:	4505                	li	a0,1
    1f86:	521020ef          	jal	4ca6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f8a:	862a                	mv	a2,a0
    1f8c:	85a6                	mv	a1,s1
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	b0a50513          	addi	a0,a0,-1270 # 5a98 <malloc+0x90a>
    1f96:	144030ef          	jal	50da <printf>
    exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	50b020ef          	jal	4ca6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	8626                	mv	a2,s1
    1fa4:	85a6                	mv	a1,s1
    1fa6:	00004517          	auipc	a0,0x4
    1faa:	b1250513          	addi	a0,a0,-1262 # 5ab8 <malloc+0x92a>
    1fae:	12c030ef          	jal	50da <printf>
    exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	4f3020ef          	jal	4ca6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1fb8:	567d                	li	a2,-1
    1fba:	85a6                	mv	a1,s1
    1fbc:	00004517          	auipc	a0,0x4
    1fc0:	b2450513          	addi	a0,a0,-1244 # 5ae0 <malloc+0x952>
    1fc4:	116030ef          	jal	50da <printf>
    exit(1);
    1fc8:	4505                	li	a0,1
    1fca:	4dd020ef          	jal	4ca6 <exit>

0000000000001fce <rwsbrk>:
{
    1fce:	1101                	addi	sp,sp,-32
    1fd0:	ec06                	sd	ra,24(sp)
    1fd2:	e822                	sd	s0,16(sp)
    1fd4:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fd6:	6509                	lui	a0,0x2
    1fd8:	47b020ef          	jal	4c52 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    1fdc:	57fd                	li	a5,-1
    1fde:	04f50a63          	beq	a0,a5,2032 <rwsbrk+0x64>
    1fe2:	e426                	sd	s1,8(sp)
    1fe4:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1fe6:	7579                	lui	a0,0xffffe
    1fe8:	46b020ef          	jal	4c52 <sbrk>
    1fec:	57fd                	li	a5,-1
    1fee:	04f50d63          	beq	a0,a5,2048 <rwsbrk+0x7a>
    1ff2:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1ff4:	20100593          	li	a1,513
    1ff8:	00004517          	auipc	a0,0x4
    1ffc:	f0850513          	addi	a0,a0,-248 # 5f00 <malloc+0xd72>
    2000:	4e7020ef          	jal	4ce6 <open>
    2004:	892a                	mv	s2,a0
  if(fd < 0){
    2006:	04054b63          	bltz	a0,205c <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    200a:	6785                	lui	a5,0x1
    200c:	94be                	add	s1,s1,a5
    200e:	40000613          	li	a2,1024
    2012:	85a6                	mv	a1,s1
    2014:	4b3020ef          	jal	4cc6 <write>
    2018:	862a                	mv	a2,a0
  if(n >= 0){
    201a:	04054a63          	bltz	a0,206e <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	f0050513          	addi	a0,a0,-256 # 5f20 <malloc+0xd92>
    2028:	0b2030ef          	jal	50da <printf>
    exit(1);
    202c:	4505                	li	a0,1
    202e:	479020ef          	jal	4ca6 <exit>
    2032:	e426                	sd	s1,8(sp)
    2034:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2036:	00004517          	auipc	a0,0x4
    203a:	e9250513          	addi	a0,a0,-366 # 5ec8 <malloc+0xd3a>
    203e:	09c030ef          	jal	50da <printf>
    exit(1);
    2042:	4505                	li	a0,1
    2044:	463020ef          	jal	4ca6 <exit>
    2048:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    204a:	00004517          	auipc	a0,0x4
    204e:	e9650513          	addi	a0,a0,-362 # 5ee0 <malloc+0xd52>
    2052:	088030ef          	jal	50da <printf>
    exit(1);
    2056:	4505                	li	a0,1
    2058:	44f020ef          	jal	4ca6 <exit>
    printf("open(rwsbrk) failed\n");
    205c:	00004517          	auipc	a0,0x4
    2060:	eac50513          	addi	a0,a0,-340 # 5f08 <malloc+0xd7a>
    2064:	076030ef          	jal	50da <printf>
    exit(1);
    2068:	4505                	li	a0,1
    206a:	43d020ef          	jal	4ca6 <exit>
  close(fd);
    206e:	854a                	mv	a0,s2
    2070:	45f020ef          	jal	4cce <close>
  unlink("rwsbrk");
    2074:	00004517          	auipc	a0,0x4
    2078:	e8c50513          	addi	a0,a0,-372 # 5f00 <malloc+0xd72>
    207c:	47b020ef          	jal	4cf6 <unlink>
  fd = open("README", O_RDONLY);
    2080:	4581                	li	a1,0
    2082:	00003517          	auipc	a0,0x3
    2086:	41e50513          	addi	a0,a0,1054 # 54a0 <malloc+0x312>
    208a:	45d020ef          	jal	4ce6 <open>
    208e:	892a                	mv	s2,a0
  if(fd < 0){
    2090:	02054363          	bltz	a0,20b6 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2094:	4629                	li	a2,10
    2096:	85a6                	mv	a1,s1
    2098:	427020ef          	jal	4cbe <read>
    209c:	862a                	mv	a2,a0
  if(n >= 0){
    209e:	02054563          	bltz	a0,20c8 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	eac50513          	addi	a0,a0,-340 # 5f50 <malloc+0xdc2>
    20ac:	02e030ef          	jal	50da <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	3f5020ef          	jal	4ca6 <exit>
    printf("open(README) failed\n");
    20b6:	00003517          	auipc	a0,0x3
    20ba:	3f250513          	addi	a0,a0,1010 # 54a8 <malloc+0x31a>
    20be:	01c030ef          	jal	50da <printf>
    exit(1);
    20c2:	4505                	li	a0,1
    20c4:	3e3020ef          	jal	4ca6 <exit>
  close(fd);
    20c8:	854a                	mv	a0,s2
    20ca:	405020ef          	jal	4cce <close>
  exit(0);
    20ce:	4501                	li	a0,0
    20d0:	3d7020ef          	jal	4ca6 <exit>

00000000000020d4 <sbrkbasic>:
{
    20d4:	7139                	addi	sp,sp,-64
    20d6:	fc06                	sd	ra,56(sp)
    20d8:	f822                	sd	s0,48(sp)
    20da:	ec4e                	sd	s3,24(sp)
    20dc:	0080                	addi	s0,sp,64
    20de:	89aa                	mv	s3,a0
  pid = fork();
    20e0:	3bf020ef          	jal	4c9e <fork>
  if(pid < 0){
    20e4:	02054b63          	bltz	a0,211a <sbrkbasic+0x46>
  if(pid == 0){
    20e8:	e939                	bnez	a0,213e <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    20ea:	40000537          	lui	a0,0x40000
    20ee:	365020ef          	jal	4c52 <sbrk>
    if(a == (char*)SBRK_ERROR){
    20f2:	57fd                	li	a5,-1
    20f4:	02f50f63          	beq	a0,a5,2132 <sbrkbasic+0x5e>
    20f8:	f426                	sd	s1,40(sp)
    20fa:	f04a                	sd	s2,32(sp)
    20fc:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    20fe:	400007b7          	lui	a5,0x40000
    2102:	97aa                	add	a5,a5,a0
      *b = 99;
    2104:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2108:	6705                	lui	a4,0x1
      *b = 99;
    210a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0358>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    210e:	953a                	add	a0,a0,a4
    2110:	fef51de3          	bne	a0,a5,210a <sbrkbasic+0x36>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	391020ef          	jal	4ca6 <exit>
    211a:	f426                	sd	s1,40(sp)
    211c:	f04a                	sd	s2,32(sp)
    211e:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2120:	00004517          	auipc	a0,0x4
    2124:	e5850513          	addi	a0,a0,-424 # 5f78 <malloc+0xdea>
    2128:	7b3020ef          	jal	50da <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	379020ef          	jal	4ca6 <exit>
    2132:	f426                	sd	s1,40(sp)
    2134:	f04a                	sd	s2,32(sp)
    2136:	e852                	sd	s4,16(sp)
      exit(0);
    2138:	4501                	li	a0,0
    213a:	36d020ef          	jal	4ca6 <exit>
  wait(&xstatus);
    213e:	fcc40513          	addi	a0,s0,-52
    2142:	36d020ef          	jal	4cae <wait>
  if(xstatus == 1){
    2146:	fcc42703          	lw	a4,-52(s0)
    214a:	4785                	li	a5,1
    214c:	00f70e63          	beq	a4,a5,2168 <sbrkbasic+0x94>
    2150:	f426                	sd	s1,40(sp)
    2152:	f04a                	sd	s2,32(sp)
    2154:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2156:	4501                	li	a0,0
    2158:	2fb020ef          	jal	4c52 <sbrk>
    215c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    215e:	4901                	li	s2,0
    2160:	6a05                	lui	s4,0x1
    2162:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x4a>
    2166:	a839                	j	2184 <sbrkbasic+0xb0>
    2168:	f426                	sd	s1,40(sp)
    216a:	f04a                	sd	s2,32(sp)
    216c:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    216e:	85ce                	mv	a1,s3
    2170:	00004517          	auipc	a0,0x4
    2174:	e2850513          	addi	a0,a0,-472 # 5f98 <malloc+0xe0a>
    2178:	763020ef          	jal	50da <printf>
    exit(1);
    217c:	4505                	li	a0,1
    217e:	329020ef          	jal	4ca6 <exit>
    2182:	84be                	mv	s1,a5
    b = sbrk(1);
    2184:	4505                	li	a0,1
    2186:	2cd020ef          	jal	4c52 <sbrk>
    if(b != a){
    218a:	04951263          	bne	a0,s1,21ce <sbrkbasic+0xfa>
    *b = 1;
    218e:	4785                	li	a5,1
    2190:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2194:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2198:	2905                	addiw	s2,s2,1
    219a:	ff4914e3          	bne	s2,s4,2182 <sbrkbasic+0xae>
  pid = fork();
    219e:	301020ef          	jal	4c9e <fork>
    21a2:	892a                	mv	s2,a0
  if(pid < 0){
    21a4:	04054263          	bltz	a0,21e8 <sbrkbasic+0x114>
  c = sbrk(1);
    21a8:	4505                	li	a0,1
    21aa:	2a9020ef          	jal	4c52 <sbrk>
  c = sbrk(1);
    21ae:	4505                	li	a0,1
    21b0:	2a3020ef          	jal	4c52 <sbrk>
  if(c != a + 1){
    21b4:	0489                	addi	s1,s1,2
    21b6:	04a48363          	beq	s1,a0,21fc <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    21ba:	85ce                	mv	a1,s3
    21bc:	00004517          	auipc	a0,0x4
    21c0:	e3c50513          	addi	a0,a0,-452 # 5ff8 <malloc+0xe6a>
    21c4:	717020ef          	jal	50da <printf>
    exit(1);
    21c8:	4505                	li	a0,1
    21ca:	2dd020ef          	jal	4ca6 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    21ce:	872a                	mv	a4,a0
    21d0:	86a6                	mv	a3,s1
    21d2:	864a                	mv	a2,s2
    21d4:	85ce                	mv	a1,s3
    21d6:	00004517          	auipc	a0,0x4
    21da:	de250513          	addi	a0,a0,-542 # 5fb8 <malloc+0xe2a>
    21de:	6fd020ef          	jal	50da <printf>
      exit(1);
    21e2:	4505                	li	a0,1
    21e4:	2c3020ef          	jal	4ca6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    21e8:	85ce                	mv	a1,s3
    21ea:	00004517          	auipc	a0,0x4
    21ee:	dee50513          	addi	a0,a0,-530 # 5fd8 <malloc+0xe4a>
    21f2:	6e9020ef          	jal	50da <printf>
    exit(1);
    21f6:	4505                	li	a0,1
    21f8:	2af020ef          	jal	4ca6 <exit>
  if(pid == 0)
    21fc:	00091563          	bnez	s2,2206 <sbrkbasic+0x132>
    exit(0);
    2200:	4501                	li	a0,0
    2202:	2a5020ef          	jal	4ca6 <exit>
  wait(&xstatus);
    2206:	fcc40513          	addi	a0,s0,-52
    220a:	2a5020ef          	jal	4cae <wait>
  exit(xstatus);
    220e:	fcc42503          	lw	a0,-52(s0)
    2212:	295020ef          	jal	4ca6 <exit>

0000000000002216 <sbrkmuch>:
{
    2216:	7179                	addi	sp,sp,-48
    2218:	f406                	sd	ra,40(sp)
    221a:	f022                	sd	s0,32(sp)
    221c:	ec26                	sd	s1,24(sp)
    221e:	e84a                	sd	s2,16(sp)
    2220:	e44e                	sd	s3,8(sp)
    2222:	e052                	sd	s4,0(sp)
    2224:	1800                	addi	s0,sp,48
    2226:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2228:	4501                	li	a0,0
    222a:	229020ef          	jal	4c52 <sbrk>
    222e:	892a                	mv	s2,a0
  a = sbrk(0);
    2230:	4501                	li	a0,0
    2232:	221020ef          	jal	4c52 <sbrk>
    2236:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2238:	06400537          	lui	a0,0x6400
    223c:	9d05                	subw	a0,a0,s1
    223e:	215020ef          	jal	4c52 <sbrk>
  if (p != a) {
    2242:	08a49763          	bne	s1,a0,22d0 <sbrkmuch+0xba>
  *lastaddr = 99;
    2246:	064007b7          	lui	a5,0x6400
    224a:	06300713          	li	a4,99
    224e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0357>
  a = sbrk(0);
    2252:	4501                	li	a0,0
    2254:	1ff020ef          	jal	4c52 <sbrk>
    2258:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    225a:	757d                	lui	a0,0xfffff
    225c:	1f7020ef          	jal	4c52 <sbrk>
  if(c == (char*)SBRK_ERROR){
    2260:	57fd                	li	a5,-1
    2262:	08f50163          	beq	a0,a5,22e4 <sbrkmuch+0xce>
  c = sbrk(0);
    2266:	4501                	li	a0,0
    2268:	1eb020ef          	jal	4c52 <sbrk>
  if(c != a - PGSIZE){
    226c:	77fd                	lui	a5,0xfffff
    226e:	97a6                	add	a5,a5,s1
    2270:	08f51463          	bne	a0,a5,22f8 <sbrkmuch+0xe2>
  a = sbrk(0);
    2274:	4501                	li	a0,0
    2276:	1dd020ef          	jal	4c52 <sbrk>
    227a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    227c:	6505                	lui	a0,0x1
    227e:	1d5020ef          	jal	4c52 <sbrk>
    2282:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2284:	08a49663          	bne	s1,a0,2310 <sbrkmuch+0xfa>
    2288:	4501                	li	a0,0
    228a:	1c9020ef          	jal	4c52 <sbrk>
    228e:	6785                	lui	a5,0x1
    2290:	97a6                	add	a5,a5,s1
    2292:	06f51f63          	bne	a0,a5,2310 <sbrkmuch+0xfa>
  if(*lastaddr == 99){
    2296:	064007b7          	lui	a5,0x6400
    229a:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0357>
    229e:	06300793          	li	a5,99
    22a2:	08f70363          	beq	a4,a5,2328 <sbrkmuch+0x112>
  a = sbrk(0);
    22a6:	4501                	li	a0,0
    22a8:	1ab020ef          	jal	4c52 <sbrk>
    22ac:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    22ae:	4501                	li	a0,0
    22b0:	1a3020ef          	jal	4c52 <sbrk>
    22b4:	40a9053b          	subw	a0,s2,a0
    22b8:	19b020ef          	jal	4c52 <sbrk>
  if(c != a){
    22bc:	08a49063          	bne	s1,a0,233c <sbrkmuch+0x126>
}
    22c0:	70a2                	ld	ra,40(sp)
    22c2:	7402                	ld	s0,32(sp)
    22c4:	64e2                	ld	s1,24(sp)
    22c6:	6942                	ld	s2,16(sp)
    22c8:	69a2                	ld	s3,8(sp)
    22ca:	6a02                	ld	s4,0(sp)
    22cc:	6145                	addi	sp,sp,48
    22ce:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    22d0:	85ce                	mv	a1,s3
    22d2:	00004517          	auipc	a0,0x4
    22d6:	d4650513          	addi	a0,a0,-698 # 6018 <malloc+0xe8a>
    22da:	601020ef          	jal	50da <printf>
    exit(1);
    22de:	4505                	li	a0,1
    22e0:	1c7020ef          	jal	4ca6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22e4:	85ce                	mv	a1,s3
    22e6:	00004517          	auipc	a0,0x4
    22ea:	d7a50513          	addi	a0,a0,-646 # 6060 <malloc+0xed2>
    22ee:	5ed020ef          	jal	50da <printf>
    exit(1);
    22f2:	4505                	li	a0,1
    22f4:	1b3020ef          	jal	4ca6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    22f8:	86aa                	mv	a3,a0
    22fa:	8626                	mv	a2,s1
    22fc:	85ce                	mv	a1,s3
    22fe:	00004517          	auipc	a0,0x4
    2302:	d8250513          	addi	a0,a0,-638 # 6080 <malloc+0xef2>
    2306:	5d5020ef          	jal	50da <printf>
    exit(1);
    230a:	4505                	li	a0,1
    230c:	19b020ef          	jal	4ca6 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2310:	86d2                	mv	a3,s4
    2312:	8626                	mv	a2,s1
    2314:	85ce                	mv	a1,s3
    2316:	00004517          	auipc	a0,0x4
    231a:	daa50513          	addi	a0,a0,-598 # 60c0 <malloc+0xf32>
    231e:	5bd020ef          	jal	50da <printf>
    exit(1);
    2322:	4505                	li	a0,1
    2324:	183020ef          	jal	4ca6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2328:	85ce                	mv	a1,s3
    232a:	00004517          	auipc	a0,0x4
    232e:	dc650513          	addi	a0,a0,-570 # 60f0 <malloc+0xf62>
    2332:	5a9020ef          	jal	50da <printf>
    exit(1);
    2336:	4505                	li	a0,1
    2338:	16f020ef          	jal	4ca6 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    233c:	86aa                	mv	a3,a0
    233e:	8626                	mv	a2,s1
    2340:	85ce                	mv	a1,s3
    2342:	00004517          	auipc	a0,0x4
    2346:	de650513          	addi	a0,a0,-538 # 6128 <malloc+0xf9a>
    234a:	591020ef          	jal	50da <printf>
    exit(1);
    234e:	4505                	li	a0,1
    2350:	157020ef          	jal	4ca6 <exit>

0000000000002354 <sbrkarg>:
{
    2354:	7179                	addi	sp,sp,-48
    2356:	f406                	sd	ra,40(sp)
    2358:	f022                	sd	s0,32(sp)
    235a:	ec26                	sd	s1,24(sp)
    235c:	e84a                	sd	s2,16(sp)
    235e:	e44e                	sd	s3,8(sp)
    2360:	1800                	addi	s0,sp,48
    2362:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2364:	6505                	lui	a0,0x1
    2366:	0ed020ef          	jal	4c52 <sbrk>
    236a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    236c:	20100593          	li	a1,513
    2370:	00004517          	auipc	a0,0x4
    2374:	de050513          	addi	a0,a0,-544 # 6150 <malloc+0xfc2>
    2378:	16f020ef          	jal	4ce6 <open>
    237c:	84aa                	mv	s1,a0
  unlink("sbrk");
    237e:	00004517          	auipc	a0,0x4
    2382:	dd250513          	addi	a0,a0,-558 # 6150 <malloc+0xfc2>
    2386:	171020ef          	jal	4cf6 <unlink>
  if(fd < 0)  {
    238a:	0204c963          	bltz	s1,23bc <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    238e:	6605                	lui	a2,0x1
    2390:	85ca                	mv	a1,s2
    2392:	8526                	mv	a0,s1
    2394:	133020ef          	jal	4cc6 <write>
    2398:	02054c63          	bltz	a0,23d0 <sbrkarg+0x7c>
  close(fd);
    239c:	8526                	mv	a0,s1
    239e:	131020ef          	jal	4cce <close>
  a = sbrk(PGSIZE);
    23a2:	6505                	lui	a0,0x1
    23a4:	0af020ef          	jal	4c52 <sbrk>
  if(pipe((int *) a) != 0){
    23a8:	10f020ef          	jal	4cb6 <pipe>
    23ac:	ed05                	bnez	a0,23e4 <sbrkarg+0x90>
}
    23ae:	70a2                	ld	ra,40(sp)
    23b0:	7402                	ld	s0,32(sp)
    23b2:	64e2                	ld	s1,24(sp)
    23b4:	6942                	ld	s2,16(sp)
    23b6:	69a2                	ld	s3,8(sp)
    23b8:	6145                	addi	sp,sp,48
    23ba:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    23bc:	85ce                	mv	a1,s3
    23be:	00004517          	auipc	a0,0x4
    23c2:	d9a50513          	addi	a0,a0,-614 # 6158 <malloc+0xfca>
    23c6:	515020ef          	jal	50da <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	0db020ef          	jal	4ca6 <exit>
    printf("%s: write sbrk failed\n", s);
    23d0:	85ce                	mv	a1,s3
    23d2:	00004517          	auipc	a0,0x4
    23d6:	d9e50513          	addi	a0,a0,-610 # 6170 <malloc+0xfe2>
    23da:	501020ef          	jal	50da <printf>
    exit(1);
    23de:	4505                	li	a0,1
    23e0:	0c7020ef          	jal	4ca6 <exit>
    printf("%s: pipe() failed\n", s);
    23e4:	85ce                	mv	a1,s3
    23e6:	00004517          	auipc	a0,0x4
    23ea:	87a50513          	addi	a0,a0,-1926 # 5c60 <malloc+0xad2>
    23ee:	4ed020ef          	jal	50da <printf>
    exit(1);
    23f2:	4505                	li	a0,1
    23f4:	0b3020ef          	jal	4ca6 <exit>

00000000000023f8 <argptest>:
{
    23f8:	1101                	addi	sp,sp,-32
    23fa:	ec06                	sd	ra,24(sp)
    23fc:	e822                	sd	s0,16(sp)
    23fe:	e426                	sd	s1,8(sp)
    2400:	e04a                	sd	s2,0(sp)
    2402:	1000                	addi	s0,sp,32
    2404:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2406:	4581                	li	a1,0
    2408:	00004517          	auipc	a0,0x4
    240c:	d8050513          	addi	a0,a0,-640 # 6188 <malloc+0xffa>
    2410:	0d7020ef          	jal	4ce6 <open>
  if (fd < 0) {
    2414:	02054563          	bltz	a0,243e <argptest+0x46>
    2418:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    241a:	4501                	li	a0,0
    241c:	037020ef          	jal	4c52 <sbrk>
    2420:	567d                	li	a2,-1
    2422:	fff50593          	addi	a1,a0,-1
    2426:	8526                	mv	a0,s1
    2428:	097020ef          	jal	4cbe <read>
  close(fd);
    242c:	8526                	mv	a0,s1
    242e:	0a1020ef          	jal	4cce <close>
}
    2432:	60e2                	ld	ra,24(sp)
    2434:	6442                	ld	s0,16(sp)
    2436:	64a2                	ld	s1,8(sp)
    2438:	6902                	ld	s2,0(sp)
    243a:	6105                	addi	sp,sp,32
    243c:	8082                	ret
    printf("%s: open failed\n", s);
    243e:	85ca                	mv	a1,s2
    2440:	00003517          	auipc	a0,0x3
    2444:	73050513          	addi	a0,a0,1840 # 5b70 <malloc+0x9e2>
    2448:	493020ef          	jal	50da <printf>
    exit(1);
    244c:	4505                	li	a0,1
    244e:	059020ef          	jal	4ca6 <exit>

0000000000002452 <sbrkbugs>:
{
    2452:	1141                	addi	sp,sp,-16
    2454:	e406                	sd	ra,8(sp)
    2456:	e022                	sd	s0,0(sp)
    2458:	0800                	addi	s0,sp,16
  int pid = fork();
    245a:	045020ef          	jal	4c9e <fork>
  if(pid < 0){
    245e:	00054c63          	bltz	a0,2476 <sbrkbugs+0x24>
  if(pid == 0){
    2462:	e11d                	bnez	a0,2488 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2464:	7ee020ef          	jal	4c52 <sbrk>
    sbrk(-sz);
    2468:	40a0053b          	negw	a0,a0
    246c:	7e6020ef          	jal	4c52 <sbrk>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	035020ef          	jal	4ca6 <exit>
    printf("fork failed\n");
    2476:	00005517          	auipc	a0,0x5
    247a:	c8a50513          	addi	a0,a0,-886 # 7100 <malloc+0x1f72>
    247e:	45d020ef          	jal	50da <printf>
    exit(1);
    2482:	4505                	li	a0,1
    2484:	023020ef          	jal	4ca6 <exit>
  wait(0);
    2488:	4501                	li	a0,0
    248a:	025020ef          	jal	4cae <wait>
  pid = fork();
    248e:	011020ef          	jal	4c9e <fork>
  if(pid < 0){
    2492:	00054f63          	bltz	a0,24b0 <sbrkbugs+0x5e>
  if(pid == 0){
    2496:	e515                	bnez	a0,24c2 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    2498:	7ba020ef          	jal	4c52 <sbrk>
    sbrk(-(sz - 3500));
    249c:	6785                	lui	a5,0x1
    249e:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    24a2:	40a7853b          	subw	a0,a5,a0
    24a6:	7ac020ef          	jal	4c52 <sbrk>
    exit(0);
    24aa:	4501                	li	a0,0
    24ac:	7fa020ef          	jal	4ca6 <exit>
    printf("fork failed\n");
    24b0:	00005517          	auipc	a0,0x5
    24b4:	c5050513          	addi	a0,a0,-944 # 7100 <malloc+0x1f72>
    24b8:	423020ef          	jal	50da <printf>
    exit(1);
    24bc:	4505                	li	a0,1
    24be:	7e8020ef          	jal	4ca6 <exit>
  wait(0);
    24c2:	4501                	li	a0,0
    24c4:	7ea020ef          	jal	4cae <wait>
  pid = fork();
    24c8:	7d6020ef          	jal	4c9e <fork>
  if(pid < 0){
    24cc:	02054263          	bltz	a0,24f0 <sbrkbugs+0x9e>
  if(pid == 0){
    24d0:	e90d                	bnez	a0,2502 <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    24d2:	780020ef          	jal	4c52 <sbrk>
    24d6:	67ad                	lui	a5,0xb
    24d8:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x268>
    24dc:	40a7853b          	subw	a0,a5,a0
    24e0:	772020ef          	jal	4c52 <sbrk>
    sbrk(-10);
    24e4:	5559                	li	a0,-10
    24e6:	76c020ef          	jal	4c52 <sbrk>
    exit(0);
    24ea:	4501                	li	a0,0
    24ec:	7ba020ef          	jal	4ca6 <exit>
    printf("fork failed\n");
    24f0:	00005517          	auipc	a0,0x5
    24f4:	c1050513          	addi	a0,a0,-1008 # 7100 <malloc+0x1f72>
    24f8:	3e3020ef          	jal	50da <printf>
    exit(1);
    24fc:	4505                	li	a0,1
    24fe:	7a8020ef          	jal	4ca6 <exit>
  wait(0);
    2502:	4501                	li	a0,0
    2504:	7aa020ef          	jal	4cae <wait>
  exit(0);
    2508:	4501                	li	a0,0
    250a:	79c020ef          	jal	4ca6 <exit>

000000000000250e <sbrklast>:
{
    250e:	7179                	addi	sp,sp,-48
    2510:	f406                	sd	ra,40(sp)
    2512:	f022                	sd	s0,32(sp)
    2514:	ec26                	sd	s1,24(sp)
    2516:	e84a                	sd	s2,16(sp)
    2518:	e44e                	sd	s3,8(sp)
    251a:	e052                	sd	s4,0(sp)
    251c:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    251e:	4501                	li	a0,0
    2520:	732020ef          	jal	4c52 <sbrk>
  if((top % PGSIZE) != 0)
    2524:	03451793          	slli	a5,a0,0x34
    2528:	ebad                	bnez	a5,259a <sbrklast+0x8c>
  sbrk(PGSIZE);
    252a:	6505                	lui	a0,0x1
    252c:	726020ef          	jal	4c52 <sbrk>
  sbrk(10);
    2530:	4529                	li	a0,10
    2532:	720020ef          	jal	4c52 <sbrk>
  sbrk(-20);
    2536:	5531                	li	a0,-20
    2538:	71a020ef          	jal	4c52 <sbrk>
  top = (uint64) sbrk(0);
    253c:	4501                	li	a0,0
    253e:	714020ef          	jal	4c52 <sbrk>
    2542:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2544:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    2548:	07800a13          	li	s4,120
    254c:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2550:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2554:	20200593          	li	a1,514
    2558:	854a                	mv	a0,s2
    255a:	78c020ef          	jal	4ce6 <open>
    255e:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2560:	4605                	li	a2,1
    2562:	85ca                	mv	a1,s2
    2564:	762020ef          	jal	4cc6 <write>
  close(fd);
    2568:	854e                	mv	a0,s3
    256a:	764020ef          	jal	4cce <close>
  fd = open(p, O_RDWR);
    256e:	4589                	li	a1,2
    2570:	854a                	mv	a0,s2
    2572:	774020ef          	jal	4ce6 <open>
  p[0] = '\0';
    2576:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    257a:	4605                	li	a2,1
    257c:	85ca                	mv	a1,s2
    257e:	740020ef          	jal	4cbe <read>
  if(p[0] != 'x')
    2582:	fc04c783          	lbu	a5,-64(s1)
    2586:	03479263          	bne	a5,s4,25aa <sbrklast+0x9c>
}
    258a:	70a2                	ld	ra,40(sp)
    258c:	7402                	ld	s0,32(sp)
    258e:	64e2                	ld	s1,24(sp)
    2590:	6942                	ld	s2,16(sp)
    2592:	69a2                	ld	s3,8(sp)
    2594:	6a02                	ld	s4,0(sp)
    2596:	6145                	addi	sp,sp,48
    2598:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    259a:	0347d513          	srli	a0,a5,0x34
    259e:	6785                	lui	a5,0x1
    25a0:	40a7853b          	subw	a0,a5,a0
    25a4:	6ae020ef          	jal	4c52 <sbrk>
    25a8:	b749                	j	252a <sbrklast+0x1c>
    exit(1);
    25aa:	4505                	li	a0,1
    25ac:	6fa020ef          	jal	4ca6 <exit>

00000000000025b0 <sbrk8000>:
{
    25b0:	1141                	addi	sp,sp,-16
    25b2:	e406                	sd	ra,8(sp)
    25b4:	e022                	sd	s0,0(sp)
    25b6:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    25b8:	80000537          	lui	a0,0x80000
    25bc:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff035c>
    25be:	694020ef          	jal	4c52 <sbrk>
  volatile char *top = sbrk(0);
    25c2:	4501                	li	a0,0
    25c4:	68e020ef          	jal	4c52 <sbrk>
  *(top-1) = *(top-1) + 1;
    25c8:	fff54783          	lbu	a5,-1(a0)
    25cc:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    25ce:	0ff7f793          	zext.b	a5,a5
    25d2:	fef50fa3          	sb	a5,-1(a0)
}
    25d6:	60a2                	ld	ra,8(sp)
    25d8:	6402                	ld	s0,0(sp)
    25da:	0141                	addi	sp,sp,16
    25dc:	8082                	ret

00000000000025de <execout>:
{
    25de:	715d                	addi	sp,sp,-80
    25e0:	e486                	sd	ra,72(sp)
    25e2:	e0a2                	sd	s0,64(sp)
    25e4:	fc26                	sd	s1,56(sp)
    25e6:	f84a                	sd	s2,48(sp)
    25e8:	f44e                	sd	s3,40(sp)
    25ea:	f052                	sd	s4,32(sp)
    25ec:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    25ee:	4901                	li	s2,0
    25f0:	49bd                	li	s3,15
    int pid = fork();
    25f2:	6ac020ef          	jal	4c9e <fork>
    25f6:	84aa                	mv	s1,a0
    if(pid < 0){
    25f8:	00054c63          	bltz	a0,2610 <execout+0x32>
    } else if(pid == 0){
    25fc:	c11d                	beqz	a0,2622 <execout+0x44>
      wait((int*)0);
    25fe:	4501                	li	a0,0
    2600:	6ae020ef          	jal	4cae <wait>
  for(int avail = 0; avail < 15; avail++){
    2604:	2905                	addiw	s2,s2,1
    2606:	ff3916e3          	bne	s2,s3,25f2 <execout+0x14>
  exit(0);
    260a:	4501                	li	a0,0
    260c:	69a020ef          	jal	4ca6 <exit>
      printf("fork failed\n");
    2610:	00005517          	auipc	a0,0x5
    2614:	af050513          	addi	a0,a0,-1296 # 7100 <malloc+0x1f72>
    2618:	2c3020ef          	jal	50da <printf>
      exit(1);
    261c:	4505                	li	a0,1
    261e:	688020ef          	jal	4ca6 <exit>
        if(a == SBRK_ERROR)
    2622:	59fd                	li	s3,-1
        *(a + PGSIZE - 1) = 1;
    2624:	4a05                	li	s4,1
        char *a = sbrk(PGSIZE);
    2626:	6505                	lui	a0,0x1
    2628:	62a020ef          	jal	4c52 <sbrk>
        if(a == SBRK_ERROR)
    262c:	01350763          	beq	a0,s3,263a <execout+0x5c>
        *(a + PGSIZE - 1) = 1;
    2630:	6785                	lui	a5,0x1
    2632:	953e                	add	a0,a0,a5
    2634:	ff450fa3          	sb	s4,-1(a0) # fff <pgbug+0x2b>
      while(1){
    2638:	b7fd                	j	2626 <execout+0x48>
      for(int i = 0; i < avail; i++)
    263a:	01205863          	blez	s2,264a <execout+0x6c>
        sbrk(-PGSIZE);
    263e:	757d                	lui	a0,0xfffff
    2640:	612020ef          	jal	4c52 <sbrk>
      for(int i = 0; i < avail; i++)
    2644:	2485                	addiw	s1,s1,1
    2646:	ff249ce3          	bne	s1,s2,263e <execout+0x60>
      close(1);
    264a:	4505                	li	a0,1
    264c:	682020ef          	jal	4cce <close>
      char *args[] = { "echo", "x", 0 };
    2650:	00003517          	auipc	a0,0x3
    2654:	c7850513          	addi	a0,a0,-904 # 52c8 <malloc+0x13a>
    2658:	faa43c23          	sd	a0,-72(s0)
    265c:	00003797          	auipc	a5,0x3
    2660:	cdc78793          	addi	a5,a5,-804 # 5338 <malloc+0x1aa>
    2664:	fcf43023          	sd	a5,-64(s0)
    2668:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    266c:	fb840593          	addi	a1,s0,-72
    2670:	66e020ef          	jal	4cde <exec>
      exit(0);
    2674:	4501                	li	a0,0
    2676:	630020ef          	jal	4ca6 <exit>

000000000000267a <fourteen>:
{
    267a:	1101                	addi	sp,sp,-32
    267c:	ec06                	sd	ra,24(sp)
    267e:	e822                	sd	s0,16(sp)
    2680:	e426                	sd	s1,8(sp)
    2682:	1000                	addi	s0,sp,32
    2684:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2686:	00004517          	auipc	a0,0x4
    268a:	cda50513          	addi	a0,a0,-806 # 6360 <malloc+0x11d2>
    268e:	680020ef          	jal	4d0e <mkdir>
    2692:	e555                	bnez	a0,273e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    2694:	00004517          	auipc	a0,0x4
    2698:	b2450513          	addi	a0,a0,-1244 # 61b8 <malloc+0x102a>
    269c:	672020ef          	jal	4d0e <mkdir>
    26a0:	e94d                	bnez	a0,2752 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26a2:	20000593          	li	a1,512
    26a6:	00004517          	auipc	a0,0x4
    26aa:	b6a50513          	addi	a0,a0,-1174 # 6210 <malloc+0x1082>
    26ae:	638020ef          	jal	4ce6 <open>
  if(fd < 0){
    26b2:	0a054a63          	bltz	a0,2766 <fourteen+0xec>
  close(fd);
    26b6:	618020ef          	jal	4cce <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    26ba:	4581                	li	a1,0
    26bc:	00004517          	auipc	a0,0x4
    26c0:	bcc50513          	addi	a0,a0,-1076 # 6288 <malloc+0x10fa>
    26c4:	622020ef          	jal	4ce6 <open>
  if(fd < 0){
    26c8:	0a054963          	bltz	a0,277a <fourteen+0x100>
  close(fd);
    26cc:	602020ef          	jal	4cce <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26d0:	00004517          	auipc	a0,0x4
    26d4:	c2850513          	addi	a0,a0,-984 # 62f8 <malloc+0x116a>
    26d8:	636020ef          	jal	4d0e <mkdir>
    26dc:	c94d                	beqz	a0,278e <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26de:	00004517          	auipc	a0,0x4
    26e2:	c7250513          	addi	a0,a0,-910 # 6350 <malloc+0x11c2>
    26e6:	628020ef          	jal	4d0e <mkdir>
    26ea:	cd45                	beqz	a0,27a2 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    26ec:	00004517          	auipc	a0,0x4
    26f0:	c6450513          	addi	a0,a0,-924 # 6350 <malloc+0x11c2>
    26f4:	602020ef          	jal	4cf6 <unlink>
  unlink("12345678901234/12345678901234");
    26f8:	00004517          	auipc	a0,0x4
    26fc:	c0050513          	addi	a0,a0,-1024 # 62f8 <malloc+0x116a>
    2700:	5f6020ef          	jal	4cf6 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2704:	00004517          	auipc	a0,0x4
    2708:	b8450513          	addi	a0,a0,-1148 # 6288 <malloc+0x10fa>
    270c:	5ea020ef          	jal	4cf6 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2710:	00004517          	auipc	a0,0x4
    2714:	b0050513          	addi	a0,a0,-1280 # 6210 <malloc+0x1082>
    2718:	5de020ef          	jal	4cf6 <unlink>
  unlink("12345678901234/123456789012345");
    271c:	00004517          	auipc	a0,0x4
    2720:	a9c50513          	addi	a0,a0,-1380 # 61b8 <malloc+0x102a>
    2724:	5d2020ef          	jal	4cf6 <unlink>
  unlink("12345678901234");
    2728:	00004517          	auipc	a0,0x4
    272c:	c3850513          	addi	a0,a0,-968 # 6360 <malloc+0x11d2>
    2730:	5c6020ef          	jal	4cf6 <unlink>
}
    2734:	60e2                	ld	ra,24(sp)
    2736:	6442                	ld	s0,16(sp)
    2738:	64a2                	ld	s1,8(sp)
    273a:	6105                	addi	sp,sp,32
    273c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    273e:	85a6                	mv	a1,s1
    2740:	00004517          	auipc	a0,0x4
    2744:	a5050513          	addi	a0,a0,-1456 # 6190 <malloc+0x1002>
    2748:	193020ef          	jal	50da <printf>
    exit(1);
    274c:	4505                	li	a0,1
    274e:	558020ef          	jal	4ca6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2752:	85a6                	mv	a1,s1
    2754:	00004517          	auipc	a0,0x4
    2758:	a8450513          	addi	a0,a0,-1404 # 61d8 <malloc+0x104a>
    275c:	17f020ef          	jal	50da <printf>
    exit(1);
    2760:	4505                	li	a0,1
    2762:	544020ef          	jal	4ca6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2766:	85a6                	mv	a1,s1
    2768:	00004517          	auipc	a0,0x4
    276c:	ad850513          	addi	a0,a0,-1320 # 6240 <malloc+0x10b2>
    2770:	16b020ef          	jal	50da <printf>
    exit(1);
    2774:	4505                	li	a0,1
    2776:	530020ef          	jal	4ca6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    277a:	85a6                	mv	a1,s1
    277c:	00004517          	auipc	a0,0x4
    2780:	b3c50513          	addi	a0,a0,-1220 # 62b8 <malloc+0x112a>
    2784:	157020ef          	jal	50da <printf>
    exit(1);
    2788:	4505                	li	a0,1
    278a:	51c020ef          	jal	4ca6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    278e:	85a6                	mv	a1,s1
    2790:	00004517          	auipc	a0,0x4
    2794:	b8850513          	addi	a0,a0,-1144 # 6318 <malloc+0x118a>
    2798:	143020ef          	jal	50da <printf>
    exit(1);
    279c:	4505                	li	a0,1
    279e:	508020ef          	jal	4ca6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    27a2:	85a6                	mv	a1,s1
    27a4:	00004517          	auipc	a0,0x4
    27a8:	bcc50513          	addi	a0,a0,-1076 # 6370 <malloc+0x11e2>
    27ac:	12f020ef          	jal	50da <printf>
    exit(1);
    27b0:	4505                	li	a0,1
    27b2:	4f4020ef          	jal	4ca6 <exit>

00000000000027b6 <diskfull>:
{
    27b6:	b8010113          	addi	sp,sp,-1152
    27ba:	46113c23          	sd	ra,1144(sp)
    27be:	46813823          	sd	s0,1136(sp)
    27c2:	46913423          	sd	s1,1128(sp)
    27c6:	47213023          	sd	s2,1120(sp)
    27ca:	45313c23          	sd	s3,1112(sp)
    27ce:	45413823          	sd	s4,1104(sp)
    27d2:	45513423          	sd	s5,1096(sp)
    27d6:	45613023          	sd	s6,1088(sp)
    27da:	43713c23          	sd	s7,1080(sp)
    27de:	43813823          	sd	s8,1072(sp)
    27e2:	43913423          	sd	s9,1064(sp)
    27e6:	48010413          	addi	s0,sp,1152
    27ea:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    27ec:	00004517          	auipc	a0,0x4
    27f0:	bbc50513          	addi	a0,a0,-1092 # 63a8 <malloc+0x121a>
    27f4:	502020ef          	jal	4cf6 <unlink>
    27f8:	03000993          	li	s3,48
    name[0] = 'b';
    27fc:	06200b13          	li	s6,98
    name[1] = 'i';
    2800:	06900a93          	li	s5,105
    name[2] = 'g';
    2804:	06700a13          	li	s4,103
    2808:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    280c:	07f00c13          	li	s8,127
    2810:	aab9                	j	296e <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    2812:	b8040613          	addi	a2,s0,-1152
    2816:	85e6                	mv	a1,s9
    2818:	00004517          	auipc	a0,0x4
    281c:	ba050513          	addi	a0,a0,-1120 # 63b8 <malloc+0x122a>
    2820:	0bb020ef          	jal	50da <printf>
      break;
    2824:	a039                	j	2832 <diskfull+0x7c>
        close(fd);
    2826:	854a                	mv	a0,s2
    2828:	4a6020ef          	jal	4cce <close>
    close(fd);
    282c:	854a                	mv	a0,s2
    282e:	4a0020ef          	jal	4cce <close>
  for(int i = 0; i < nzz; i++){
    2832:	4481                	li	s1,0
    name[0] = 'z';
    2834:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2838:	08000993          	li	s3,128
    name[0] = 'z';
    283c:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2840:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2844:	41f4d71b          	sraiw	a4,s1,0x1f
    2848:	01b7571b          	srliw	a4,a4,0x1b
    284c:	009707bb          	addw	a5,a4,s1
    2850:	4057d69b          	sraiw	a3,a5,0x5
    2854:	0306869b          	addiw	a3,a3,48
    2858:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    285c:	8bfd                	andi	a5,a5,31
    285e:	9f99                	subw	a5,a5,a4
    2860:	0307879b          	addiw	a5,a5,48
    2864:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2868:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    286c:	ba040513          	addi	a0,s0,-1120
    2870:	486020ef          	jal	4cf6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2874:	60200593          	li	a1,1538
    2878:	ba040513          	addi	a0,s0,-1120
    287c:	46a020ef          	jal	4ce6 <open>
    if(fd < 0)
    2880:	00054763          	bltz	a0,288e <diskfull+0xd8>
    close(fd);
    2884:	44a020ef          	jal	4cce <close>
  for(int i = 0; i < nzz; i++){
    2888:	2485                	addiw	s1,s1,1
    288a:	fb3499e3          	bne	s1,s3,283c <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    288e:	00004517          	auipc	a0,0x4
    2892:	b1a50513          	addi	a0,a0,-1254 # 63a8 <malloc+0x121a>
    2896:	478020ef          	jal	4d0e <mkdir>
    289a:	12050063          	beqz	a0,29ba <diskfull+0x204>
  unlink("diskfulldir");
    289e:	00004517          	auipc	a0,0x4
    28a2:	b0a50513          	addi	a0,a0,-1270 # 63a8 <malloc+0x121a>
    28a6:	450020ef          	jal	4cf6 <unlink>
  for(int i = 0; i < nzz; i++){
    28aa:	4481                	li	s1,0
    name[0] = 'z';
    28ac:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    28b0:	08000993          	li	s3,128
    name[0] = 'z';
    28b4:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    28b8:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    28bc:	41f4d71b          	sraiw	a4,s1,0x1f
    28c0:	01b7571b          	srliw	a4,a4,0x1b
    28c4:	009707bb          	addw	a5,a4,s1
    28c8:	4057d69b          	sraiw	a3,a5,0x5
    28cc:	0306869b          	addiw	a3,a3,48
    28d0:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28d4:	8bfd                	andi	a5,a5,31
    28d6:	9f99                	subw	a5,a5,a4
    28d8:	0307879b          	addiw	a5,a5,48
    28dc:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28e0:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28e4:	ba040513          	addi	a0,s0,-1120
    28e8:	40e020ef          	jal	4cf6 <unlink>
  for(int i = 0; i < nzz; i++){
    28ec:	2485                	addiw	s1,s1,1
    28ee:	fd3493e3          	bne	s1,s3,28b4 <diskfull+0xfe>
    28f2:	03000493          	li	s1,48
    name[0] = 'b';
    28f6:	06200a93          	li	s5,98
    name[1] = 'i';
    28fa:	06900a13          	li	s4,105
    name[2] = 'g';
    28fe:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    2902:	07f00913          	li	s2,127
    name[0] = 'b';
    2906:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    290a:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    290e:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    2912:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    2916:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    291a:	ba040513          	addi	a0,s0,-1120
    291e:	3d8020ef          	jal	4cf6 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2922:	2485                	addiw	s1,s1,1
    2924:	0ff4f493          	zext.b	s1,s1
    2928:	fd249fe3          	bne	s1,s2,2906 <diskfull+0x150>
}
    292c:	47813083          	ld	ra,1144(sp)
    2930:	47013403          	ld	s0,1136(sp)
    2934:	46813483          	ld	s1,1128(sp)
    2938:	46013903          	ld	s2,1120(sp)
    293c:	45813983          	ld	s3,1112(sp)
    2940:	45013a03          	ld	s4,1104(sp)
    2944:	44813a83          	ld	s5,1096(sp)
    2948:	44013b03          	ld	s6,1088(sp)
    294c:	43813b83          	ld	s7,1080(sp)
    2950:	43013c03          	ld	s8,1072(sp)
    2954:	42813c83          	ld	s9,1064(sp)
    2958:	48010113          	addi	sp,sp,1152
    295c:	8082                	ret
    close(fd);
    295e:	854a                	mv	a0,s2
    2960:	36e020ef          	jal	4cce <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2964:	2985                	addiw	s3,s3,1
    2966:	0ff9f993          	zext.b	s3,s3
    296a:	ed8984e3          	beq	s3,s8,2832 <diskfull+0x7c>
    name[0] = 'b';
    296e:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    2972:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2976:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    297a:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    297e:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    2982:	b8040513          	addi	a0,s0,-1152
    2986:	370020ef          	jal	4cf6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    298a:	60200593          	li	a1,1538
    298e:	b8040513          	addi	a0,s0,-1152
    2992:	354020ef          	jal	4ce6 <open>
    2996:	892a                	mv	s2,a0
    if(fd < 0){
    2998:	e6054de3          	bltz	a0,2812 <diskfull+0x5c>
    299c:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    299e:	40000613          	li	a2,1024
    29a2:	ba040593          	addi	a1,s0,-1120
    29a6:	854a                	mv	a0,s2
    29a8:	31e020ef          	jal	4cc6 <write>
    29ac:	40000793          	li	a5,1024
    29b0:	e6f51be3          	bne	a0,a5,2826 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    29b4:	34fd                	addiw	s1,s1,-1
    29b6:	f4e5                	bnez	s1,299e <diskfull+0x1e8>
    29b8:	b75d                	j	295e <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    29ba:	85e6                	mv	a1,s9
    29bc:	00004517          	auipc	a0,0x4
    29c0:	a1c50513          	addi	a0,a0,-1508 # 63d8 <malloc+0x124a>
    29c4:	716020ef          	jal	50da <printf>
    29c8:	bdd9                	j	289e <diskfull+0xe8>

00000000000029ca <iputtest>:
{
    29ca:	1101                	addi	sp,sp,-32
    29cc:	ec06                	sd	ra,24(sp)
    29ce:	e822                	sd	s0,16(sp)
    29d0:	e426                	sd	s1,8(sp)
    29d2:	1000                	addi	s0,sp,32
    29d4:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29d6:	00004517          	auipc	a0,0x4
    29da:	a3250513          	addi	a0,a0,-1486 # 6408 <malloc+0x127a>
    29de:	330020ef          	jal	4d0e <mkdir>
    29e2:	02054f63          	bltz	a0,2a20 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    29e6:	00004517          	auipc	a0,0x4
    29ea:	a2250513          	addi	a0,a0,-1502 # 6408 <malloc+0x127a>
    29ee:	328020ef          	jal	4d16 <chdir>
    29f2:	04054163          	bltz	a0,2a34 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    29f6:	00004517          	auipc	a0,0x4
    29fa:	a5250513          	addi	a0,a0,-1454 # 6448 <malloc+0x12ba>
    29fe:	2f8020ef          	jal	4cf6 <unlink>
    2a02:	04054363          	bltz	a0,2a48 <iputtest+0x7e>
  if(chdir("/") < 0){
    2a06:	00004517          	auipc	a0,0x4
    2a0a:	a7250513          	addi	a0,a0,-1422 # 6478 <malloc+0x12ea>
    2a0e:	308020ef          	jal	4d16 <chdir>
    2a12:	04054563          	bltz	a0,2a5c <iputtest+0x92>
}
    2a16:	60e2                	ld	ra,24(sp)
    2a18:	6442                	ld	s0,16(sp)
    2a1a:	64a2                	ld	s1,8(sp)
    2a1c:	6105                	addi	sp,sp,32
    2a1e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a20:	85a6                	mv	a1,s1
    2a22:	00004517          	auipc	a0,0x4
    2a26:	9ee50513          	addi	a0,a0,-1554 # 6410 <malloc+0x1282>
    2a2a:	6b0020ef          	jal	50da <printf>
    exit(1);
    2a2e:	4505                	li	a0,1
    2a30:	276020ef          	jal	4ca6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a34:	85a6                	mv	a1,s1
    2a36:	00004517          	auipc	a0,0x4
    2a3a:	9f250513          	addi	a0,a0,-1550 # 6428 <malloc+0x129a>
    2a3e:	69c020ef          	jal	50da <printf>
    exit(1);
    2a42:	4505                	li	a0,1
    2a44:	262020ef          	jal	4ca6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a48:	85a6                	mv	a1,s1
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	a0e50513          	addi	a0,a0,-1522 # 6458 <malloc+0x12ca>
    2a52:	688020ef          	jal	50da <printf>
    exit(1);
    2a56:	4505                	li	a0,1
    2a58:	24e020ef          	jal	4ca6 <exit>
    printf("%s: chdir / failed\n", s);
    2a5c:	85a6                	mv	a1,s1
    2a5e:	00004517          	auipc	a0,0x4
    2a62:	a2250513          	addi	a0,a0,-1502 # 6480 <malloc+0x12f2>
    2a66:	674020ef          	jal	50da <printf>
    exit(1);
    2a6a:	4505                	li	a0,1
    2a6c:	23a020ef          	jal	4ca6 <exit>

0000000000002a70 <exitiputtest>:
{
    2a70:	7179                	addi	sp,sp,-48
    2a72:	f406                	sd	ra,40(sp)
    2a74:	f022                	sd	s0,32(sp)
    2a76:	ec26                	sd	s1,24(sp)
    2a78:	1800                	addi	s0,sp,48
    2a7a:	84aa                	mv	s1,a0
  pid = fork();
    2a7c:	222020ef          	jal	4c9e <fork>
  if(pid < 0){
    2a80:	02054e63          	bltz	a0,2abc <exitiputtest+0x4c>
  if(pid == 0){
    2a84:	e541                	bnez	a0,2b0c <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2a86:	00004517          	auipc	a0,0x4
    2a8a:	98250513          	addi	a0,a0,-1662 # 6408 <malloc+0x127a>
    2a8e:	280020ef          	jal	4d0e <mkdir>
    2a92:	02054f63          	bltz	a0,2ad0 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	97250513          	addi	a0,a0,-1678 # 6408 <malloc+0x127a>
    2a9e:	278020ef          	jal	4d16 <chdir>
    2aa2:	04054163          	bltz	a0,2ae4 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2aa6:	00004517          	auipc	a0,0x4
    2aaa:	9a250513          	addi	a0,a0,-1630 # 6448 <malloc+0x12ba>
    2aae:	248020ef          	jal	4cf6 <unlink>
    2ab2:	04054363          	bltz	a0,2af8 <exitiputtest+0x88>
    exit(0);
    2ab6:	4501                	li	a0,0
    2ab8:	1ee020ef          	jal	4ca6 <exit>
    printf("%s: fork failed\n", s);
    2abc:	85a6                	mv	a1,s1
    2abe:	00003517          	auipc	a0,0x3
    2ac2:	09a50513          	addi	a0,a0,154 # 5b58 <malloc+0x9ca>
    2ac6:	614020ef          	jal	50da <printf>
    exit(1);
    2aca:	4505                	li	a0,1
    2acc:	1da020ef          	jal	4ca6 <exit>
      printf("%s: mkdir failed\n", s);
    2ad0:	85a6                	mv	a1,s1
    2ad2:	00004517          	auipc	a0,0x4
    2ad6:	93e50513          	addi	a0,a0,-1730 # 6410 <malloc+0x1282>
    2ada:	600020ef          	jal	50da <printf>
      exit(1);
    2ade:	4505                	li	a0,1
    2ae0:	1c6020ef          	jal	4ca6 <exit>
      printf("%s: child chdir failed\n", s);
    2ae4:	85a6                	mv	a1,s1
    2ae6:	00004517          	auipc	a0,0x4
    2aea:	9b250513          	addi	a0,a0,-1614 # 6498 <malloc+0x130a>
    2aee:	5ec020ef          	jal	50da <printf>
      exit(1);
    2af2:	4505                	li	a0,1
    2af4:	1b2020ef          	jal	4ca6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2af8:	85a6                	mv	a1,s1
    2afa:	00004517          	auipc	a0,0x4
    2afe:	95e50513          	addi	a0,a0,-1698 # 6458 <malloc+0x12ca>
    2b02:	5d8020ef          	jal	50da <printf>
      exit(1);
    2b06:	4505                	li	a0,1
    2b08:	19e020ef          	jal	4ca6 <exit>
  wait(&xstatus);
    2b0c:	fdc40513          	addi	a0,s0,-36
    2b10:	19e020ef          	jal	4cae <wait>
  exit(xstatus);
    2b14:	fdc42503          	lw	a0,-36(s0)
    2b18:	18e020ef          	jal	4ca6 <exit>

0000000000002b1c <dirtest>:
{
    2b1c:	1101                	addi	sp,sp,-32
    2b1e:	ec06                	sd	ra,24(sp)
    2b20:	e822                	sd	s0,16(sp)
    2b22:	e426                	sd	s1,8(sp)
    2b24:	1000                	addi	s0,sp,32
    2b26:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2b28:	00004517          	auipc	a0,0x4
    2b2c:	98850513          	addi	a0,a0,-1656 # 64b0 <malloc+0x1322>
    2b30:	1de020ef          	jal	4d0e <mkdir>
    2b34:	02054f63          	bltz	a0,2b72 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	97850513          	addi	a0,a0,-1672 # 64b0 <malloc+0x1322>
    2b40:	1d6020ef          	jal	4d16 <chdir>
    2b44:	04054163          	bltz	a0,2b86 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b48:	00004517          	auipc	a0,0x4
    2b4c:	98850513          	addi	a0,a0,-1656 # 64d0 <malloc+0x1342>
    2b50:	1c6020ef          	jal	4d16 <chdir>
    2b54:	04054363          	bltz	a0,2b9a <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b58:	00004517          	auipc	a0,0x4
    2b5c:	95850513          	addi	a0,a0,-1704 # 64b0 <malloc+0x1322>
    2b60:	196020ef          	jal	4cf6 <unlink>
    2b64:	04054563          	bltz	a0,2bae <dirtest+0x92>
}
    2b68:	60e2                	ld	ra,24(sp)
    2b6a:	6442                	ld	s0,16(sp)
    2b6c:	64a2                	ld	s1,8(sp)
    2b6e:	6105                	addi	sp,sp,32
    2b70:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	89c50513          	addi	a0,a0,-1892 # 6410 <malloc+0x1282>
    2b7c:	55e020ef          	jal	50da <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	124020ef          	jal	4ca6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b86:	85a6                	mv	a1,s1
    2b88:	00004517          	auipc	a0,0x4
    2b8c:	93050513          	addi	a0,a0,-1744 # 64b8 <malloc+0x132a>
    2b90:	54a020ef          	jal	50da <printf>
    exit(1);
    2b94:	4505                	li	a0,1
    2b96:	110020ef          	jal	4ca6 <exit>
    printf("%s: chdir .. failed\n", s);
    2b9a:	85a6                	mv	a1,s1
    2b9c:	00004517          	auipc	a0,0x4
    2ba0:	93c50513          	addi	a0,a0,-1732 # 64d8 <malloc+0x134a>
    2ba4:	536020ef          	jal	50da <printf>
    exit(1);
    2ba8:	4505                	li	a0,1
    2baa:	0fc020ef          	jal	4ca6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2bae:	85a6                	mv	a1,s1
    2bb0:	00004517          	auipc	a0,0x4
    2bb4:	94050513          	addi	a0,a0,-1728 # 64f0 <malloc+0x1362>
    2bb8:	522020ef          	jal	50da <printf>
    exit(1);
    2bbc:	4505                	li	a0,1
    2bbe:	0e8020ef          	jal	4ca6 <exit>

0000000000002bc2 <subdir>:
{
    2bc2:	1101                	addi	sp,sp,-32
    2bc4:	ec06                	sd	ra,24(sp)
    2bc6:	e822                	sd	s0,16(sp)
    2bc8:	e426                	sd	s1,8(sp)
    2bca:	e04a                	sd	s2,0(sp)
    2bcc:	1000                	addi	s0,sp,32
    2bce:	892a                	mv	s2,a0
  unlink("ff");
    2bd0:	00004517          	auipc	a0,0x4
    2bd4:	a6850513          	addi	a0,a0,-1432 # 6638 <malloc+0x14aa>
    2bd8:	11e020ef          	jal	4cf6 <unlink>
  if(mkdir("dd") != 0){
    2bdc:	00004517          	auipc	a0,0x4
    2be0:	92c50513          	addi	a0,a0,-1748 # 6508 <malloc+0x137a>
    2be4:	12a020ef          	jal	4d0e <mkdir>
    2be8:	2e051263          	bnez	a0,2ecc <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bec:	20200593          	li	a1,514
    2bf0:	00004517          	auipc	a0,0x4
    2bf4:	93850513          	addi	a0,a0,-1736 # 6528 <malloc+0x139a>
    2bf8:	0ee020ef          	jal	4ce6 <open>
    2bfc:	84aa                	mv	s1,a0
  if(fd < 0){
    2bfe:	2e054163          	bltz	a0,2ee0 <subdir+0x31e>
  write(fd, "ff", 2);
    2c02:	4609                	li	a2,2
    2c04:	00004597          	auipc	a1,0x4
    2c08:	a3458593          	addi	a1,a1,-1484 # 6638 <malloc+0x14aa>
    2c0c:	0ba020ef          	jal	4cc6 <write>
  close(fd);
    2c10:	8526                	mv	a0,s1
    2c12:	0bc020ef          	jal	4cce <close>
  if(unlink("dd") >= 0){
    2c16:	00004517          	auipc	a0,0x4
    2c1a:	8f250513          	addi	a0,a0,-1806 # 6508 <malloc+0x137a>
    2c1e:	0d8020ef          	jal	4cf6 <unlink>
    2c22:	2c055963          	bgez	a0,2ef4 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	95a50513          	addi	a0,a0,-1702 # 6580 <malloc+0x13f2>
    2c2e:	0e0020ef          	jal	4d0e <mkdir>
    2c32:	2c051b63          	bnez	a0,2f08 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c36:	20200593          	li	a1,514
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	96e50513          	addi	a0,a0,-1682 # 65a8 <malloc+0x141a>
    2c42:	0a4020ef          	jal	4ce6 <open>
    2c46:	84aa                	mv	s1,a0
  if(fd < 0){
    2c48:	2c054a63          	bltz	a0,2f1c <subdir+0x35a>
  write(fd, "FF", 2);
    2c4c:	4609                	li	a2,2
    2c4e:	00004597          	auipc	a1,0x4
    2c52:	98a58593          	addi	a1,a1,-1654 # 65d8 <malloc+0x144a>
    2c56:	070020ef          	jal	4cc6 <write>
  close(fd);
    2c5a:	8526                	mv	a0,s1
    2c5c:	072020ef          	jal	4cce <close>
  fd = open("dd/dd/../ff", 0);
    2c60:	4581                	li	a1,0
    2c62:	00004517          	auipc	a0,0x4
    2c66:	97e50513          	addi	a0,a0,-1666 # 65e0 <malloc+0x1452>
    2c6a:	07c020ef          	jal	4ce6 <open>
    2c6e:	84aa                	mv	s1,a0
  if(fd < 0){
    2c70:	2c054063          	bltz	a0,2f30 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c74:	660d                	lui	a2,0x3
    2c76:	0000a597          	auipc	a1,0xa
    2c7a:	03258593          	addi	a1,a1,50 # cca8 <buf>
    2c7e:	040020ef          	jal	4cbe <read>
  if(cc != 2 || buf[0] != 'f'){
    2c82:	4789                	li	a5,2
    2c84:	2cf51063          	bne	a0,a5,2f44 <subdir+0x382>
    2c88:	0000a717          	auipc	a4,0xa
    2c8c:	02074703          	lbu	a4,32(a4) # cca8 <buf>
    2c90:	06600793          	li	a5,102
    2c94:	2af71863          	bne	a4,a5,2f44 <subdir+0x382>
  close(fd);
    2c98:	8526                	mv	a0,s1
    2c9a:	034020ef          	jal	4cce <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2c9e:	00004597          	auipc	a1,0x4
    2ca2:	99258593          	addi	a1,a1,-1646 # 6630 <malloc+0x14a2>
    2ca6:	00004517          	auipc	a0,0x4
    2caa:	90250513          	addi	a0,a0,-1790 # 65a8 <malloc+0x141a>
    2cae:	058020ef          	jal	4d06 <link>
    2cb2:	2a051363          	bnez	a0,2f58 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2cb6:	00004517          	auipc	a0,0x4
    2cba:	8f250513          	addi	a0,a0,-1806 # 65a8 <malloc+0x141a>
    2cbe:	038020ef          	jal	4cf6 <unlink>
    2cc2:	2a051563          	bnez	a0,2f6c <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2cc6:	4581                	li	a1,0
    2cc8:	00004517          	auipc	a0,0x4
    2ccc:	8e050513          	addi	a0,a0,-1824 # 65a8 <malloc+0x141a>
    2cd0:	016020ef          	jal	4ce6 <open>
    2cd4:	2a055663          	bgez	a0,2f80 <subdir+0x3be>
  if(chdir("dd") != 0){
    2cd8:	00004517          	auipc	a0,0x4
    2cdc:	83050513          	addi	a0,a0,-2000 # 6508 <malloc+0x137a>
    2ce0:	036020ef          	jal	4d16 <chdir>
    2ce4:	2a051863          	bnez	a0,2f94 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	9e050513          	addi	a0,a0,-1568 # 66c8 <malloc+0x153a>
    2cf0:	026020ef          	jal	4d16 <chdir>
    2cf4:	2a051a63          	bnez	a0,2fa8 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2cf8:	00004517          	auipc	a0,0x4
    2cfc:	a0050513          	addi	a0,a0,-1536 # 66f8 <malloc+0x156a>
    2d00:	016020ef          	jal	4d16 <chdir>
    2d04:	2a051c63          	bnez	a0,2fbc <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d08:	00004517          	auipc	a0,0x4
    2d0c:	a2850513          	addi	a0,a0,-1496 # 6730 <malloc+0x15a2>
    2d10:	006020ef          	jal	4d16 <chdir>
    2d14:	2a051e63          	bnez	a0,2fd0 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d18:	4581                	li	a1,0
    2d1a:	00004517          	auipc	a0,0x4
    2d1e:	91650513          	addi	a0,a0,-1770 # 6630 <malloc+0x14a2>
    2d22:	7c5010ef          	jal	4ce6 <open>
    2d26:	84aa                	mv	s1,a0
  if(fd < 0){
    2d28:	2a054e63          	bltz	a0,2fe4 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d2c:	660d                	lui	a2,0x3
    2d2e:	0000a597          	auipc	a1,0xa
    2d32:	f7a58593          	addi	a1,a1,-134 # cca8 <buf>
    2d36:	789010ef          	jal	4cbe <read>
    2d3a:	4789                	li	a5,2
    2d3c:	2af51e63          	bne	a0,a5,2ff8 <subdir+0x436>
  close(fd);
    2d40:	8526                	mv	a0,s1
    2d42:	78d010ef          	jal	4cce <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d46:	4581                	li	a1,0
    2d48:	00004517          	auipc	a0,0x4
    2d4c:	86050513          	addi	a0,a0,-1952 # 65a8 <malloc+0x141a>
    2d50:	797010ef          	jal	4ce6 <open>
    2d54:	2a055c63          	bgez	a0,300c <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d58:	20200593          	li	a1,514
    2d5c:	00004517          	auipc	a0,0x4
    2d60:	a6450513          	addi	a0,a0,-1436 # 67c0 <malloc+0x1632>
    2d64:	783010ef          	jal	4ce6 <open>
    2d68:	2a055c63          	bgez	a0,3020 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d6c:	20200593          	li	a1,514
    2d70:	00004517          	auipc	a0,0x4
    2d74:	a8050513          	addi	a0,a0,-1408 # 67f0 <malloc+0x1662>
    2d78:	76f010ef          	jal	4ce6 <open>
    2d7c:	2a055c63          	bgez	a0,3034 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d80:	20000593          	li	a1,512
    2d84:	00003517          	auipc	a0,0x3
    2d88:	78450513          	addi	a0,a0,1924 # 6508 <malloc+0x137a>
    2d8c:	75b010ef          	jal	4ce6 <open>
    2d90:	2a055c63          	bgez	a0,3048 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2d94:	4589                	li	a1,2
    2d96:	00003517          	auipc	a0,0x3
    2d9a:	77250513          	addi	a0,a0,1906 # 6508 <malloc+0x137a>
    2d9e:	749010ef          	jal	4ce6 <open>
    2da2:	2a055d63          	bgez	a0,305c <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2da6:	4585                	li	a1,1
    2da8:	00003517          	auipc	a0,0x3
    2dac:	76050513          	addi	a0,a0,1888 # 6508 <malloc+0x137a>
    2db0:	737010ef          	jal	4ce6 <open>
    2db4:	2a055e63          	bgez	a0,3070 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2db8:	00004597          	auipc	a1,0x4
    2dbc:	ac858593          	addi	a1,a1,-1336 # 6880 <malloc+0x16f2>
    2dc0:	00004517          	auipc	a0,0x4
    2dc4:	a0050513          	addi	a0,a0,-1536 # 67c0 <malloc+0x1632>
    2dc8:	73f010ef          	jal	4d06 <link>
    2dcc:	2a050c63          	beqz	a0,3084 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2dd0:	00004597          	auipc	a1,0x4
    2dd4:	ab058593          	addi	a1,a1,-1360 # 6880 <malloc+0x16f2>
    2dd8:	00004517          	auipc	a0,0x4
    2ddc:	a1850513          	addi	a0,a0,-1512 # 67f0 <malloc+0x1662>
    2de0:	727010ef          	jal	4d06 <link>
    2de4:	2a050a63          	beqz	a0,3098 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2de8:	00004597          	auipc	a1,0x4
    2dec:	84858593          	addi	a1,a1,-1976 # 6630 <malloc+0x14a2>
    2df0:	00003517          	auipc	a0,0x3
    2df4:	73850513          	addi	a0,a0,1848 # 6528 <malloc+0x139a>
    2df8:	70f010ef          	jal	4d06 <link>
    2dfc:	2a050863          	beqz	a0,30ac <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e00:	00004517          	auipc	a0,0x4
    2e04:	9c050513          	addi	a0,a0,-1600 # 67c0 <malloc+0x1632>
    2e08:	707010ef          	jal	4d0e <mkdir>
    2e0c:	2a050a63          	beqz	a0,30c0 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e10:	00004517          	auipc	a0,0x4
    2e14:	9e050513          	addi	a0,a0,-1568 # 67f0 <malloc+0x1662>
    2e18:	6f7010ef          	jal	4d0e <mkdir>
    2e1c:	2a050c63          	beqz	a0,30d4 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e20:	00004517          	auipc	a0,0x4
    2e24:	81050513          	addi	a0,a0,-2032 # 6630 <malloc+0x14a2>
    2e28:	6e7010ef          	jal	4d0e <mkdir>
    2e2c:	2a050e63          	beqz	a0,30e8 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e30:	00004517          	auipc	a0,0x4
    2e34:	9c050513          	addi	a0,a0,-1600 # 67f0 <malloc+0x1662>
    2e38:	6bf010ef          	jal	4cf6 <unlink>
    2e3c:	2c050063          	beqz	a0,30fc <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e40:	00004517          	auipc	a0,0x4
    2e44:	98050513          	addi	a0,a0,-1664 # 67c0 <malloc+0x1632>
    2e48:	6af010ef          	jal	4cf6 <unlink>
    2e4c:	2c050263          	beqz	a0,3110 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e50:	00003517          	auipc	a0,0x3
    2e54:	6d850513          	addi	a0,a0,1752 # 6528 <malloc+0x139a>
    2e58:	6bf010ef          	jal	4d16 <chdir>
    2e5c:	2c050463          	beqz	a0,3124 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e60:	00004517          	auipc	a0,0x4
    2e64:	b7050513          	addi	a0,a0,-1168 # 69d0 <malloc+0x1842>
    2e68:	6af010ef          	jal	4d16 <chdir>
    2e6c:	2c050663          	beqz	a0,3138 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e70:	00003517          	auipc	a0,0x3
    2e74:	7c050513          	addi	a0,a0,1984 # 6630 <malloc+0x14a2>
    2e78:	67f010ef          	jal	4cf6 <unlink>
    2e7c:	2c051863          	bnez	a0,314c <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e80:	00003517          	auipc	a0,0x3
    2e84:	6a850513          	addi	a0,a0,1704 # 6528 <malloc+0x139a>
    2e88:	66f010ef          	jal	4cf6 <unlink>
    2e8c:	2c051a63          	bnez	a0,3160 <subdir+0x59e>
  if(unlink("dd") == 0){
    2e90:	00003517          	auipc	a0,0x3
    2e94:	67850513          	addi	a0,a0,1656 # 6508 <malloc+0x137a>
    2e98:	65f010ef          	jal	4cf6 <unlink>
    2e9c:	2c050c63          	beqz	a0,3174 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2ea0:	00004517          	auipc	a0,0x4
    2ea4:	ba050513          	addi	a0,a0,-1120 # 6a40 <malloc+0x18b2>
    2ea8:	64f010ef          	jal	4cf6 <unlink>
    2eac:	2c054e63          	bltz	a0,3188 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2eb0:	00003517          	auipc	a0,0x3
    2eb4:	65850513          	addi	a0,a0,1624 # 6508 <malloc+0x137a>
    2eb8:	63f010ef          	jal	4cf6 <unlink>
    2ebc:	2e054063          	bltz	a0,319c <subdir+0x5da>
}
    2ec0:	60e2                	ld	ra,24(sp)
    2ec2:	6442                	ld	s0,16(sp)
    2ec4:	64a2                	ld	s1,8(sp)
    2ec6:	6902                	ld	s2,0(sp)
    2ec8:	6105                	addi	sp,sp,32
    2eca:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2ecc:	85ca                	mv	a1,s2
    2ece:	00003517          	auipc	a0,0x3
    2ed2:	64250513          	addi	a0,a0,1602 # 6510 <malloc+0x1382>
    2ed6:	204020ef          	jal	50da <printf>
    exit(1);
    2eda:	4505                	li	a0,1
    2edc:	5cb010ef          	jal	4ca6 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ee0:	85ca                	mv	a1,s2
    2ee2:	00003517          	auipc	a0,0x3
    2ee6:	64e50513          	addi	a0,a0,1614 # 6530 <malloc+0x13a2>
    2eea:	1f0020ef          	jal	50da <printf>
    exit(1);
    2eee:	4505                	li	a0,1
    2ef0:	5b7010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2ef4:	85ca                	mv	a1,s2
    2ef6:	00003517          	auipc	a0,0x3
    2efa:	65a50513          	addi	a0,a0,1626 # 6550 <malloc+0x13c2>
    2efe:	1dc020ef          	jal	50da <printf>
    exit(1);
    2f02:	4505                	li	a0,1
    2f04:	5a3010ef          	jal	4ca6 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f08:	85ca                	mv	a1,s2
    2f0a:	00003517          	auipc	a0,0x3
    2f0e:	67e50513          	addi	a0,a0,1662 # 6588 <malloc+0x13fa>
    2f12:	1c8020ef          	jal	50da <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	58f010ef          	jal	4ca6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f1c:	85ca                	mv	a1,s2
    2f1e:	00003517          	auipc	a0,0x3
    2f22:	69a50513          	addi	a0,a0,1690 # 65b8 <malloc+0x142a>
    2f26:	1b4020ef          	jal	50da <printf>
    exit(1);
    2f2a:	4505                	li	a0,1
    2f2c:	57b010ef          	jal	4ca6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f30:	85ca                	mv	a1,s2
    2f32:	00003517          	auipc	a0,0x3
    2f36:	6be50513          	addi	a0,a0,1726 # 65f0 <malloc+0x1462>
    2f3a:	1a0020ef          	jal	50da <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	567010ef          	jal	4ca6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f44:	85ca                	mv	a1,s2
    2f46:	00003517          	auipc	a0,0x3
    2f4a:	6ca50513          	addi	a0,a0,1738 # 6610 <malloc+0x1482>
    2f4e:	18c020ef          	jal	50da <printf>
    exit(1);
    2f52:	4505                	li	a0,1
    2f54:	553010ef          	jal	4ca6 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f58:	85ca                	mv	a1,s2
    2f5a:	00003517          	auipc	a0,0x3
    2f5e:	6e650513          	addi	a0,a0,1766 # 6640 <malloc+0x14b2>
    2f62:	178020ef          	jal	50da <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	53f010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f6c:	85ca                	mv	a1,s2
    2f6e:	00003517          	auipc	a0,0x3
    2f72:	6fa50513          	addi	a0,a0,1786 # 6668 <malloc+0x14da>
    2f76:	164020ef          	jal	50da <printf>
    exit(1);
    2f7a:	4505                	li	a0,1
    2f7c:	52b010ef          	jal	4ca6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f80:	85ca                	mv	a1,s2
    2f82:	00003517          	auipc	a0,0x3
    2f86:	70650513          	addi	a0,a0,1798 # 6688 <malloc+0x14fa>
    2f8a:	150020ef          	jal	50da <printf>
    exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	517010ef          	jal	4ca6 <exit>
    printf("%s: chdir dd failed\n", s);
    2f94:	85ca                	mv	a1,s2
    2f96:	00003517          	auipc	a0,0x3
    2f9a:	71a50513          	addi	a0,a0,1818 # 66b0 <malloc+0x1522>
    2f9e:	13c020ef          	jal	50da <printf>
    exit(1);
    2fa2:	4505                	li	a0,1
    2fa4:	503010ef          	jal	4ca6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2fa8:	85ca                	mv	a1,s2
    2faa:	00003517          	auipc	a0,0x3
    2fae:	72e50513          	addi	a0,a0,1838 # 66d8 <malloc+0x154a>
    2fb2:	128020ef          	jal	50da <printf>
    exit(1);
    2fb6:	4505                	li	a0,1
    2fb8:	4ef010ef          	jal	4ca6 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2fbc:	85ca                	mv	a1,s2
    2fbe:	00003517          	auipc	a0,0x3
    2fc2:	74a50513          	addi	a0,a0,1866 # 6708 <malloc+0x157a>
    2fc6:	114020ef          	jal	50da <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	4db010ef          	jal	4ca6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2fd0:	85ca                	mv	a1,s2
    2fd2:	00003517          	auipc	a0,0x3
    2fd6:	76650513          	addi	a0,a0,1894 # 6738 <malloc+0x15aa>
    2fda:	100020ef          	jal	50da <printf>
    exit(1);
    2fde:	4505                	li	a0,1
    2fe0:	4c7010ef          	jal	4ca6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fe4:	85ca                	mv	a1,s2
    2fe6:	00003517          	auipc	a0,0x3
    2fea:	76a50513          	addi	a0,a0,1898 # 6750 <malloc+0x15c2>
    2fee:	0ec020ef          	jal	50da <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	4b3010ef          	jal	4ca6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2ff8:	85ca                	mv	a1,s2
    2ffa:	00003517          	auipc	a0,0x3
    2ffe:	77650513          	addi	a0,a0,1910 # 6770 <malloc+0x15e2>
    3002:	0d8020ef          	jal	50da <printf>
    exit(1);
    3006:	4505                	li	a0,1
    3008:	49f010ef          	jal	4ca6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00003517          	auipc	a0,0x3
    3012:	78250513          	addi	a0,a0,1922 # 6790 <malloc+0x1602>
    3016:	0c4020ef          	jal	50da <printf>
    exit(1);
    301a:	4505                	li	a0,1
    301c:	48b010ef          	jal	4ca6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00003517          	auipc	a0,0x3
    3026:	7ae50513          	addi	a0,a0,1966 # 67d0 <malloc+0x1642>
    302a:	0b0020ef          	jal	50da <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	477010ef          	jal	4ca6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3034:	85ca                	mv	a1,s2
    3036:	00003517          	auipc	a0,0x3
    303a:	7ca50513          	addi	a0,a0,1994 # 6800 <malloc+0x1672>
    303e:	09c020ef          	jal	50da <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	463010ef          	jal	4ca6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00003517          	auipc	a0,0x3
    304e:	7d650513          	addi	a0,a0,2006 # 6820 <malloc+0x1692>
    3052:	088020ef          	jal	50da <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	44f010ef          	jal	4ca6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    305c:	85ca                	mv	a1,s2
    305e:	00003517          	auipc	a0,0x3
    3062:	7e250513          	addi	a0,a0,2018 # 6840 <malloc+0x16b2>
    3066:	074020ef          	jal	50da <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	43b010ef          	jal	4ca6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3070:	85ca                	mv	a1,s2
    3072:	00003517          	auipc	a0,0x3
    3076:	7ee50513          	addi	a0,a0,2030 # 6860 <malloc+0x16d2>
    307a:	060020ef          	jal	50da <printf>
    exit(1);
    307e:	4505                	li	a0,1
    3080:	427010ef          	jal	4ca6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3084:	85ca                	mv	a1,s2
    3086:	00004517          	auipc	a0,0x4
    308a:	80a50513          	addi	a0,a0,-2038 # 6890 <malloc+0x1702>
    308e:	04c020ef          	jal	50da <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	413010ef          	jal	4ca6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3098:	85ca                	mv	a1,s2
    309a:	00004517          	auipc	a0,0x4
    309e:	81e50513          	addi	a0,a0,-2018 # 68b8 <malloc+0x172a>
    30a2:	038020ef          	jal	50da <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	3ff010ef          	jal	4ca6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	83250513          	addi	a0,a0,-1998 # 68e0 <malloc+0x1752>
    30b6:	024020ef          	jal	50da <printf>
    exit(1);
    30ba:	4505                	li	a0,1
    30bc:	3eb010ef          	jal	4ca6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    30c0:	85ca                	mv	a1,s2
    30c2:	00004517          	auipc	a0,0x4
    30c6:	84650513          	addi	a0,a0,-1978 # 6908 <malloc+0x177a>
    30ca:	010020ef          	jal	50da <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	3d7010ef          	jal	4ca6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	85250513          	addi	a0,a0,-1966 # 6928 <malloc+0x179a>
    30de:	7fd010ef          	jal	50da <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	3c3010ef          	jal	4ca6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	85e50513          	addi	a0,a0,-1954 # 6948 <malloc+0x17ba>
    30f2:	7e9010ef          	jal	50da <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	3af010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30fc:	85ca                	mv	a1,s2
    30fe:	00004517          	auipc	a0,0x4
    3102:	87250513          	addi	a0,a0,-1934 # 6970 <malloc+0x17e2>
    3106:	7d5010ef          	jal	50da <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	39b010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3110:	85ca                	mv	a1,s2
    3112:	00004517          	auipc	a0,0x4
    3116:	87e50513          	addi	a0,a0,-1922 # 6990 <malloc+0x1802>
    311a:	7c1010ef          	jal	50da <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	387010ef          	jal	4ca6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3124:	85ca                	mv	a1,s2
    3126:	00004517          	auipc	a0,0x4
    312a:	88a50513          	addi	a0,a0,-1910 # 69b0 <malloc+0x1822>
    312e:	7ad010ef          	jal	50da <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	373010ef          	jal	4ca6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	89e50513          	addi	a0,a0,-1890 # 69d8 <malloc+0x184a>
    3142:	799010ef          	jal	50da <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	35f010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    314c:	85ca                	mv	a1,s2
    314e:	00003517          	auipc	a0,0x3
    3152:	51a50513          	addi	a0,a0,1306 # 6668 <malloc+0x14da>
    3156:	785010ef          	jal	50da <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	34b010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	89650513          	addi	a0,a0,-1898 # 69f8 <malloc+0x186a>
    316a:	771010ef          	jal	50da <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	337010ef          	jal	4ca6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3174:	85ca                	mv	a1,s2
    3176:	00004517          	auipc	a0,0x4
    317a:	8a250513          	addi	a0,a0,-1886 # 6a18 <malloc+0x188a>
    317e:	75d010ef          	jal	50da <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	323010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3188:	85ca                	mv	a1,s2
    318a:	00004517          	auipc	a0,0x4
    318e:	8be50513          	addi	a0,a0,-1858 # 6a48 <malloc+0x18ba>
    3192:	749010ef          	jal	50da <printf>
    exit(1);
    3196:	4505                	li	a0,1
    3198:	30f010ef          	jal	4ca6 <exit>
    printf("%s: unlink dd failed\n", s);
    319c:	85ca                	mv	a1,s2
    319e:	00004517          	auipc	a0,0x4
    31a2:	8ca50513          	addi	a0,a0,-1846 # 6a68 <malloc+0x18da>
    31a6:	735010ef          	jal	50da <printf>
    exit(1);
    31aa:	4505                	li	a0,1
    31ac:	2fb010ef          	jal	4ca6 <exit>

00000000000031b0 <rmdot>:
{
    31b0:	1101                	addi	sp,sp,-32
    31b2:	ec06                	sd	ra,24(sp)
    31b4:	e822                	sd	s0,16(sp)
    31b6:	e426                	sd	s1,8(sp)
    31b8:	1000                	addi	s0,sp,32
    31ba:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    31bc:	00004517          	auipc	a0,0x4
    31c0:	8c450513          	addi	a0,a0,-1852 # 6a80 <malloc+0x18f2>
    31c4:	34b010ef          	jal	4d0e <mkdir>
    31c8:	e53d                	bnez	a0,3236 <rmdot+0x86>
  if(chdir("dots") != 0){
    31ca:	00004517          	auipc	a0,0x4
    31ce:	8b650513          	addi	a0,a0,-1866 # 6a80 <malloc+0x18f2>
    31d2:	345010ef          	jal	4d16 <chdir>
    31d6:	e935                	bnez	a0,324a <rmdot+0x9a>
  if(unlink(".") == 0){
    31d8:	00002517          	auipc	a0,0x2
    31dc:	7d850513          	addi	a0,a0,2008 # 59b0 <malloc+0x822>
    31e0:	317010ef          	jal	4cf6 <unlink>
    31e4:	cd2d                	beqz	a0,325e <rmdot+0xae>
  if(unlink("..") == 0){
    31e6:	00003517          	auipc	a0,0x3
    31ea:	2ea50513          	addi	a0,a0,746 # 64d0 <malloc+0x1342>
    31ee:	309010ef          	jal	4cf6 <unlink>
    31f2:	c141                	beqz	a0,3272 <rmdot+0xc2>
  if(chdir("/") != 0){
    31f4:	00003517          	auipc	a0,0x3
    31f8:	28450513          	addi	a0,a0,644 # 6478 <malloc+0x12ea>
    31fc:	31b010ef          	jal	4d16 <chdir>
    3200:	e159                	bnez	a0,3286 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3202:	00004517          	auipc	a0,0x4
    3206:	8e650513          	addi	a0,a0,-1818 # 6ae8 <malloc+0x195a>
    320a:	2ed010ef          	jal	4cf6 <unlink>
    320e:	c551                	beqz	a0,329a <rmdot+0xea>
  if(unlink("dots/..") == 0){
    3210:	00004517          	auipc	a0,0x4
    3214:	90050513          	addi	a0,a0,-1792 # 6b10 <malloc+0x1982>
    3218:	2df010ef          	jal	4cf6 <unlink>
    321c:	c949                	beqz	a0,32ae <rmdot+0xfe>
  if(unlink("dots") != 0){
    321e:	00004517          	auipc	a0,0x4
    3222:	86250513          	addi	a0,a0,-1950 # 6a80 <malloc+0x18f2>
    3226:	2d1010ef          	jal	4cf6 <unlink>
    322a:	ed41                	bnez	a0,32c2 <rmdot+0x112>
}
    322c:	60e2                	ld	ra,24(sp)
    322e:	6442                	ld	s0,16(sp)
    3230:	64a2                	ld	s1,8(sp)
    3232:	6105                	addi	sp,sp,32
    3234:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3236:	85a6                	mv	a1,s1
    3238:	00004517          	auipc	a0,0x4
    323c:	85050513          	addi	a0,a0,-1968 # 6a88 <malloc+0x18fa>
    3240:	69b010ef          	jal	50da <printf>
    exit(1);
    3244:	4505                	li	a0,1
    3246:	261010ef          	jal	4ca6 <exit>
    printf("%s: chdir dots failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	85450513          	addi	a0,a0,-1964 # 6aa0 <malloc+0x1912>
    3254:	687010ef          	jal	50da <printf>
    exit(1);
    3258:	4505                	li	a0,1
    325a:	24d010ef          	jal	4ca6 <exit>
    printf("%s: rm . worked!\n", s);
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	85850513          	addi	a0,a0,-1960 # 6ab8 <malloc+0x192a>
    3268:	673010ef          	jal	50da <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	239010ef          	jal	4ca6 <exit>
    printf("%s: rm .. worked!\n", s);
    3272:	85a6                	mv	a1,s1
    3274:	00004517          	auipc	a0,0x4
    3278:	85c50513          	addi	a0,a0,-1956 # 6ad0 <malloc+0x1942>
    327c:	65f010ef          	jal	50da <printf>
    exit(1);
    3280:	4505                	li	a0,1
    3282:	225010ef          	jal	4ca6 <exit>
    printf("%s: chdir / failed\n", s);
    3286:	85a6                	mv	a1,s1
    3288:	00003517          	auipc	a0,0x3
    328c:	1f850513          	addi	a0,a0,504 # 6480 <malloc+0x12f2>
    3290:	64b010ef          	jal	50da <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	211010ef          	jal	4ca6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    329a:	85a6                	mv	a1,s1
    329c:	00004517          	auipc	a0,0x4
    32a0:	85450513          	addi	a0,a0,-1964 # 6af0 <malloc+0x1962>
    32a4:	637010ef          	jal	50da <printf>
    exit(1);
    32a8:	4505                	li	a0,1
    32aa:	1fd010ef          	jal	4ca6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    32ae:	85a6                	mv	a1,s1
    32b0:	00004517          	auipc	a0,0x4
    32b4:	86850513          	addi	a0,a0,-1944 # 6b18 <malloc+0x198a>
    32b8:	623010ef          	jal	50da <printf>
    exit(1);
    32bc:	4505                	li	a0,1
    32be:	1e9010ef          	jal	4ca6 <exit>
    printf("%s: unlink dots failed!\n", s);
    32c2:	85a6                	mv	a1,s1
    32c4:	00004517          	auipc	a0,0x4
    32c8:	87450513          	addi	a0,a0,-1932 # 6b38 <malloc+0x19aa>
    32cc:	60f010ef          	jal	50da <printf>
    exit(1);
    32d0:	4505                	li	a0,1
    32d2:	1d5010ef          	jal	4ca6 <exit>

00000000000032d6 <dirfile>:
{
    32d6:	1101                	addi	sp,sp,-32
    32d8:	ec06                	sd	ra,24(sp)
    32da:	e822                	sd	s0,16(sp)
    32dc:	e426                	sd	s1,8(sp)
    32de:	e04a                	sd	s2,0(sp)
    32e0:	1000                	addi	s0,sp,32
    32e2:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32e4:	20000593          	li	a1,512
    32e8:	00004517          	auipc	a0,0x4
    32ec:	87050513          	addi	a0,a0,-1936 # 6b58 <malloc+0x19ca>
    32f0:	1f7010ef          	jal	4ce6 <open>
  if(fd < 0){
    32f4:	0c054563          	bltz	a0,33be <dirfile+0xe8>
  close(fd);
    32f8:	1d7010ef          	jal	4cce <close>
  if(chdir("dirfile") == 0){
    32fc:	00004517          	auipc	a0,0x4
    3300:	85c50513          	addi	a0,a0,-1956 # 6b58 <malloc+0x19ca>
    3304:	213010ef          	jal	4d16 <chdir>
    3308:	c569                	beqz	a0,33d2 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    330a:	4581                	li	a1,0
    330c:	00004517          	auipc	a0,0x4
    3310:	89450513          	addi	a0,a0,-1900 # 6ba0 <malloc+0x1a12>
    3314:	1d3010ef          	jal	4ce6 <open>
  if(fd >= 0){
    3318:	0c055763          	bgez	a0,33e6 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    331c:	20000593          	li	a1,512
    3320:	00004517          	auipc	a0,0x4
    3324:	88050513          	addi	a0,a0,-1920 # 6ba0 <malloc+0x1a12>
    3328:	1bf010ef          	jal	4ce6 <open>
  if(fd >= 0){
    332c:	0c055763          	bgez	a0,33fa <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3330:	00004517          	auipc	a0,0x4
    3334:	87050513          	addi	a0,a0,-1936 # 6ba0 <malloc+0x1a12>
    3338:	1d7010ef          	jal	4d0e <mkdir>
    333c:	0c050963          	beqz	a0,340e <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3340:	00004517          	auipc	a0,0x4
    3344:	86050513          	addi	a0,a0,-1952 # 6ba0 <malloc+0x1a12>
    3348:	1af010ef          	jal	4cf6 <unlink>
    334c:	0c050b63          	beqz	a0,3422 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3350:	00004597          	auipc	a1,0x4
    3354:	85058593          	addi	a1,a1,-1968 # 6ba0 <malloc+0x1a12>
    3358:	00002517          	auipc	a0,0x2
    335c:	14850513          	addi	a0,a0,328 # 54a0 <malloc+0x312>
    3360:	1a7010ef          	jal	4d06 <link>
    3364:	0c050963          	beqz	a0,3436 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3368:	00003517          	auipc	a0,0x3
    336c:	7f050513          	addi	a0,a0,2032 # 6b58 <malloc+0x19ca>
    3370:	187010ef          	jal	4cf6 <unlink>
    3374:	0c051b63          	bnez	a0,344a <dirfile+0x174>
  fd = open(".", O_RDWR);
    3378:	4589                	li	a1,2
    337a:	00002517          	auipc	a0,0x2
    337e:	63650513          	addi	a0,a0,1590 # 59b0 <malloc+0x822>
    3382:	165010ef          	jal	4ce6 <open>
  if(fd >= 0){
    3386:	0c055c63          	bgez	a0,345e <dirfile+0x188>
  fd = open(".", 0);
    338a:	4581                	li	a1,0
    338c:	00002517          	auipc	a0,0x2
    3390:	62450513          	addi	a0,a0,1572 # 59b0 <malloc+0x822>
    3394:	153010ef          	jal	4ce6 <open>
    3398:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    339a:	4605                	li	a2,1
    339c:	00002597          	auipc	a1,0x2
    33a0:	f9c58593          	addi	a1,a1,-100 # 5338 <malloc+0x1aa>
    33a4:	123010ef          	jal	4cc6 <write>
    33a8:	0ca04563          	bgtz	a0,3472 <dirfile+0x19c>
  close(fd);
    33ac:	8526                	mv	a0,s1
    33ae:	121010ef          	jal	4cce <close>
}
    33b2:	60e2                	ld	ra,24(sp)
    33b4:	6442                	ld	s0,16(sp)
    33b6:	64a2                	ld	s1,8(sp)
    33b8:	6902                	ld	s2,0(sp)
    33ba:	6105                	addi	sp,sp,32
    33bc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    33be:	85ca                	mv	a1,s2
    33c0:	00003517          	auipc	a0,0x3
    33c4:	7a050513          	addi	a0,a0,1952 # 6b60 <malloc+0x19d2>
    33c8:	513010ef          	jal	50da <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	0d9010ef          	jal	4ca6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00003517          	auipc	a0,0x3
    33d8:	7ac50513          	addi	a0,a0,1964 # 6b80 <malloc+0x19f2>
    33dc:	4ff010ef          	jal	50da <printf>
    exit(1);
    33e0:	4505                	li	a0,1
    33e2:	0c5010ef          	jal	4ca6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33e6:	85ca                	mv	a1,s2
    33e8:	00003517          	auipc	a0,0x3
    33ec:	7c850513          	addi	a0,a0,1992 # 6bb0 <malloc+0x1a22>
    33f0:	4eb010ef          	jal	50da <printf>
    exit(1);
    33f4:	4505                	li	a0,1
    33f6:	0b1010ef          	jal	4ca6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33fa:	85ca                	mv	a1,s2
    33fc:	00003517          	auipc	a0,0x3
    3400:	7b450513          	addi	a0,a0,1972 # 6bb0 <malloc+0x1a22>
    3404:	4d7010ef          	jal	50da <printf>
    exit(1);
    3408:	4505                	li	a0,1
    340a:	09d010ef          	jal	4ca6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    340e:	85ca                	mv	a1,s2
    3410:	00003517          	auipc	a0,0x3
    3414:	7c850513          	addi	a0,a0,1992 # 6bd8 <malloc+0x1a4a>
    3418:	4c3010ef          	jal	50da <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	089010ef          	jal	4ca6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3422:	85ca                	mv	a1,s2
    3424:	00003517          	auipc	a0,0x3
    3428:	7dc50513          	addi	a0,a0,2012 # 6c00 <malloc+0x1a72>
    342c:	4af010ef          	jal	50da <printf>
    exit(1);
    3430:	4505                	li	a0,1
    3432:	075010ef          	jal	4ca6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3436:	85ca                	mv	a1,s2
    3438:	00003517          	auipc	a0,0x3
    343c:	7f050513          	addi	a0,a0,2032 # 6c28 <malloc+0x1a9a>
    3440:	49b010ef          	jal	50da <printf>
    exit(1);
    3444:	4505                	li	a0,1
    3446:	061010ef          	jal	4ca6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    344a:	85ca                	mv	a1,s2
    344c:	00004517          	auipc	a0,0x4
    3450:	80450513          	addi	a0,a0,-2044 # 6c50 <malloc+0x1ac2>
    3454:	487010ef          	jal	50da <printf>
    exit(1);
    3458:	4505                	li	a0,1
    345a:	04d010ef          	jal	4ca6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    345e:	85ca                	mv	a1,s2
    3460:	00004517          	auipc	a0,0x4
    3464:	81050513          	addi	a0,a0,-2032 # 6c70 <malloc+0x1ae2>
    3468:	473010ef          	jal	50da <printf>
    exit(1);
    346c:	4505                	li	a0,1
    346e:	039010ef          	jal	4ca6 <exit>
    printf("%s: write . succeeded!\n", s);
    3472:	85ca                	mv	a1,s2
    3474:	00004517          	auipc	a0,0x4
    3478:	82450513          	addi	a0,a0,-2012 # 6c98 <malloc+0x1b0a>
    347c:	45f010ef          	jal	50da <printf>
    exit(1);
    3480:	4505                	li	a0,1
    3482:	025010ef          	jal	4ca6 <exit>

0000000000003486 <iref>:
{
    3486:	7139                	addi	sp,sp,-64
    3488:	fc06                	sd	ra,56(sp)
    348a:	f822                	sd	s0,48(sp)
    348c:	f426                	sd	s1,40(sp)
    348e:	f04a                	sd	s2,32(sp)
    3490:	ec4e                	sd	s3,24(sp)
    3492:	e852                	sd	s4,16(sp)
    3494:	e456                	sd	s5,8(sp)
    3496:	e05a                	sd	s6,0(sp)
    3498:	0080                	addi	s0,sp,64
    349a:	8b2a                	mv	s6,a0
    349c:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    34a0:	00004a17          	auipc	s4,0x4
    34a4:	810a0a13          	addi	s4,s4,-2032 # 6cb0 <malloc+0x1b22>
    mkdir("");
    34a8:	00003497          	auipc	s1,0x3
    34ac:	31048493          	addi	s1,s1,784 # 67b8 <malloc+0x162a>
    link("README", "");
    34b0:	00002a97          	auipc	s5,0x2
    34b4:	ff0a8a93          	addi	s5,s5,-16 # 54a0 <malloc+0x312>
    fd = open("xx", O_CREATE);
    34b8:	00003997          	auipc	s3,0x3
    34bc:	6f098993          	addi	s3,s3,1776 # 6ba8 <malloc+0x1a1a>
    34c0:	a835                	j	34fc <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    34c2:	85da                	mv	a1,s6
    34c4:	00003517          	auipc	a0,0x3
    34c8:	7f450513          	addi	a0,a0,2036 # 6cb8 <malloc+0x1b2a>
    34cc:	40f010ef          	jal	50da <printf>
      exit(1);
    34d0:	4505                	li	a0,1
    34d2:	7d4010ef          	jal	4ca6 <exit>
      printf("%s: chdir irefd failed\n", s);
    34d6:	85da                	mv	a1,s6
    34d8:	00003517          	auipc	a0,0x3
    34dc:	7f850513          	addi	a0,a0,2040 # 6cd0 <malloc+0x1b42>
    34e0:	3fb010ef          	jal	50da <printf>
      exit(1);
    34e4:	4505                	li	a0,1
    34e6:	7c0010ef          	jal	4ca6 <exit>
      close(fd);
    34ea:	7e4010ef          	jal	4cce <close>
    34ee:	a82d                	j	3528 <iref+0xa2>
    unlink("xx");
    34f0:	854e                	mv	a0,s3
    34f2:	005010ef          	jal	4cf6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    34f6:	397d                	addiw	s2,s2,-1
    34f8:	04090263          	beqz	s2,353c <iref+0xb6>
    if(mkdir("irefd") != 0){
    34fc:	8552                	mv	a0,s4
    34fe:	011010ef          	jal	4d0e <mkdir>
    3502:	f161                	bnez	a0,34c2 <iref+0x3c>
    if(chdir("irefd") != 0){
    3504:	8552                	mv	a0,s4
    3506:	011010ef          	jal	4d16 <chdir>
    350a:	f571                	bnez	a0,34d6 <iref+0x50>
    mkdir("");
    350c:	8526                	mv	a0,s1
    350e:	001010ef          	jal	4d0e <mkdir>
    link("README", "");
    3512:	85a6                	mv	a1,s1
    3514:	8556                	mv	a0,s5
    3516:	7f0010ef          	jal	4d06 <link>
    fd = open("", O_CREATE);
    351a:	20000593          	li	a1,512
    351e:	8526                	mv	a0,s1
    3520:	7c6010ef          	jal	4ce6 <open>
    if(fd >= 0)
    3524:	fc0553e3          	bgez	a0,34ea <iref+0x64>
    fd = open("xx", O_CREATE);
    3528:	20000593          	li	a1,512
    352c:	854e                	mv	a0,s3
    352e:	7b8010ef          	jal	4ce6 <open>
    if(fd >= 0)
    3532:	fa054fe3          	bltz	a0,34f0 <iref+0x6a>
      close(fd);
    3536:	798010ef          	jal	4cce <close>
    353a:	bf5d                	j	34f0 <iref+0x6a>
    353c:	03300493          	li	s1,51
    chdir("..");
    3540:	00003997          	auipc	s3,0x3
    3544:	f9098993          	addi	s3,s3,-112 # 64d0 <malloc+0x1342>
    unlink("irefd");
    3548:	00003917          	auipc	s2,0x3
    354c:	76890913          	addi	s2,s2,1896 # 6cb0 <malloc+0x1b22>
    chdir("..");
    3550:	854e                	mv	a0,s3
    3552:	7c4010ef          	jal	4d16 <chdir>
    unlink("irefd");
    3556:	854a                	mv	a0,s2
    3558:	79e010ef          	jal	4cf6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    355c:	34fd                	addiw	s1,s1,-1
    355e:	f8ed                	bnez	s1,3550 <iref+0xca>
  chdir("/");
    3560:	00003517          	auipc	a0,0x3
    3564:	f1850513          	addi	a0,a0,-232 # 6478 <malloc+0x12ea>
    3568:	7ae010ef          	jal	4d16 <chdir>
}
    356c:	70e2                	ld	ra,56(sp)
    356e:	7442                	ld	s0,48(sp)
    3570:	74a2                	ld	s1,40(sp)
    3572:	7902                	ld	s2,32(sp)
    3574:	69e2                	ld	s3,24(sp)
    3576:	6a42                	ld	s4,16(sp)
    3578:	6aa2                	ld	s5,8(sp)
    357a:	6b02                	ld	s6,0(sp)
    357c:	6121                	addi	sp,sp,64
    357e:	8082                	ret

0000000000003580 <openiputtest>:
{
    3580:	7179                	addi	sp,sp,-48
    3582:	f406                	sd	ra,40(sp)
    3584:	f022                	sd	s0,32(sp)
    3586:	ec26                	sd	s1,24(sp)
    3588:	1800                	addi	s0,sp,48
    358a:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    358c:	00003517          	auipc	a0,0x3
    3590:	75c50513          	addi	a0,a0,1884 # 6ce8 <malloc+0x1b5a>
    3594:	77a010ef          	jal	4d0e <mkdir>
    3598:	02054a63          	bltz	a0,35cc <openiputtest+0x4c>
  pid = fork();
    359c:	702010ef          	jal	4c9e <fork>
  if(pid < 0){
    35a0:	04054063          	bltz	a0,35e0 <openiputtest+0x60>
  if(pid == 0){
    35a4:	e939                	bnez	a0,35fa <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    35a6:	4589                	li	a1,2
    35a8:	00003517          	auipc	a0,0x3
    35ac:	74050513          	addi	a0,a0,1856 # 6ce8 <malloc+0x1b5a>
    35b0:	736010ef          	jal	4ce6 <open>
    if(fd >= 0){
    35b4:	04054063          	bltz	a0,35f4 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    35b8:	85a6                	mv	a1,s1
    35ba:	00003517          	auipc	a0,0x3
    35be:	74e50513          	addi	a0,a0,1870 # 6d08 <malloc+0x1b7a>
    35c2:	319010ef          	jal	50da <printf>
      exit(1);
    35c6:	4505                	li	a0,1
    35c8:	6de010ef          	jal	4ca6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    35cc:	85a6                	mv	a1,s1
    35ce:	00003517          	auipc	a0,0x3
    35d2:	72250513          	addi	a0,a0,1826 # 6cf0 <malloc+0x1b62>
    35d6:	305010ef          	jal	50da <printf>
    exit(1);
    35da:	4505                	li	a0,1
    35dc:	6ca010ef          	jal	4ca6 <exit>
    printf("%s: fork failed\n", s);
    35e0:	85a6                	mv	a1,s1
    35e2:	00002517          	auipc	a0,0x2
    35e6:	57650513          	addi	a0,a0,1398 # 5b58 <malloc+0x9ca>
    35ea:	2f1010ef          	jal	50da <printf>
    exit(1);
    35ee:	4505                	li	a0,1
    35f0:	6b6010ef          	jal	4ca6 <exit>
    exit(0);
    35f4:	4501                	li	a0,0
    35f6:	6b0010ef          	jal	4ca6 <exit>
  pause(1);
    35fa:	4505                	li	a0,1
    35fc:	73a010ef          	jal	4d36 <pause>
  if(unlink("oidir") != 0){
    3600:	00003517          	auipc	a0,0x3
    3604:	6e850513          	addi	a0,a0,1768 # 6ce8 <malloc+0x1b5a>
    3608:	6ee010ef          	jal	4cf6 <unlink>
    360c:	c919                	beqz	a0,3622 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    360e:	85a6                	mv	a1,s1
    3610:	00002517          	auipc	a0,0x2
    3614:	73850513          	addi	a0,a0,1848 # 5d48 <malloc+0xbba>
    3618:	2c3010ef          	jal	50da <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	688010ef          	jal	4ca6 <exit>
  wait(&xstatus);
    3622:	fdc40513          	addi	a0,s0,-36
    3626:	688010ef          	jal	4cae <wait>
  exit(xstatus);
    362a:	fdc42503          	lw	a0,-36(s0)
    362e:	678010ef          	jal	4ca6 <exit>

0000000000003632 <forkforkfork>:
{
    3632:	1101                	addi	sp,sp,-32
    3634:	ec06                	sd	ra,24(sp)
    3636:	e822                	sd	s0,16(sp)
    3638:	e426                	sd	s1,8(sp)
    363a:	1000                	addi	s0,sp,32
    363c:	84aa                	mv	s1,a0
  unlink("stopforking");
    363e:	00003517          	auipc	a0,0x3
    3642:	6f250513          	addi	a0,a0,1778 # 6d30 <malloc+0x1ba2>
    3646:	6b0010ef          	jal	4cf6 <unlink>
  int pid = fork();
    364a:	654010ef          	jal	4c9e <fork>
  if(pid < 0){
    364e:	02054b63          	bltz	a0,3684 <forkforkfork+0x52>
  if(pid == 0){
    3652:	c139                	beqz	a0,3698 <forkforkfork+0x66>
  pause(20); // two seconds
    3654:	4551                	li	a0,20
    3656:	6e0010ef          	jal	4d36 <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    365a:	20200593          	li	a1,514
    365e:	00003517          	auipc	a0,0x3
    3662:	6d250513          	addi	a0,a0,1746 # 6d30 <malloc+0x1ba2>
    3666:	680010ef          	jal	4ce6 <open>
    366a:	664010ef          	jal	4cce <close>
  wait(0);
    366e:	4501                	li	a0,0
    3670:	63e010ef          	jal	4cae <wait>
  pause(10); // one second
    3674:	4529                	li	a0,10
    3676:	6c0010ef          	jal	4d36 <pause>
}
    367a:	60e2                	ld	ra,24(sp)
    367c:	6442                	ld	s0,16(sp)
    367e:	64a2                	ld	s1,8(sp)
    3680:	6105                	addi	sp,sp,32
    3682:	8082                	ret
    printf("%s: fork failed", s);
    3684:	85a6                	mv	a1,s1
    3686:	00002517          	auipc	a0,0x2
    368a:	69250513          	addi	a0,a0,1682 # 5d18 <malloc+0xb8a>
    368e:	24d010ef          	jal	50da <printf>
    exit(1);
    3692:	4505                	li	a0,1
    3694:	612010ef          	jal	4ca6 <exit>
      int fd = open("stopforking", 0);
    3698:	00003497          	auipc	s1,0x3
    369c:	69848493          	addi	s1,s1,1688 # 6d30 <malloc+0x1ba2>
    36a0:	4581                	li	a1,0
    36a2:	8526                	mv	a0,s1
    36a4:	642010ef          	jal	4ce6 <open>
      if(fd >= 0){
    36a8:	02055163          	bgez	a0,36ca <forkforkfork+0x98>
      if(fork() < 0){
    36ac:	5f2010ef          	jal	4c9e <fork>
    36b0:	fe0558e3          	bgez	a0,36a0 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    36b4:	20200593          	li	a1,514
    36b8:	00003517          	auipc	a0,0x3
    36bc:	67850513          	addi	a0,a0,1656 # 6d30 <malloc+0x1ba2>
    36c0:	626010ef          	jal	4ce6 <open>
    36c4:	60a010ef          	jal	4cce <close>
    36c8:	bfe1                	j	36a0 <forkforkfork+0x6e>
        exit(0);
    36ca:	4501                	li	a0,0
    36cc:	5da010ef          	jal	4ca6 <exit>

00000000000036d0 <killstatus>:
{
    36d0:	7139                	addi	sp,sp,-64
    36d2:	fc06                	sd	ra,56(sp)
    36d4:	f822                	sd	s0,48(sp)
    36d6:	f426                	sd	s1,40(sp)
    36d8:	f04a                	sd	s2,32(sp)
    36da:	ec4e                	sd	s3,24(sp)
    36dc:	e852                	sd	s4,16(sp)
    36de:	0080                	addi	s0,sp,64
    36e0:	8a2a                	mv	s4,a0
    36e2:	06400913          	li	s2,100
    if(xst != -1) {
    36e6:	59fd                	li	s3,-1
    int pid1 = fork();
    36e8:	5b6010ef          	jal	4c9e <fork>
    36ec:	84aa                	mv	s1,a0
    if(pid1 < 0){
    36ee:	02054763          	bltz	a0,371c <killstatus+0x4c>
    if(pid1 == 0){
    36f2:	cd1d                	beqz	a0,3730 <killstatus+0x60>
    pause(1);
    36f4:	4505                	li	a0,1
    36f6:	640010ef          	jal	4d36 <pause>
    kill(pid1);
    36fa:	8526                	mv	a0,s1
    36fc:	5da010ef          	jal	4cd6 <kill>
    wait(&xst);
    3700:	fcc40513          	addi	a0,s0,-52
    3704:	5aa010ef          	jal	4cae <wait>
    if(xst != -1) {
    3708:	fcc42783          	lw	a5,-52(s0)
    370c:	03379563          	bne	a5,s3,3736 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    3710:	397d                	addiw	s2,s2,-1
    3712:	fc091be3          	bnez	s2,36e8 <killstatus+0x18>
  exit(0);
    3716:	4501                	li	a0,0
    3718:	58e010ef          	jal	4ca6 <exit>
      printf("%s: fork failed\n", s);
    371c:	85d2                	mv	a1,s4
    371e:	00002517          	auipc	a0,0x2
    3722:	43a50513          	addi	a0,a0,1082 # 5b58 <malloc+0x9ca>
    3726:	1b5010ef          	jal	50da <printf>
      exit(1);
    372a:	4505                	li	a0,1
    372c:	57a010ef          	jal	4ca6 <exit>
        getpid();
    3730:	5f6010ef          	jal	4d26 <getpid>
      while(1) {
    3734:	bff5                	j	3730 <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    3736:	85d2                	mv	a1,s4
    3738:	00003517          	auipc	a0,0x3
    373c:	60850513          	addi	a0,a0,1544 # 6d40 <malloc+0x1bb2>
    3740:	19b010ef          	jal	50da <printf>
       exit(1);
    3744:	4505                	li	a0,1
    3746:	560010ef          	jal	4ca6 <exit>

000000000000374a <preempt>:
{
    374a:	7139                	addi	sp,sp,-64
    374c:	fc06                	sd	ra,56(sp)
    374e:	f822                	sd	s0,48(sp)
    3750:	f426                	sd	s1,40(sp)
    3752:	f04a                	sd	s2,32(sp)
    3754:	ec4e                	sd	s3,24(sp)
    3756:	e852                	sd	s4,16(sp)
    3758:	0080                	addi	s0,sp,64
    375a:	892a                	mv	s2,a0
  pid1 = fork();
    375c:	542010ef          	jal	4c9e <fork>
  if(pid1 < 0) {
    3760:	00054563          	bltz	a0,376a <preempt+0x20>
    3764:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3766:	ed01                	bnez	a0,377e <preempt+0x34>
    for(;;)
    3768:	a001                	j	3768 <preempt+0x1e>
    printf("%s: fork failed", s);
    376a:	85ca                	mv	a1,s2
    376c:	00002517          	auipc	a0,0x2
    3770:	5ac50513          	addi	a0,a0,1452 # 5d18 <malloc+0xb8a>
    3774:	167010ef          	jal	50da <printf>
    exit(1);
    3778:	4505                	li	a0,1
    377a:	52c010ef          	jal	4ca6 <exit>
  pid2 = fork();
    377e:	520010ef          	jal	4c9e <fork>
    3782:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    3784:	00054463          	bltz	a0,378c <preempt+0x42>
  if(pid2 == 0)
    3788:	ed01                	bnez	a0,37a0 <preempt+0x56>
    for(;;)
    378a:	a001                	j	378a <preempt+0x40>
    printf("%s: fork failed\n", s);
    378c:	85ca                	mv	a1,s2
    378e:	00002517          	auipc	a0,0x2
    3792:	3ca50513          	addi	a0,a0,970 # 5b58 <malloc+0x9ca>
    3796:	145010ef          	jal	50da <printf>
    exit(1);
    379a:	4505                	li	a0,1
    379c:	50a010ef          	jal	4ca6 <exit>
  pipe(pfds);
    37a0:	fc840513          	addi	a0,s0,-56
    37a4:	512010ef          	jal	4cb6 <pipe>
  pid3 = fork();
    37a8:	4f6010ef          	jal	4c9e <fork>
    37ac:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    37ae:	02054863          	bltz	a0,37de <preempt+0x94>
  if(pid3 == 0){
    37b2:	e921                	bnez	a0,3802 <preempt+0xb8>
    close(pfds[0]);
    37b4:	fc842503          	lw	a0,-56(s0)
    37b8:	516010ef          	jal	4cce <close>
    if(write(pfds[1], "x", 1) != 1)
    37bc:	4605                	li	a2,1
    37be:	00002597          	auipc	a1,0x2
    37c2:	b7a58593          	addi	a1,a1,-1158 # 5338 <malloc+0x1aa>
    37c6:	fcc42503          	lw	a0,-52(s0)
    37ca:	4fc010ef          	jal	4cc6 <write>
    37ce:	4785                	li	a5,1
    37d0:	02f51163          	bne	a0,a5,37f2 <preempt+0xa8>
    close(pfds[1]);
    37d4:	fcc42503          	lw	a0,-52(s0)
    37d8:	4f6010ef          	jal	4cce <close>
    for(;;)
    37dc:	a001                	j	37dc <preempt+0x92>
     printf("%s: fork failed\n", s);
    37de:	85ca                	mv	a1,s2
    37e0:	00002517          	auipc	a0,0x2
    37e4:	37850513          	addi	a0,a0,888 # 5b58 <malloc+0x9ca>
    37e8:	0f3010ef          	jal	50da <printf>
     exit(1);
    37ec:	4505                	li	a0,1
    37ee:	4b8010ef          	jal	4ca6 <exit>
      printf("%s: preempt write error", s);
    37f2:	85ca                	mv	a1,s2
    37f4:	00003517          	auipc	a0,0x3
    37f8:	56c50513          	addi	a0,a0,1388 # 6d60 <malloc+0x1bd2>
    37fc:	0df010ef          	jal	50da <printf>
    3800:	bfd1                	j	37d4 <preempt+0x8a>
  close(pfds[1]);
    3802:	fcc42503          	lw	a0,-52(s0)
    3806:	4c8010ef          	jal	4cce <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    380a:	660d                	lui	a2,0x3
    380c:	00009597          	auipc	a1,0x9
    3810:	49c58593          	addi	a1,a1,1180 # cca8 <buf>
    3814:	fc842503          	lw	a0,-56(s0)
    3818:	4a6010ef          	jal	4cbe <read>
    381c:	4785                	li	a5,1
    381e:	02f50163          	beq	a0,a5,3840 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3822:	85ca                	mv	a1,s2
    3824:	00003517          	auipc	a0,0x3
    3828:	55450513          	addi	a0,a0,1364 # 6d78 <malloc+0x1bea>
    382c:	0af010ef          	jal	50da <printf>
}
    3830:	70e2                	ld	ra,56(sp)
    3832:	7442                	ld	s0,48(sp)
    3834:	74a2                	ld	s1,40(sp)
    3836:	7902                	ld	s2,32(sp)
    3838:	69e2                	ld	s3,24(sp)
    383a:	6a42                	ld	s4,16(sp)
    383c:	6121                	addi	sp,sp,64
    383e:	8082                	ret
  close(pfds[0]);
    3840:	fc842503          	lw	a0,-56(s0)
    3844:	48a010ef          	jal	4cce <close>
  printf("kill... ");
    3848:	00003517          	auipc	a0,0x3
    384c:	54850513          	addi	a0,a0,1352 # 6d90 <malloc+0x1c02>
    3850:	08b010ef          	jal	50da <printf>
  kill(pid1);
    3854:	8526                	mv	a0,s1
    3856:	480010ef          	jal	4cd6 <kill>
  kill(pid2);
    385a:	854e                	mv	a0,s3
    385c:	47a010ef          	jal	4cd6 <kill>
  kill(pid3);
    3860:	8552                	mv	a0,s4
    3862:	474010ef          	jal	4cd6 <kill>
  printf("wait... ");
    3866:	00003517          	auipc	a0,0x3
    386a:	53a50513          	addi	a0,a0,1338 # 6da0 <malloc+0x1c12>
    386e:	06d010ef          	jal	50da <printf>
  wait(0);
    3872:	4501                	li	a0,0
    3874:	43a010ef          	jal	4cae <wait>
  wait(0);
    3878:	4501                	li	a0,0
    387a:	434010ef          	jal	4cae <wait>
  wait(0);
    387e:	4501                	li	a0,0
    3880:	42e010ef          	jal	4cae <wait>
    3884:	b775                	j	3830 <preempt+0xe6>

0000000000003886 <reparent>:
{
    3886:	7179                	addi	sp,sp,-48
    3888:	f406                	sd	ra,40(sp)
    388a:	f022                	sd	s0,32(sp)
    388c:	ec26                	sd	s1,24(sp)
    388e:	e84a                	sd	s2,16(sp)
    3890:	e44e                	sd	s3,8(sp)
    3892:	e052                	sd	s4,0(sp)
    3894:	1800                	addi	s0,sp,48
    3896:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3898:	48e010ef          	jal	4d26 <getpid>
    389c:	8a2a                	mv	s4,a0
    389e:	0c800913          	li	s2,200
    int pid = fork();
    38a2:	3fc010ef          	jal	4c9e <fork>
    38a6:	84aa                	mv	s1,a0
    if(pid < 0){
    38a8:	00054e63          	bltz	a0,38c4 <reparent+0x3e>
    if(pid){
    38ac:	c121                	beqz	a0,38ec <reparent+0x66>
      if(wait(0) != pid){
    38ae:	4501                	li	a0,0
    38b0:	3fe010ef          	jal	4cae <wait>
    38b4:	02951263          	bne	a0,s1,38d8 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    38b8:	397d                	addiw	s2,s2,-1
    38ba:	fe0914e3          	bnez	s2,38a2 <reparent+0x1c>
  exit(0);
    38be:	4501                	li	a0,0
    38c0:	3e6010ef          	jal	4ca6 <exit>
      printf("%s: fork failed\n", s);
    38c4:	85ce                	mv	a1,s3
    38c6:	00002517          	auipc	a0,0x2
    38ca:	29250513          	addi	a0,a0,658 # 5b58 <malloc+0x9ca>
    38ce:	00d010ef          	jal	50da <printf>
      exit(1);
    38d2:	4505                	li	a0,1
    38d4:	3d2010ef          	jal	4ca6 <exit>
        printf("%s: wait wrong pid\n", s);
    38d8:	85ce                	mv	a1,s3
    38da:	00002517          	auipc	a0,0x2
    38de:	40650513          	addi	a0,a0,1030 # 5ce0 <malloc+0xb52>
    38e2:	7f8010ef          	jal	50da <printf>
        exit(1);
    38e6:	4505                	li	a0,1
    38e8:	3be010ef          	jal	4ca6 <exit>
      int pid2 = fork();
    38ec:	3b2010ef          	jal	4c9e <fork>
      if(pid2 < 0){
    38f0:	00054563          	bltz	a0,38fa <reparent+0x74>
      exit(0);
    38f4:	4501                	li	a0,0
    38f6:	3b0010ef          	jal	4ca6 <exit>
        kill(master_pid);
    38fa:	8552                	mv	a0,s4
    38fc:	3da010ef          	jal	4cd6 <kill>
        exit(1);
    3900:	4505                	li	a0,1
    3902:	3a4010ef          	jal	4ca6 <exit>

0000000000003906 <sbrkfail>:
{
    3906:	7175                	addi	sp,sp,-144
    3908:	e506                	sd	ra,136(sp)
    390a:	e122                	sd	s0,128(sp)
    390c:	fca6                	sd	s1,120(sp)
    390e:	f8ca                	sd	s2,112(sp)
    3910:	f4ce                	sd	s3,104(sp)
    3912:	f0d2                	sd	s4,96(sp)
    3914:	ecd6                	sd	s5,88(sp)
    3916:	e8da                	sd	s6,80(sp)
    3918:	e4de                	sd	s7,72(sp)
    391a:	0900                	addi	s0,sp,144
    391c:	8b2a                	mv	s6,a0
  if(pipe(fds) != 0){
    391e:	fa040513          	addi	a0,s0,-96
    3922:	394010ef          	jal	4cb6 <pipe>
    3926:	e919                	bnez	a0,393c <sbrkfail+0x36>
    3928:	8aaa                	mv	s5,a0
    392a:	f7040493          	addi	s1,s0,-144
    392e:	f9840993          	addi	s3,s0,-104
    3932:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    3934:	5a7d                	li	s4,-1
      if(scratch == '0')
    3936:	03000b93          	li	s7,48
    393a:	a08d                	j	399c <sbrkfail+0x96>
    printf("%s: pipe() failed\n", s);
    393c:	85da                	mv	a1,s6
    393e:	00002517          	auipc	a0,0x2
    3942:	32250513          	addi	a0,a0,802 # 5c60 <malloc+0xad2>
    3946:	794010ef          	jal	50da <printf>
    exit(1);
    394a:	4505                	li	a0,1
    394c:	35a010ef          	jal	4ca6 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3950:	302010ef          	jal	4c52 <sbrk>
    3954:	064007b7          	lui	a5,0x6400
    3958:	40a7853b          	subw	a0,a5,a0
    395c:	2f6010ef          	jal	4c52 <sbrk>
    3960:	57fd                	li	a5,-1
    3962:	02f50063          	beq	a0,a5,3982 <sbrkfail+0x7c>
        write(fds[1], "1", 1);
    3966:	4605                	li	a2,1
    3968:	00004597          	auipc	a1,0x4
    396c:	ad858593          	addi	a1,a1,-1320 # 7440 <malloc+0x22b2>
    3970:	fa442503          	lw	a0,-92(s0)
    3974:	352010ef          	jal	4cc6 <write>
      for(;;) pause(1000);
    3978:	3e800513          	li	a0,1000
    397c:	3ba010ef          	jal	4d36 <pause>
    3980:	bfe5                	j	3978 <sbrkfail+0x72>
        write(fds[1], "0", 1);
    3982:	4605                	li	a2,1
    3984:	00003597          	auipc	a1,0x3
    3988:	42c58593          	addi	a1,a1,1068 # 6db0 <malloc+0x1c22>
    398c:	fa442503          	lw	a0,-92(s0)
    3990:	336010ef          	jal	4cc6 <write>
    3994:	b7d5                	j	3978 <sbrkfail+0x72>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3996:	0911                	addi	s2,s2,4
    3998:	03390663          	beq	s2,s3,39c4 <sbrkfail+0xbe>
    if((pids[i] = fork()) == 0){
    399c:	302010ef          	jal	4c9e <fork>
    39a0:	00a92023          	sw	a0,0(s2)
    39a4:	d555                	beqz	a0,3950 <sbrkfail+0x4a>
    if(pids[i] != -1) {
    39a6:	ff4508e3          	beq	a0,s4,3996 <sbrkfail+0x90>
      read(fds[0], &scratch, 1);
    39aa:	4605                	li	a2,1
    39ac:	f9f40593          	addi	a1,s0,-97
    39b0:	fa042503          	lw	a0,-96(s0)
    39b4:	30a010ef          	jal	4cbe <read>
      if(scratch == '0')
    39b8:	f9f44783          	lbu	a5,-97(s0)
    39bc:	fd779de3          	bne	a5,s7,3996 <sbrkfail+0x90>
        failed = 1;
    39c0:	4a85                	li	s5,1
    39c2:	bfd1                	j	3996 <sbrkfail+0x90>
  if(!failed) {
    39c4:	000a8863          	beqz	s5,39d4 <sbrkfail+0xce>
  c = sbrk(PGSIZE);
    39c8:	6505                	lui	a0,0x1
    39ca:	288010ef          	jal	4c52 <sbrk>
    39ce:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    39d0:	597d                	li	s2,-1
    39d2:	a821                	j	39ea <sbrkfail+0xe4>
    printf("%s: no allocation failed; allocate more?\n", s);
    39d4:	85da                	mv	a1,s6
    39d6:	00003517          	auipc	a0,0x3
    39da:	3e250513          	addi	a0,a0,994 # 6db8 <malloc+0x1c2a>
    39de:	6fc010ef          	jal	50da <printf>
    39e2:	b7dd                	j	39c8 <sbrkfail+0xc2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    39e4:	0491                	addi	s1,s1,4
    39e6:	01348b63          	beq	s1,s3,39fc <sbrkfail+0xf6>
    if(pids[i] == -1)
    39ea:	4088                	lw	a0,0(s1)
    39ec:	ff250ce3          	beq	a0,s2,39e4 <sbrkfail+0xde>
    kill(pids[i]);
    39f0:	2e6010ef          	jal	4cd6 <kill>
    wait(0);
    39f4:	4501                	li	a0,0
    39f6:	2b8010ef          	jal	4cae <wait>
    39fa:	b7ed                	j	39e4 <sbrkfail+0xde>
  if(c == (char*)SBRK_ERROR){
    39fc:	57fd                	li	a5,-1
    39fe:	02fa0a63          	beq	s4,a5,3a32 <sbrkfail+0x12c>
  pid = fork();
    3a02:	29c010ef          	jal	4c9e <fork>
  if(pid < 0){
    3a06:	04054063          	bltz	a0,3a46 <sbrkfail+0x140>
  if(pid == 0){
    3a0a:	e939                	bnez	a0,3a60 <sbrkfail+0x15a>
    a = sbrk(10*BIG);
    3a0c:	3e800537          	lui	a0,0x3e800
    3a10:	242010ef          	jal	4c52 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3a14:	57fd                	li	a5,-1
    3a16:	04f50263          	beq	a0,a5,3a5a <sbrkfail+0x154>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3a1a:	3e800637          	lui	a2,0x3e800
    3a1e:	85da                	mv	a1,s6
    3a20:	00003517          	auipc	a0,0x3
    3a24:	3e850513          	addi	a0,a0,1000 # 6e08 <malloc+0x1c7a>
    3a28:	6b2010ef          	jal	50da <printf>
    exit(1);
    3a2c:	4505                	li	a0,1
    3a2e:	278010ef          	jal	4ca6 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3a32:	85da                	mv	a1,s6
    3a34:	00003517          	auipc	a0,0x3
    3a38:	3b450513          	addi	a0,a0,948 # 6de8 <malloc+0x1c5a>
    3a3c:	69e010ef          	jal	50da <printf>
    exit(1);
    3a40:	4505                	li	a0,1
    3a42:	264010ef          	jal	4ca6 <exit>
    printf("%s: fork failed\n", s);
    3a46:	85da                	mv	a1,s6
    3a48:	00002517          	auipc	a0,0x2
    3a4c:	11050513          	addi	a0,a0,272 # 5b58 <malloc+0x9ca>
    3a50:	68a010ef          	jal	50da <printf>
    exit(1);
    3a54:	4505                	li	a0,1
    3a56:	250010ef          	jal	4ca6 <exit>
      exit(0);
    3a5a:	4501                	li	a0,0
    3a5c:	24a010ef          	jal	4ca6 <exit>
  wait(&xstatus);
    3a60:	fac40513          	addi	a0,s0,-84
    3a64:	24a010ef          	jal	4cae <wait>
  if(xstatus != 0)
    3a68:	fac42783          	lw	a5,-84(s0)
    3a6c:	ef81                	bnez	a5,3a84 <sbrkfail+0x17e>
}
    3a6e:	60aa                	ld	ra,136(sp)
    3a70:	640a                	ld	s0,128(sp)
    3a72:	74e6                	ld	s1,120(sp)
    3a74:	7946                	ld	s2,112(sp)
    3a76:	79a6                	ld	s3,104(sp)
    3a78:	7a06                	ld	s4,96(sp)
    3a7a:	6ae6                	ld	s5,88(sp)
    3a7c:	6b46                	ld	s6,80(sp)
    3a7e:	6ba6                	ld	s7,72(sp)
    3a80:	6149                	addi	sp,sp,144
    3a82:	8082                	ret
    exit(1);
    3a84:	4505                	li	a0,1
    3a86:	220010ef          	jal	4ca6 <exit>

0000000000003a8a <mem>:
{
    3a8a:	7139                	addi	sp,sp,-64
    3a8c:	fc06                	sd	ra,56(sp)
    3a8e:	f822                	sd	s0,48(sp)
    3a90:	f426                	sd	s1,40(sp)
    3a92:	f04a                	sd	s2,32(sp)
    3a94:	ec4e                	sd	s3,24(sp)
    3a96:	0080                	addi	s0,sp,64
    3a98:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a9a:	204010ef          	jal	4c9e <fork>
    m1 = 0;
    3a9e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3aa0:	6909                	lui	s2,0x2
    3aa2:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x97>
  if((pid = fork()) == 0){
    3aa6:	cd11                	beqz	a0,3ac2 <mem+0x38>
    wait(&xstatus);
    3aa8:	fcc40513          	addi	a0,s0,-52
    3aac:	202010ef          	jal	4cae <wait>
    if(xstatus == -1){
    3ab0:	fcc42503          	lw	a0,-52(s0)
    3ab4:	57fd                	li	a5,-1
    3ab6:	04f50363          	beq	a0,a5,3afc <mem+0x72>
    exit(xstatus);
    3aba:	1ec010ef          	jal	4ca6 <exit>
      *(char**)m2 = m1;
    3abe:	e104                	sd	s1,0(a0)
      m1 = m2;
    3ac0:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3ac2:	854a                	mv	a0,s2
    3ac4:	6ca010ef          	jal	518e <malloc>
    3ac8:	f97d                	bnez	a0,3abe <mem+0x34>
    while(m1){
    3aca:	c491                	beqz	s1,3ad6 <mem+0x4c>
      m2 = *(char**)m1;
    3acc:	8526                	mv	a0,s1
    3ace:	6084                	ld	s1,0(s1)
      free(m1);
    3ad0:	63c010ef          	jal	510c <free>
    while(m1){
    3ad4:	fce5                	bnez	s1,3acc <mem+0x42>
    m1 = malloc(1024*20);
    3ad6:	6515                	lui	a0,0x5
    3ad8:	6b6010ef          	jal	518e <malloc>
    if(m1 == 0){
    3adc:	c511                	beqz	a0,3ae8 <mem+0x5e>
    free(m1);
    3ade:	62e010ef          	jal	510c <free>
    exit(0);
    3ae2:	4501                	li	a0,0
    3ae4:	1c2010ef          	jal	4ca6 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3ae8:	85ce                	mv	a1,s3
    3aea:	00003517          	auipc	a0,0x3
    3aee:	34e50513          	addi	a0,a0,846 # 6e38 <malloc+0x1caa>
    3af2:	5e8010ef          	jal	50da <printf>
      exit(1);
    3af6:	4505                	li	a0,1
    3af8:	1ae010ef          	jal	4ca6 <exit>
      exit(0);
    3afc:	4501                	li	a0,0
    3afe:	1a8010ef          	jal	4ca6 <exit>

0000000000003b02 <sharedfd>:
{
    3b02:	7159                	addi	sp,sp,-112
    3b04:	f486                	sd	ra,104(sp)
    3b06:	f0a2                	sd	s0,96(sp)
    3b08:	e0d2                	sd	s4,64(sp)
    3b0a:	1880                	addi	s0,sp,112
    3b0c:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3b0e:	00003517          	auipc	a0,0x3
    3b12:	34a50513          	addi	a0,a0,842 # 6e58 <malloc+0x1cca>
    3b16:	1e0010ef          	jal	4cf6 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3b1a:	20200593          	li	a1,514
    3b1e:	00003517          	auipc	a0,0x3
    3b22:	33a50513          	addi	a0,a0,826 # 6e58 <malloc+0x1cca>
    3b26:	1c0010ef          	jal	4ce6 <open>
  if(fd < 0){
    3b2a:	04054863          	bltz	a0,3b7a <sharedfd+0x78>
    3b2e:	eca6                	sd	s1,88(sp)
    3b30:	e8ca                	sd	s2,80(sp)
    3b32:	e4ce                	sd	s3,72(sp)
    3b34:	fc56                	sd	s5,56(sp)
    3b36:	f85a                	sd	s6,48(sp)
    3b38:	f45e                	sd	s7,40(sp)
    3b3a:	892a                	mv	s2,a0
  pid = fork();
    3b3c:	162010ef          	jal	4c9e <fork>
    3b40:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3b42:	07000593          	li	a1,112
    3b46:	e119                	bnez	a0,3b4c <sharedfd+0x4a>
    3b48:	06300593          	li	a1,99
    3b4c:	4629                	li	a2,10
    3b4e:	fa040513          	addi	a0,s0,-96
    3b52:	723000ef          	jal	4a74 <memset>
    3b56:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b5a:	4629                	li	a2,10
    3b5c:	fa040593          	addi	a1,s0,-96
    3b60:	854a                	mv	a0,s2
    3b62:	164010ef          	jal	4cc6 <write>
    3b66:	47a9                	li	a5,10
    3b68:	02f51963          	bne	a0,a5,3b9a <sharedfd+0x98>
  for(i = 0; i < N; i++){
    3b6c:	34fd                	addiw	s1,s1,-1
    3b6e:	f4f5                	bnez	s1,3b5a <sharedfd+0x58>
  if(pid == 0) {
    3b70:	02099f63          	bnez	s3,3bae <sharedfd+0xac>
    exit(0);
    3b74:	4501                	li	a0,0
    3b76:	130010ef          	jal	4ca6 <exit>
    3b7a:	eca6                	sd	s1,88(sp)
    3b7c:	e8ca                	sd	s2,80(sp)
    3b7e:	e4ce                	sd	s3,72(sp)
    3b80:	fc56                	sd	s5,56(sp)
    3b82:	f85a                	sd	s6,48(sp)
    3b84:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3b86:	85d2                	mv	a1,s4
    3b88:	00003517          	auipc	a0,0x3
    3b8c:	2e050513          	addi	a0,a0,736 # 6e68 <malloc+0x1cda>
    3b90:	54a010ef          	jal	50da <printf>
    exit(1);
    3b94:	4505                	li	a0,1
    3b96:	110010ef          	jal	4ca6 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b9a:	85d2                	mv	a1,s4
    3b9c:	00003517          	auipc	a0,0x3
    3ba0:	2f450513          	addi	a0,a0,756 # 6e90 <malloc+0x1d02>
    3ba4:	536010ef          	jal	50da <printf>
      exit(1);
    3ba8:	4505                	li	a0,1
    3baa:	0fc010ef          	jal	4ca6 <exit>
    wait(&xstatus);
    3bae:	f9c40513          	addi	a0,s0,-100
    3bb2:	0fc010ef          	jal	4cae <wait>
    if(xstatus != 0)
    3bb6:	f9c42983          	lw	s3,-100(s0)
    3bba:	00098563          	beqz	s3,3bc4 <sharedfd+0xc2>
      exit(xstatus);
    3bbe:	854e                	mv	a0,s3
    3bc0:	0e6010ef          	jal	4ca6 <exit>
  close(fd);
    3bc4:	854a                	mv	a0,s2
    3bc6:	108010ef          	jal	4cce <close>
  fd = open("sharedfd", 0);
    3bca:	4581                	li	a1,0
    3bcc:	00003517          	auipc	a0,0x3
    3bd0:	28c50513          	addi	a0,a0,652 # 6e58 <malloc+0x1cca>
    3bd4:	112010ef          	jal	4ce6 <open>
    3bd8:	8baa                	mv	s7,a0
  nc = np = 0;
    3bda:	8ace                	mv	s5,s3
  if(fd < 0){
    3bdc:	02054363          	bltz	a0,3c02 <sharedfd+0x100>
    3be0:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3be4:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3be8:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3bec:	4629                	li	a2,10
    3bee:	fa040593          	addi	a1,s0,-96
    3bf2:	855e                	mv	a0,s7
    3bf4:	0ca010ef          	jal	4cbe <read>
    3bf8:	02a05b63          	blez	a0,3c2e <sharedfd+0x12c>
    3bfc:	fa040793          	addi	a5,s0,-96
    3c00:	a839                	j	3c1e <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    3c02:	85d2                	mv	a1,s4
    3c04:	00003517          	auipc	a0,0x3
    3c08:	2ac50513          	addi	a0,a0,684 # 6eb0 <malloc+0x1d22>
    3c0c:	4ce010ef          	jal	50da <printf>
    exit(1);
    3c10:	4505                	li	a0,1
    3c12:	094010ef          	jal	4ca6 <exit>
        nc++;
    3c16:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3c18:	0785                	addi	a5,a5,1 # 6400001 <base+0x63f0359>
    3c1a:	fd2789e3          	beq	a5,s2,3bec <sharedfd+0xea>
      if(buf[i] == 'c')
    3c1e:	0007c703          	lbu	a4,0(a5)
    3c22:	fe970ae3          	beq	a4,s1,3c16 <sharedfd+0x114>
      if(buf[i] == 'p')
    3c26:	ff6719e3          	bne	a4,s6,3c18 <sharedfd+0x116>
        np++;
    3c2a:	2a85                	addiw	s5,s5,1
    3c2c:	b7f5                	j	3c18 <sharedfd+0x116>
  close(fd);
    3c2e:	855e                	mv	a0,s7
    3c30:	09e010ef          	jal	4cce <close>
  unlink("sharedfd");
    3c34:	00003517          	auipc	a0,0x3
    3c38:	22450513          	addi	a0,a0,548 # 6e58 <malloc+0x1cca>
    3c3c:	0ba010ef          	jal	4cf6 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3c40:	6789                	lui	a5,0x2
    3c42:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x96>
    3c46:	00f99763          	bne	s3,a5,3c54 <sharedfd+0x152>
    3c4a:	6789                	lui	a5,0x2
    3c4c:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x96>
    3c50:	00fa8c63          	beq	s5,a5,3c68 <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    3c54:	85d2                	mv	a1,s4
    3c56:	00003517          	auipc	a0,0x3
    3c5a:	28250513          	addi	a0,a0,642 # 6ed8 <malloc+0x1d4a>
    3c5e:	47c010ef          	jal	50da <printf>
    exit(1);
    3c62:	4505                	li	a0,1
    3c64:	042010ef          	jal	4ca6 <exit>
    exit(0);
    3c68:	4501                	li	a0,0
    3c6a:	03c010ef          	jal	4ca6 <exit>

0000000000003c6e <fourfiles>:
{
    3c6e:	7135                	addi	sp,sp,-160
    3c70:	ed06                	sd	ra,152(sp)
    3c72:	e922                	sd	s0,144(sp)
    3c74:	e526                	sd	s1,136(sp)
    3c76:	e14a                	sd	s2,128(sp)
    3c78:	fcce                	sd	s3,120(sp)
    3c7a:	f8d2                	sd	s4,112(sp)
    3c7c:	f4d6                	sd	s5,104(sp)
    3c7e:	f0da                	sd	s6,96(sp)
    3c80:	ecde                	sd	s7,88(sp)
    3c82:	e8e2                	sd	s8,80(sp)
    3c84:	e4e6                	sd	s9,72(sp)
    3c86:	e0ea                	sd	s10,64(sp)
    3c88:	fc6e                	sd	s11,56(sp)
    3c8a:	1100                	addi	s0,sp,160
    3c8c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c8e:	00003797          	auipc	a5,0x3
    3c92:	26278793          	addi	a5,a5,610 # 6ef0 <malloc+0x1d62>
    3c96:	f6f43823          	sd	a5,-144(s0)
    3c9a:	00003797          	auipc	a5,0x3
    3c9e:	25e78793          	addi	a5,a5,606 # 6ef8 <malloc+0x1d6a>
    3ca2:	f6f43c23          	sd	a5,-136(s0)
    3ca6:	00003797          	auipc	a5,0x3
    3caa:	25a78793          	addi	a5,a5,602 # 6f00 <malloc+0x1d72>
    3cae:	f8f43023          	sd	a5,-128(s0)
    3cb2:	00003797          	auipc	a5,0x3
    3cb6:	25678793          	addi	a5,a5,598 # 6f08 <malloc+0x1d7a>
    3cba:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3cbe:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3cc2:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3cc4:	4481                	li	s1,0
    3cc6:	4a11                	li	s4,4
    fname = names[pi];
    3cc8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3ccc:	854e                	mv	a0,s3
    3cce:	028010ef          	jal	4cf6 <unlink>
    pid = fork();
    3cd2:	7cd000ef          	jal	4c9e <fork>
    if(pid < 0){
    3cd6:	02054e63          	bltz	a0,3d12 <fourfiles+0xa4>
    if(pid == 0){
    3cda:	c531                	beqz	a0,3d26 <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3cdc:	2485                	addiw	s1,s1,1
    3cde:	0921                	addi	s2,s2,8
    3ce0:	ff4494e3          	bne	s1,s4,3cc8 <fourfiles+0x5a>
    3ce4:	4491                	li	s1,4
    wait(&xstatus);
    3ce6:	f6c40513          	addi	a0,s0,-148
    3cea:	7c5000ef          	jal	4cae <wait>
    if(xstatus != 0)
    3cee:	f6c42a83          	lw	s5,-148(s0)
    3cf2:	0a0a9463          	bnez	s5,3d9a <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3cf6:	34fd                	addiw	s1,s1,-1
    3cf8:	f4fd                	bnez	s1,3ce6 <fourfiles+0x78>
    3cfa:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3cfe:	00009a17          	auipc	s4,0x9
    3d02:	faaa0a13          	addi	s4,s4,-86 # cca8 <buf>
    if(total != N*SZ){
    3d06:	6d05                	lui	s10,0x1
    3d08:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x1e>
  for(i = 0; i < NCHILD; i++){
    3d0c:	03400d93          	li	s11,52
    3d10:	a0ed                	j	3dfa <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3d12:	85e6                	mv	a1,s9
    3d14:	00002517          	auipc	a0,0x2
    3d18:	e4450513          	addi	a0,a0,-444 # 5b58 <malloc+0x9ca>
    3d1c:	3be010ef          	jal	50da <printf>
      exit(1);
    3d20:	4505                	li	a0,1
    3d22:	785000ef          	jal	4ca6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d26:	20200593          	li	a1,514
    3d2a:	854e                	mv	a0,s3
    3d2c:	7bb000ef          	jal	4ce6 <open>
    3d30:	892a                	mv	s2,a0
      if(fd < 0){
    3d32:	04054163          	bltz	a0,3d74 <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3d36:	1f400613          	li	a2,500
    3d3a:	0304859b          	addiw	a1,s1,48
    3d3e:	00009517          	auipc	a0,0x9
    3d42:	f6a50513          	addi	a0,a0,-150 # cca8 <buf>
    3d46:	52f000ef          	jal	4a74 <memset>
    3d4a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d4c:	00009997          	auipc	s3,0x9
    3d50:	f5c98993          	addi	s3,s3,-164 # cca8 <buf>
    3d54:	1f400613          	li	a2,500
    3d58:	85ce                	mv	a1,s3
    3d5a:	854a                	mv	a0,s2
    3d5c:	76b000ef          	jal	4cc6 <write>
    3d60:	85aa                	mv	a1,a0
    3d62:	1f400793          	li	a5,500
    3d66:	02f51163          	bne	a0,a5,3d88 <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d6a:	34fd                	addiw	s1,s1,-1
    3d6c:	f4e5                	bnez	s1,3d54 <fourfiles+0xe6>
      exit(0);
    3d6e:	4501                	li	a0,0
    3d70:	737000ef          	jal	4ca6 <exit>
        printf("%s: create failed\n", s);
    3d74:	85e6                	mv	a1,s9
    3d76:	00002517          	auipc	a0,0x2
    3d7a:	e7a50513          	addi	a0,a0,-390 # 5bf0 <malloc+0xa62>
    3d7e:	35c010ef          	jal	50da <printf>
        exit(1);
    3d82:	4505                	li	a0,1
    3d84:	723000ef          	jal	4ca6 <exit>
          printf("write failed %d\n", n);
    3d88:	00003517          	auipc	a0,0x3
    3d8c:	18850513          	addi	a0,a0,392 # 6f10 <malloc+0x1d82>
    3d90:	34a010ef          	jal	50da <printf>
          exit(1);
    3d94:	4505                	li	a0,1
    3d96:	711000ef          	jal	4ca6 <exit>
      exit(xstatus);
    3d9a:	8556                	mv	a0,s5
    3d9c:	70b000ef          	jal	4ca6 <exit>
          printf("%s: wrong char\n", s);
    3da0:	85e6                	mv	a1,s9
    3da2:	00003517          	auipc	a0,0x3
    3da6:	18650513          	addi	a0,a0,390 # 6f28 <malloc+0x1d9a>
    3daa:	330010ef          	jal	50da <printf>
          exit(1);
    3dae:	4505                	li	a0,1
    3db0:	6f7000ef          	jal	4ca6 <exit>
      total += n;
    3db4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3db8:	660d                	lui	a2,0x3
    3dba:	85d2                	mv	a1,s4
    3dbc:	854e                	mv	a0,s3
    3dbe:	701000ef          	jal	4cbe <read>
    3dc2:	02a05063          	blez	a0,3de2 <fourfiles+0x174>
    3dc6:	00009797          	auipc	a5,0x9
    3dca:	ee278793          	addi	a5,a5,-286 # cca8 <buf>
    3dce:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3dd2:	0007c703          	lbu	a4,0(a5)
    3dd6:	fc9715e3          	bne	a4,s1,3da0 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3dda:	0785                	addi	a5,a5,1
    3ddc:	fed79be3          	bne	a5,a3,3dd2 <fourfiles+0x164>
    3de0:	bfd1                	j	3db4 <fourfiles+0x146>
    close(fd);
    3de2:	854e                	mv	a0,s3
    3de4:	6eb000ef          	jal	4cce <close>
    if(total != N*SZ){
    3de8:	03a91463          	bne	s2,s10,3e10 <fourfiles+0x1a2>
    unlink(fname);
    3dec:	8562                	mv	a0,s8
    3dee:	709000ef          	jal	4cf6 <unlink>
  for(i = 0; i < NCHILD; i++){
    3df2:	0ba1                	addi	s7,s7,8
    3df4:	2b05                	addiw	s6,s6,1
    3df6:	03bb0763          	beq	s6,s11,3e24 <fourfiles+0x1b6>
    fname = names[i];
    3dfa:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3dfe:	4581                	li	a1,0
    3e00:	8562                	mv	a0,s8
    3e02:	6e5000ef          	jal	4ce6 <open>
    3e06:	89aa                	mv	s3,a0
    total = 0;
    3e08:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3e0a:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e0e:	b76d                	j	3db8 <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3e10:	85ca                	mv	a1,s2
    3e12:	00003517          	auipc	a0,0x3
    3e16:	12650513          	addi	a0,a0,294 # 6f38 <malloc+0x1daa>
    3e1a:	2c0010ef          	jal	50da <printf>
      exit(1);
    3e1e:	4505                	li	a0,1
    3e20:	687000ef          	jal	4ca6 <exit>
}
    3e24:	60ea                	ld	ra,152(sp)
    3e26:	644a                	ld	s0,144(sp)
    3e28:	64aa                	ld	s1,136(sp)
    3e2a:	690a                	ld	s2,128(sp)
    3e2c:	79e6                	ld	s3,120(sp)
    3e2e:	7a46                	ld	s4,112(sp)
    3e30:	7aa6                	ld	s5,104(sp)
    3e32:	7b06                	ld	s6,96(sp)
    3e34:	6be6                	ld	s7,88(sp)
    3e36:	6c46                	ld	s8,80(sp)
    3e38:	6ca6                	ld	s9,72(sp)
    3e3a:	6d06                	ld	s10,64(sp)
    3e3c:	7de2                	ld	s11,56(sp)
    3e3e:	610d                	addi	sp,sp,160
    3e40:	8082                	ret

0000000000003e42 <concreate>:
{
    3e42:	7135                	addi	sp,sp,-160
    3e44:	ed06                	sd	ra,152(sp)
    3e46:	e922                	sd	s0,144(sp)
    3e48:	e526                	sd	s1,136(sp)
    3e4a:	e14a                	sd	s2,128(sp)
    3e4c:	fcce                	sd	s3,120(sp)
    3e4e:	f8d2                	sd	s4,112(sp)
    3e50:	f4d6                	sd	s5,104(sp)
    3e52:	f0da                	sd	s6,96(sp)
    3e54:	ecde                	sd	s7,88(sp)
    3e56:	1100                	addi	s0,sp,160
    3e58:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e5a:	04300793          	li	a5,67
    3e5e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e62:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e66:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e68:	4b0d                	li	s6,3
    3e6a:	4a85                	li	s5,1
      link("C0", file);
    3e6c:	00003b97          	auipc	s7,0x3
    3e70:	0e4b8b93          	addi	s7,s7,228 # 6f50 <malloc+0x1dc2>
  for(i = 0; i < N; i++){
    3e74:	02800a13          	li	s4,40
    3e78:	a41d                	j	409e <concreate+0x25c>
      link("C0", file);
    3e7a:	fa840593          	addi	a1,s0,-88
    3e7e:	855e                	mv	a0,s7
    3e80:	687000ef          	jal	4d06 <link>
    if(pid == 0) {
    3e84:	a411                	j	4088 <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e86:	4795                	li	a5,5
    3e88:	02f9693b          	remw	s2,s2,a5
    3e8c:	4785                	li	a5,1
    3e8e:	02f90563          	beq	s2,a5,3eb8 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e92:	20200593          	li	a1,514
    3e96:	fa840513          	addi	a0,s0,-88
    3e9a:	64d000ef          	jal	4ce6 <open>
      if(fd < 0){
    3e9e:	1e055063          	bgez	a0,407e <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3ea2:	fa840593          	addi	a1,s0,-88
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	0b250513          	addi	a0,a0,178 # 6f58 <malloc+0x1dca>
    3eae:	22c010ef          	jal	50da <printf>
        exit(1);
    3eb2:	4505                	li	a0,1
    3eb4:	5f3000ef          	jal	4ca6 <exit>
      link("C0", file);
    3eb8:	fa840593          	addi	a1,s0,-88
    3ebc:	00003517          	auipc	a0,0x3
    3ec0:	09450513          	addi	a0,a0,148 # 6f50 <malloc+0x1dc2>
    3ec4:	643000ef          	jal	4d06 <link>
      exit(0);
    3ec8:	4501                	li	a0,0
    3eca:	5dd000ef          	jal	4ca6 <exit>
        exit(1);
    3ece:	4505                	li	a0,1
    3ed0:	5d7000ef          	jal	4ca6 <exit>
  memset(fa, 0, sizeof(fa));
    3ed4:	02800613          	li	a2,40
    3ed8:	4581                	li	a1,0
    3eda:	f8040513          	addi	a0,s0,-128
    3ede:	397000ef          	jal	4a74 <memset>
  fd = open(".", 0);
    3ee2:	4581                	li	a1,0
    3ee4:	00002517          	auipc	a0,0x2
    3ee8:	acc50513          	addi	a0,a0,-1332 # 59b0 <malloc+0x822>
    3eec:	5fb000ef          	jal	4ce6 <open>
    3ef0:	892a                	mv	s2,a0
  n = 0;
    3ef2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3ef4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3ef8:	02700b13          	li	s6,39
      fa[i] = 1;
    3efc:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3efe:	4641                	li	a2,16
    3f00:	f7040593          	addi	a1,s0,-144
    3f04:	854a                	mv	a0,s2
    3f06:	5b9000ef          	jal	4cbe <read>
    3f0a:	06a05a63          	blez	a0,3f7e <concreate+0x13c>
    if(de.inum == 0)
    3f0e:	f7045783          	lhu	a5,-144(s0)
    3f12:	d7f5                	beqz	a5,3efe <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f14:	f7244783          	lbu	a5,-142(s0)
    3f18:	ff4793e3          	bne	a5,s4,3efe <concreate+0xbc>
    3f1c:	f7444783          	lbu	a5,-140(s0)
    3f20:	fff9                	bnez	a5,3efe <concreate+0xbc>
      i = de.name[1] - '0';
    3f22:	f7344783          	lbu	a5,-141(s0)
    3f26:	fd07879b          	addiw	a5,a5,-48
    3f2a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f2e:	02eb6063          	bltu	s6,a4,3f4e <concreate+0x10c>
      if(fa[i]){
    3f32:	fb070793          	addi	a5,a4,-80
    3f36:	97a2                	add	a5,a5,s0
    3f38:	fd07c783          	lbu	a5,-48(a5)
    3f3c:	e78d                	bnez	a5,3f66 <concreate+0x124>
      fa[i] = 1;
    3f3e:	fb070793          	addi	a5,a4,-80
    3f42:	00878733          	add	a4,a5,s0
    3f46:	fd770823          	sb	s7,-48(a4)
      n++;
    3f4a:	2a85                	addiw	s5,s5,1
    3f4c:	bf4d                	j	3efe <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f4e:	f7240613          	addi	a2,s0,-142
    3f52:	85ce                	mv	a1,s3
    3f54:	00003517          	auipc	a0,0x3
    3f58:	02450513          	addi	a0,a0,36 # 6f78 <malloc+0x1dea>
    3f5c:	17e010ef          	jal	50da <printf>
        exit(1);
    3f60:	4505                	li	a0,1
    3f62:	545000ef          	jal	4ca6 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f66:	f7240613          	addi	a2,s0,-142
    3f6a:	85ce                	mv	a1,s3
    3f6c:	00003517          	auipc	a0,0x3
    3f70:	02c50513          	addi	a0,a0,44 # 6f98 <malloc+0x1e0a>
    3f74:	166010ef          	jal	50da <printf>
        exit(1);
    3f78:	4505                	li	a0,1
    3f7a:	52d000ef          	jal	4ca6 <exit>
  close(fd);
    3f7e:	854a                	mv	a0,s2
    3f80:	54f000ef          	jal	4cce <close>
  if(n != N){
    3f84:	02800793          	li	a5,40
    3f88:	00fa9763          	bne	s5,a5,3f96 <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f8c:	4a8d                	li	s5,3
    3f8e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f90:	02800a13          	li	s4,40
    3f94:	a079                	j	4022 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f96:	85ce                	mv	a1,s3
    3f98:	00003517          	auipc	a0,0x3
    3f9c:	02850513          	addi	a0,a0,40 # 6fc0 <malloc+0x1e32>
    3fa0:	13a010ef          	jal	50da <printf>
    exit(1);
    3fa4:	4505                	li	a0,1
    3fa6:	501000ef          	jal	4ca6 <exit>
      printf("%s: fork failed\n", s);
    3faa:	85ce                	mv	a1,s3
    3fac:	00002517          	auipc	a0,0x2
    3fb0:	bac50513          	addi	a0,a0,-1108 # 5b58 <malloc+0x9ca>
    3fb4:	126010ef          	jal	50da <printf>
      exit(1);
    3fb8:	4505                	li	a0,1
    3fba:	4ed000ef          	jal	4ca6 <exit>
      close(open(file, 0));
    3fbe:	4581                	li	a1,0
    3fc0:	fa840513          	addi	a0,s0,-88
    3fc4:	523000ef          	jal	4ce6 <open>
    3fc8:	507000ef          	jal	4cce <close>
      close(open(file, 0));
    3fcc:	4581                	li	a1,0
    3fce:	fa840513          	addi	a0,s0,-88
    3fd2:	515000ef          	jal	4ce6 <open>
    3fd6:	4f9000ef          	jal	4cce <close>
      close(open(file, 0));
    3fda:	4581                	li	a1,0
    3fdc:	fa840513          	addi	a0,s0,-88
    3fe0:	507000ef          	jal	4ce6 <open>
    3fe4:	4eb000ef          	jal	4cce <close>
      close(open(file, 0));
    3fe8:	4581                	li	a1,0
    3fea:	fa840513          	addi	a0,s0,-88
    3fee:	4f9000ef          	jal	4ce6 <open>
    3ff2:	4dd000ef          	jal	4cce <close>
      close(open(file, 0));
    3ff6:	4581                	li	a1,0
    3ff8:	fa840513          	addi	a0,s0,-88
    3ffc:	4eb000ef          	jal	4ce6 <open>
    4000:	4cf000ef          	jal	4cce <close>
      close(open(file, 0));
    4004:	4581                	li	a1,0
    4006:	fa840513          	addi	a0,s0,-88
    400a:	4dd000ef          	jal	4ce6 <open>
    400e:	4c1000ef          	jal	4cce <close>
    if(pid == 0)
    4012:	06090363          	beqz	s2,4078 <concreate+0x236>
      wait(0);
    4016:	4501                	li	a0,0
    4018:	497000ef          	jal	4cae <wait>
  for(i = 0; i < N; i++){
    401c:	2485                	addiw	s1,s1,1
    401e:	0b448963          	beq	s1,s4,40d0 <concreate+0x28e>
    file[1] = '0' + i;
    4022:	0304879b          	addiw	a5,s1,48
    4026:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    402a:	475000ef          	jal	4c9e <fork>
    402e:	892a                	mv	s2,a0
    if(pid < 0){
    4030:	f6054de3          	bltz	a0,3faa <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    4034:	0354e73b          	remw	a4,s1,s5
    4038:	00a767b3          	or	a5,a4,a0
    403c:	2781                	sext.w	a5,a5
    403e:	d3c1                	beqz	a5,3fbe <concreate+0x17c>
    4040:	01671363          	bne	a4,s6,4046 <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    4044:	fd2d                	bnez	a0,3fbe <concreate+0x17c>
      unlink(file);
    4046:	fa840513          	addi	a0,s0,-88
    404a:	4ad000ef          	jal	4cf6 <unlink>
      unlink(file);
    404e:	fa840513          	addi	a0,s0,-88
    4052:	4a5000ef          	jal	4cf6 <unlink>
      unlink(file);
    4056:	fa840513          	addi	a0,s0,-88
    405a:	49d000ef          	jal	4cf6 <unlink>
      unlink(file);
    405e:	fa840513          	addi	a0,s0,-88
    4062:	495000ef          	jal	4cf6 <unlink>
      unlink(file);
    4066:	fa840513          	addi	a0,s0,-88
    406a:	48d000ef          	jal	4cf6 <unlink>
      unlink(file);
    406e:	fa840513          	addi	a0,s0,-88
    4072:	485000ef          	jal	4cf6 <unlink>
    4076:	bf71                	j	4012 <concreate+0x1d0>
      exit(0);
    4078:	4501                	li	a0,0
    407a:	42d000ef          	jal	4ca6 <exit>
      close(fd);
    407e:	451000ef          	jal	4cce <close>
    if(pid == 0) {
    4082:	b599                	j	3ec8 <concreate+0x86>
      close(fd);
    4084:	44b000ef          	jal	4cce <close>
      wait(&xstatus);
    4088:	f6c40513          	addi	a0,s0,-148
    408c:	423000ef          	jal	4cae <wait>
      if(xstatus != 0)
    4090:	f6c42483          	lw	s1,-148(s0)
    4094:	e2049de3          	bnez	s1,3ece <concreate+0x8c>
  for(i = 0; i < N; i++){
    4098:	2905                	addiw	s2,s2,1
    409a:	e3490de3          	beq	s2,s4,3ed4 <concreate+0x92>
    file[1] = '0' + i;
    409e:	0309079b          	addiw	a5,s2,48
    40a2:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    40a6:	fa840513          	addi	a0,s0,-88
    40aa:	44d000ef          	jal	4cf6 <unlink>
    pid = fork();
    40ae:	3f1000ef          	jal	4c9e <fork>
    if(pid && (i % 3) == 1){
    40b2:	dc050ae3          	beqz	a0,3e86 <concreate+0x44>
    40b6:	036967bb          	remw	a5,s2,s6
    40ba:	dd5780e3          	beq	a5,s5,3e7a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    40be:	20200593          	li	a1,514
    40c2:	fa840513          	addi	a0,s0,-88
    40c6:	421000ef          	jal	4ce6 <open>
      if(fd < 0){
    40ca:	fa055de3          	bgez	a0,4084 <concreate+0x242>
    40ce:	bbd1                	j	3ea2 <concreate+0x60>
}
    40d0:	60ea                	ld	ra,152(sp)
    40d2:	644a                	ld	s0,144(sp)
    40d4:	64aa                	ld	s1,136(sp)
    40d6:	690a                	ld	s2,128(sp)
    40d8:	79e6                	ld	s3,120(sp)
    40da:	7a46                	ld	s4,112(sp)
    40dc:	7aa6                	ld	s5,104(sp)
    40de:	7b06                	ld	s6,96(sp)
    40e0:	6be6                	ld	s7,88(sp)
    40e2:	610d                	addi	sp,sp,160
    40e4:	8082                	ret

00000000000040e6 <bigfile>:
{
    40e6:	7139                	addi	sp,sp,-64
    40e8:	fc06                	sd	ra,56(sp)
    40ea:	f822                	sd	s0,48(sp)
    40ec:	f426                	sd	s1,40(sp)
    40ee:	f04a                	sd	s2,32(sp)
    40f0:	ec4e                	sd	s3,24(sp)
    40f2:	e852                	sd	s4,16(sp)
    40f4:	e456                	sd	s5,8(sp)
    40f6:	0080                	addi	s0,sp,64
    40f8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    40fa:	00003517          	auipc	a0,0x3
    40fe:	efe50513          	addi	a0,a0,-258 # 6ff8 <malloc+0x1e6a>
    4102:	3f5000ef          	jal	4cf6 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4106:	20200593          	li	a1,514
    410a:	00003517          	auipc	a0,0x3
    410e:	eee50513          	addi	a0,a0,-274 # 6ff8 <malloc+0x1e6a>
    4112:	3d5000ef          	jal	4ce6 <open>
    4116:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4118:	4481                	li	s1,0
    memset(buf, i, SZ);
    411a:	00009917          	auipc	s2,0x9
    411e:	b8e90913          	addi	s2,s2,-1138 # cca8 <buf>
  for(i = 0; i < N; i++){
    4122:	4a51                	li	s4,20
  if(fd < 0){
    4124:	08054663          	bltz	a0,41b0 <bigfile+0xca>
    memset(buf, i, SZ);
    4128:	25800613          	li	a2,600
    412c:	85a6                	mv	a1,s1
    412e:	854a                	mv	a0,s2
    4130:	145000ef          	jal	4a74 <memset>
    if(write(fd, buf, SZ) != SZ){
    4134:	25800613          	li	a2,600
    4138:	85ca                	mv	a1,s2
    413a:	854e                	mv	a0,s3
    413c:	38b000ef          	jal	4cc6 <write>
    4140:	25800793          	li	a5,600
    4144:	08f51063          	bne	a0,a5,41c4 <bigfile+0xde>
  for(i = 0; i < N; i++){
    4148:	2485                	addiw	s1,s1,1
    414a:	fd449fe3          	bne	s1,s4,4128 <bigfile+0x42>
  close(fd);
    414e:	854e                	mv	a0,s3
    4150:	37f000ef          	jal	4cce <close>
  fd = open("bigfile.dat", 0);
    4154:	4581                	li	a1,0
    4156:	00003517          	auipc	a0,0x3
    415a:	ea250513          	addi	a0,a0,-350 # 6ff8 <malloc+0x1e6a>
    415e:	389000ef          	jal	4ce6 <open>
    4162:	8a2a                	mv	s4,a0
  total = 0;
    4164:	4981                	li	s3,0
  for(i = 0; ; i++){
    4166:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4168:	00009917          	auipc	s2,0x9
    416c:	b4090913          	addi	s2,s2,-1216 # cca8 <buf>
  if(fd < 0){
    4170:	06054463          	bltz	a0,41d8 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4174:	12c00613          	li	a2,300
    4178:	85ca                	mv	a1,s2
    417a:	8552                	mv	a0,s4
    417c:	343000ef          	jal	4cbe <read>
    if(cc < 0){
    4180:	06054663          	bltz	a0,41ec <bigfile+0x106>
    if(cc == 0)
    4184:	c155                	beqz	a0,4228 <bigfile+0x142>
    if(cc != SZ/2){
    4186:	12c00793          	li	a5,300
    418a:	06f51b63          	bne	a0,a5,4200 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    418e:	01f4d79b          	srliw	a5,s1,0x1f
    4192:	9fa5                	addw	a5,a5,s1
    4194:	4017d79b          	sraiw	a5,a5,0x1
    4198:	00094703          	lbu	a4,0(s2)
    419c:	06f71c63          	bne	a4,a5,4214 <bigfile+0x12e>
    41a0:	12b94703          	lbu	a4,299(s2)
    41a4:	06f71863          	bne	a4,a5,4214 <bigfile+0x12e>
    total += cc;
    41a8:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    41ac:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    41ae:	b7d9                	j	4174 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41b0:	85d6                	mv	a1,s5
    41b2:	00003517          	auipc	a0,0x3
    41b6:	e5650513          	addi	a0,a0,-426 # 7008 <malloc+0x1e7a>
    41ba:	721000ef          	jal	50da <printf>
    exit(1);
    41be:	4505                	li	a0,1
    41c0:	2e7000ef          	jal	4ca6 <exit>
      printf("%s: write bigfile failed\n", s);
    41c4:	85d6                	mv	a1,s5
    41c6:	00003517          	auipc	a0,0x3
    41ca:	e6250513          	addi	a0,a0,-414 # 7028 <malloc+0x1e9a>
    41ce:	70d000ef          	jal	50da <printf>
      exit(1);
    41d2:	4505                	li	a0,1
    41d4:	2d3000ef          	jal	4ca6 <exit>
    printf("%s: cannot open bigfile\n", s);
    41d8:	85d6                	mv	a1,s5
    41da:	00003517          	auipc	a0,0x3
    41de:	e6e50513          	addi	a0,a0,-402 # 7048 <malloc+0x1eba>
    41e2:	6f9000ef          	jal	50da <printf>
    exit(1);
    41e6:	4505                	li	a0,1
    41e8:	2bf000ef          	jal	4ca6 <exit>
      printf("%s: read bigfile failed\n", s);
    41ec:	85d6                	mv	a1,s5
    41ee:	00003517          	auipc	a0,0x3
    41f2:	e7a50513          	addi	a0,a0,-390 # 7068 <malloc+0x1eda>
    41f6:	6e5000ef          	jal	50da <printf>
      exit(1);
    41fa:	4505                	li	a0,1
    41fc:	2ab000ef          	jal	4ca6 <exit>
      printf("%s: short read bigfile\n", s);
    4200:	85d6                	mv	a1,s5
    4202:	00003517          	auipc	a0,0x3
    4206:	e8650513          	addi	a0,a0,-378 # 7088 <malloc+0x1efa>
    420a:	6d1000ef          	jal	50da <printf>
      exit(1);
    420e:	4505                	li	a0,1
    4210:	297000ef          	jal	4ca6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4214:	85d6                	mv	a1,s5
    4216:	00003517          	auipc	a0,0x3
    421a:	e8a50513          	addi	a0,a0,-374 # 70a0 <malloc+0x1f12>
    421e:	6bd000ef          	jal	50da <printf>
      exit(1);
    4222:	4505                	li	a0,1
    4224:	283000ef          	jal	4ca6 <exit>
  close(fd);
    4228:	8552                	mv	a0,s4
    422a:	2a5000ef          	jal	4cce <close>
  if(total != N*SZ){
    422e:	678d                	lui	a5,0x3
    4230:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x31e>
    4234:	02f99163          	bne	s3,a5,4256 <bigfile+0x170>
  unlink("bigfile.dat");
    4238:	00003517          	auipc	a0,0x3
    423c:	dc050513          	addi	a0,a0,-576 # 6ff8 <malloc+0x1e6a>
    4240:	2b7000ef          	jal	4cf6 <unlink>
}
    4244:	70e2                	ld	ra,56(sp)
    4246:	7442                	ld	s0,48(sp)
    4248:	74a2                	ld	s1,40(sp)
    424a:	7902                	ld	s2,32(sp)
    424c:	69e2                	ld	s3,24(sp)
    424e:	6a42                	ld	s4,16(sp)
    4250:	6aa2                	ld	s5,8(sp)
    4252:	6121                	addi	sp,sp,64
    4254:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4256:	85d6                	mv	a1,s5
    4258:	00003517          	auipc	a0,0x3
    425c:	e6850513          	addi	a0,a0,-408 # 70c0 <malloc+0x1f32>
    4260:	67b000ef          	jal	50da <printf>
    exit(1);
    4264:	4505                	li	a0,1
    4266:	241000ef          	jal	4ca6 <exit>

000000000000426a <bigargtest>:
{
    426a:	7121                	addi	sp,sp,-448
    426c:	ff06                	sd	ra,440(sp)
    426e:	fb22                	sd	s0,432(sp)
    4270:	f726                	sd	s1,424(sp)
    4272:	0380                	addi	s0,sp,448
    4274:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4276:	00003517          	auipc	a0,0x3
    427a:	e6a50513          	addi	a0,a0,-406 # 70e0 <malloc+0x1f52>
    427e:	279000ef          	jal	4cf6 <unlink>
  pid = fork();
    4282:	21d000ef          	jal	4c9e <fork>
  if(pid == 0){
    4286:	c915                	beqz	a0,42ba <bigargtest+0x50>
  } else if(pid < 0){
    4288:	08054a63          	bltz	a0,431c <bigargtest+0xb2>
  wait(&xstatus);
    428c:	fdc40513          	addi	a0,s0,-36
    4290:	21f000ef          	jal	4cae <wait>
  if(xstatus != 0)
    4294:	fdc42503          	lw	a0,-36(s0)
    4298:	ed41                	bnez	a0,4330 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    429a:	4581                	li	a1,0
    429c:	00003517          	auipc	a0,0x3
    42a0:	e4450513          	addi	a0,a0,-444 # 70e0 <malloc+0x1f52>
    42a4:	243000ef          	jal	4ce6 <open>
  if(fd < 0){
    42a8:	08054663          	bltz	a0,4334 <bigargtest+0xca>
  close(fd);
    42ac:	223000ef          	jal	4cce <close>
}
    42b0:	70fa                	ld	ra,440(sp)
    42b2:	745a                	ld	s0,432(sp)
    42b4:	74ba                	ld	s1,424(sp)
    42b6:	6139                	addi	sp,sp,448
    42b8:	8082                	ret
    memset(big, ' ', sizeof(big));
    42ba:	19000613          	li	a2,400
    42be:	02000593          	li	a1,32
    42c2:	e4840513          	addi	a0,s0,-440
    42c6:	7ae000ef          	jal	4a74 <memset>
    big[sizeof(big)-1] = '\0';
    42ca:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    42ce:	00005797          	auipc	a5,0x5
    42d2:	1c278793          	addi	a5,a5,450 # 9490 <args.1>
    42d6:	00005697          	auipc	a3,0x5
    42da:	2b268693          	addi	a3,a3,690 # 9588 <args.1+0xf8>
      args[i] = big;
    42de:	e4840713          	addi	a4,s0,-440
    42e2:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    42e4:	07a1                	addi	a5,a5,8
    42e6:	fed79ee3          	bne	a5,a3,42e2 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    42ea:	00005597          	auipc	a1,0x5
    42ee:	1a658593          	addi	a1,a1,422 # 9490 <args.1>
    42f2:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42f6:	00001517          	auipc	a0,0x1
    42fa:	fd250513          	addi	a0,a0,-46 # 52c8 <malloc+0x13a>
    42fe:	1e1000ef          	jal	4cde <exec>
    fd = open("bigarg-ok", O_CREATE);
    4302:	20000593          	li	a1,512
    4306:	00003517          	auipc	a0,0x3
    430a:	dda50513          	addi	a0,a0,-550 # 70e0 <malloc+0x1f52>
    430e:	1d9000ef          	jal	4ce6 <open>
    close(fd);
    4312:	1bd000ef          	jal	4cce <close>
    exit(0);
    4316:	4501                	li	a0,0
    4318:	18f000ef          	jal	4ca6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    431c:	85a6                	mv	a1,s1
    431e:	00003517          	auipc	a0,0x3
    4322:	dd250513          	addi	a0,a0,-558 # 70f0 <malloc+0x1f62>
    4326:	5b5000ef          	jal	50da <printf>
    exit(1);
    432a:	4505                	li	a0,1
    432c:	17b000ef          	jal	4ca6 <exit>
    exit(xstatus);
    4330:	177000ef          	jal	4ca6 <exit>
    printf("%s: bigarg test failed!\n", s);
    4334:	85a6                	mv	a1,s1
    4336:	00003517          	auipc	a0,0x3
    433a:	dda50513          	addi	a0,a0,-550 # 7110 <malloc+0x1f82>
    433e:	59d000ef          	jal	50da <printf>
    exit(1);
    4342:	4505                	li	a0,1
    4344:	163000ef          	jal	4ca6 <exit>

0000000000004348 <lazy_alloc>:
{
    4348:	1141                	addi	sp,sp,-16
    434a:	e406                	sd	ra,8(sp)
    434c:	e022                	sd	s0,0(sp)
    434e:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4350:	40000537          	lui	a0,0x40000
    4354:	115000ef          	jal	4c68 <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    4358:	57fd                	li	a5,-1
    435a:	02f50a63          	beq	a0,a5,438e <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    435e:	6605                	lui	a2,0x1
    4360:	962a                	add	a2,a2,a0
    4362:	400017b7          	lui	a5,0x40001
    4366:	00f50733          	add	a4,a0,a5
    436a:	87b2                	mv	a5,a2
    436c:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4370:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4372:	97b6                	add	a5,a5,a3
    4374:	fee79ee3          	bne	a5,a4,4370 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4378:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    437c:	621c                	ld	a5,0(a2)
    437e:	02c79163          	bne	a5,a2,43a0 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4382:	9636                	add	a2,a2,a3
    4384:	fee61ce3          	bne	a2,a4,437c <lazy_alloc+0x34>
  exit(0);
    4388:	4501                	li	a0,0
    438a:	11d000ef          	jal	4ca6 <exit>
    printf("sbrklazy() failed\n");
    438e:	00003517          	auipc	a0,0x3
    4392:	da250513          	addi	a0,a0,-606 # 7130 <malloc+0x1fa2>
    4396:	545000ef          	jal	50da <printf>
    exit(1);
    439a:	4505                	li	a0,1
    439c:	10b000ef          	jal	4ca6 <exit>
      printf("failed to read value from memory\n");
    43a0:	00003517          	auipc	a0,0x3
    43a4:	da850513          	addi	a0,a0,-600 # 7148 <malloc+0x1fba>
    43a8:	533000ef          	jal	50da <printf>
      exit(1);
    43ac:	4505                	li	a0,1
    43ae:	0f9000ef          	jal	4ca6 <exit>

00000000000043b2 <lazy_unmap>:
{
    43b2:	7139                	addi	sp,sp,-64
    43b4:	fc06                	sd	ra,56(sp)
    43b6:	f822                	sd	s0,48(sp)
    43b8:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    43ba:	40000537          	lui	a0,0x40000
    43be:	0ab000ef          	jal	4c68 <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    43c2:	57fd                	li	a5,-1
    43c4:	04f50663          	beq	a0,a5,4410 <lazy_unmap+0x5e>
    43c8:	f426                	sd	s1,40(sp)
    43ca:	f04a                	sd	s2,32(sp)
    43cc:	ec4e                	sd	s3,24(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    43ce:	6905                	lui	s2,0x1
    43d0:	992a                	add	s2,s2,a0
    43d2:	400017b7          	lui	a5,0x40001
    43d6:	00f504b3          	add	s1,a0,a5
    43da:	87ca                	mv	a5,s2
    43dc:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    43e0:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    43e2:	97ba                	add	a5,a5,a4
    43e4:	fe979ee3          	bne	a5,s1,43e0 <lazy_unmap+0x2e>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    43e8:	010009b7          	lui	s3,0x1000
    pid = fork();
    43ec:	0b3000ef          	jal	4c9e <fork>
    if (pid < 0) {
    43f0:	02054c63          	bltz	a0,4428 <lazy_unmap+0x76>
    } else if (pid == 0) {
    43f4:	c139                	beqz	a0,443a <lazy_unmap+0x88>
      wait(&status);
    43f6:	fcc40513          	addi	a0,s0,-52
    43fa:	0b5000ef          	jal	4cae <wait>
      if (status == 0) {
    43fe:	fcc42783          	lw	a5,-52(s0)
    4402:	c7a9                	beqz	a5,444c <lazy_unmap+0x9a>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4404:	994e                	add	s2,s2,s3
    4406:	fe9913e3          	bne	s2,s1,43ec <lazy_unmap+0x3a>
  exit(0);
    440a:	4501                	li	a0,0
    440c:	09b000ef          	jal	4ca6 <exit>
    4410:	f426                	sd	s1,40(sp)
    4412:	f04a                	sd	s2,32(sp)
    4414:	ec4e                	sd	s3,24(sp)
    printf("sbrklazy() failed\n");
    4416:	00003517          	auipc	a0,0x3
    441a:	d1a50513          	addi	a0,a0,-742 # 7130 <malloc+0x1fa2>
    441e:	4bd000ef          	jal	50da <printf>
    exit(1);
    4422:	4505                	li	a0,1
    4424:	083000ef          	jal	4ca6 <exit>
      printf("error forking\n");
    4428:	00003517          	auipc	a0,0x3
    442c:	d4850513          	addi	a0,a0,-696 # 7170 <malloc+0x1fe2>
    4430:	4ab000ef          	jal	50da <printf>
      exit(1);
    4434:	4505                	li	a0,1
    4436:	071000ef          	jal	4ca6 <exit>
      sbrklazy(-1L * REGION_SZ);
    443a:	c0000537          	lui	a0,0xc0000
    443e:	02b000ef          	jal	4c68 <sbrklazy>
      *(char **)i = i;
    4442:	01293023          	sd	s2,0(s2) # 1000 <badarg>
      exit(0);
    4446:	4501                	li	a0,0
    4448:	05f000ef          	jal	4ca6 <exit>
        printf("memory not unmapped\n");
    444c:	00003517          	auipc	a0,0x3
    4450:	d3450513          	addi	a0,a0,-716 # 7180 <malloc+0x1ff2>
    4454:	487000ef          	jal	50da <printf>
        exit(1);
    4458:	4505                	li	a0,1
    445a:	04d000ef          	jal	4ca6 <exit>

000000000000445e <lazy_copy>:
{
    445e:	7159                	addi	sp,sp,-112
    4460:	f486                	sd	ra,104(sp)
    4462:	f0a2                	sd	s0,96(sp)
    4464:	eca6                	sd	s1,88(sp)
    4466:	e8ca                	sd	s2,80(sp)
    4468:	e4ce                	sd	s3,72(sp)
    446a:	e0d2                	sd	s4,64(sp)
    446c:	fc56                	sd	s5,56(sp)
    446e:	f85a                	sd	s6,48(sp)
    4470:	1880                	addi	s0,sp,112
    char *p = sbrk(0);
    4472:	4501                	li	a0,0
    4474:	7de000ef          	jal	4c52 <sbrk>
    4478:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    447a:	6511                	lui	a0,0x4
    447c:	7ec000ef          	jal	4c68 <sbrklazy>
    open(p + 8192, 0);
    4480:	4581                	li	a1,0
    4482:	6509                	lui	a0,0x2
    4484:	9526                	add	a0,a0,s1
    4486:	061000ef          	jal	4ce6 <open>
    void *xx = sbrk(0);
    448a:	4501                	li	a0,0
    448c:	7c6000ef          	jal	4c52 <sbrk>
    4490:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    4492:	fff54513          	not	a0,a0
    4496:	2501                	sext.w	a0,a0
    4498:	7ba000ef          	jal	4c52 <sbrk>
    if(ret != xx){
    449c:	00a48c63          	beq	s1,a0,44b4 <lazy_copy+0x56>
    44a0:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    44a2:	00003517          	auipc	a0,0x3
    44a6:	cf650513          	addi	a0,a0,-778 # 7198 <malloc+0x200a>
    44aa:	431000ef          	jal	50da <printf>
      exit(1);
    44ae:	4505                	li	a0,1
    44b0:	7f6000ef          	jal	4ca6 <exit>
  unsigned long bad[] = {
    44b4:	00003797          	auipc	a5,0x3
    44b8:	26478793          	addi	a5,a5,612 # 7718 <malloc+0x258a>
    44bc:	7fa8                	ld	a0,120(a5)
    44be:	63cc                	ld	a1,128(a5)
    44c0:	67d0                	ld	a2,136(a5)
    44c2:	6bd4                	ld	a3,144(a5)
    44c4:	6fd8                	ld	a4,152(a5)
    44c6:	73dc                	ld	a5,160(a5)
    44c8:	f8a43823          	sd	a0,-112(s0)
    44cc:	f8b43c23          	sd	a1,-104(s0)
    44d0:	fac43023          	sd	a2,-96(s0)
    44d4:	fad43423          	sd	a3,-88(s0)
    44d8:	fae43823          	sd	a4,-80(s0)
    44dc:	faf43c23          	sd	a5,-72(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    44e0:	f9040913          	addi	s2,s0,-112
    44e4:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
    44e8:	00001a17          	auipc	s4,0x1
    44ec:	fb8a0a13          	addi	s4,s4,-72 # 54a0 <malloc+0x312>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    44f0:	00001a97          	auipc	s5,0x1
    44f4:	ec0a8a93          	addi	s5,s5,-320 # 53b0 <malloc+0x222>
    int fd = open("README", 0);
    44f8:	4581                	li	a1,0
    44fa:	8552                	mv	a0,s4
    44fc:	7ea000ef          	jal	4ce6 <open>
    4500:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    4502:	04054663          	bltz	a0,454e <lazy_copy+0xf0>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4506:	00093983          	ld	s3,0(s2)
    450a:	20000613          	li	a2,512
    450e:	85ce                	mv	a1,s3
    4510:	7ae000ef          	jal	4cbe <read>
    4514:	04055663          	bgez	a0,4560 <lazy_copy+0x102>
    close(fd);
    4518:	8526                	mv	a0,s1
    451a:	7b4000ef          	jal	4cce <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    451e:	60200593          	li	a1,1538
    4522:	8556                	mv	a0,s5
    4524:	7c2000ef          	jal	4ce6 <open>
    4528:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    452a:	04054463          	bltz	a0,4572 <lazy_copy+0x114>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    452e:	20000613          	li	a2,512
    4532:	85ce                	mv	a1,s3
    4534:	792000ef          	jal	4cc6 <write>
    4538:	04055663          	bgez	a0,4584 <lazy_copy+0x126>
    close(fd);
    453c:	8526                	mv	a0,s1
    453e:	790000ef          	jal	4cce <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4542:	0921                	addi	s2,s2,8
    4544:	fb691ae3          	bne	s2,s6,44f8 <lazy_copy+0x9a>
  exit(0);
    4548:	4501                	li	a0,0
    454a:	75c000ef          	jal	4ca6 <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    454e:	00003517          	auipc	a0,0x3
    4552:	c7a50513          	addi	a0,a0,-902 # 71c8 <malloc+0x203a>
    4556:	385000ef          	jal	50da <printf>
    455a:	4505                	li	a0,1
    455c:	74a000ef          	jal	4ca6 <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4560:	00003517          	auipc	a0,0x3
    4564:	c8050513          	addi	a0,a0,-896 # 71e0 <malloc+0x2052>
    4568:	373000ef          	jal	50da <printf>
    456c:	4505                	li	a0,1
    456e:	738000ef          	jal	4ca6 <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4572:	00003517          	auipc	a0,0x3
    4576:	c7e50513          	addi	a0,a0,-898 # 71f0 <malloc+0x2062>
    457a:	361000ef          	jal	50da <printf>
    457e:	4505                	li	a0,1
    4580:	726000ef          	jal	4ca6 <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4584:	00003517          	auipc	a0,0x3
    4588:	c8450513          	addi	a0,a0,-892 # 7208 <malloc+0x207a>
    458c:	34f000ef          	jal	50da <printf>
    4590:	4505                	li	a0,1
    4592:	714000ef          	jal	4ca6 <exit>

0000000000004596 <fsfull>:
{
    4596:	7135                	addi	sp,sp,-160
    4598:	ed06                	sd	ra,152(sp)
    459a:	e922                	sd	s0,144(sp)
    459c:	e526                	sd	s1,136(sp)
    459e:	e14a                	sd	s2,128(sp)
    45a0:	fcce                	sd	s3,120(sp)
    45a2:	f8d2                	sd	s4,112(sp)
    45a4:	f4d6                	sd	s5,104(sp)
    45a6:	f0da                	sd	s6,96(sp)
    45a8:	ecde                	sd	s7,88(sp)
    45aa:	e8e2                	sd	s8,80(sp)
    45ac:	e4e6                	sd	s9,72(sp)
    45ae:	e0ea                	sd	s10,64(sp)
    45b0:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    45b2:	00003517          	auipc	a0,0x3
    45b6:	c6e50513          	addi	a0,a0,-914 # 7220 <malloc+0x2092>
    45ba:	321000ef          	jal	50da <printf>
  for(nfiles = 0; ; nfiles++){
    45be:	4481                	li	s1,0
    name[0] = 'f';
    45c0:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    45c4:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    45c8:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    45cc:	4b29                	li	s6,10
    printf("writing %s\n", name);
    45ce:	00003c97          	auipc	s9,0x3
    45d2:	c62c8c93          	addi	s9,s9,-926 # 7230 <malloc+0x20a2>
    name[0] = 'f';
    45d6:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    45da:	0384c7bb          	divw	a5,s1,s8
    45de:	0307879b          	addiw	a5,a5,48
    45e2:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    45e6:	0384e7bb          	remw	a5,s1,s8
    45ea:	0377c7bb          	divw	a5,a5,s7
    45ee:	0307879b          	addiw	a5,a5,48
    45f2:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    45f6:	0374e7bb          	remw	a5,s1,s7
    45fa:	0367c7bb          	divw	a5,a5,s6
    45fe:	0307879b          	addiw	a5,a5,48
    4602:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4606:	0364e7bb          	remw	a5,s1,s6
    460a:	0307879b          	addiw	a5,a5,48
    460e:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4612:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    4616:	f6040593          	addi	a1,s0,-160
    461a:	8566                	mv	a0,s9
    461c:	2bf000ef          	jal	50da <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4620:	20200593          	li	a1,514
    4624:	f6040513          	addi	a0,s0,-160
    4628:	6be000ef          	jal	4ce6 <open>
    462c:	892a                	mv	s2,a0
    if(fd < 0){
    462e:	08055f63          	bgez	a0,46cc <fsfull+0x136>
      printf("open %s failed\n", name);
    4632:	f6040593          	addi	a1,s0,-160
    4636:	00003517          	auipc	a0,0x3
    463a:	c0a50513          	addi	a0,a0,-1014 # 7240 <malloc+0x20b2>
    463e:	29d000ef          	jal	50da <printf>
  while(nfiles >= 0){
    4642:	0604c163          	bltz	s1,46a4 <fsfull+0x10e>
    name[0] = 'f';
    4646:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    464a:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    464e:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4652:	4929                	li	s2,10
  while(nfiles >= 0){
    4654:	5afd                	li	s5,-1
    name[0] = 'f';
    4656:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    465a:	0344c7bb          	divw	a5,s1,s4
    465e:	0307879b          	addiw	a5,a5,48
    4662:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4666:	0344e7bb          	remw	a5,s1,s4
    466a:	0337c7bb          	divw	a5,a5,s3
    466e:	0307879b          	addiw	a5,a5,48
    4672:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4676:	0334e7bb          	remw	a5,s1,s3
    467a:	0327c7bb          	divw	a5,a5,s2
    467e:	0307879b          	addiw	a5,a5,48
    4682:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4686:	0324e7bb          	remw	a5,s1,s2
    468a:	0307879b          	addiw	a5,a5,48
    468e:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4692:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4696:	f6040513          	addi	a0,s0,-160
    469a:	65c000ef          	jal	4cf6 <unlink>
    nfiles--;
    469e:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    46a0:	fb549be3          	bne	s1,s5,4656 <fsfull+0xc0>
  printf("fsfull test finished\n");
    46a4:	00003517          	auipc	a0,0x3
    46a8:	bbc50513          	addi	a0,a0,-1092 # 7260 <malloc+0x20d2>
    46ac:	22f000ef          	jal	50da <printf>
}
    46b0:	60ea                	ld	ra,152(sp)
    46b2:	644a                	ld	s0,144(sp)
    46b4:	64aa                	ld	s1,136(sp)
    46b6:	690a                	ld	s2,128(sp)
    46b8:	79e6                	ld	s3,120(sp)
    46ba:	7a46                	ld	s4,112(sp)
    46bc:	7aa6                	ld	s5,104(sp)
    46be:	7b06                	ld	s6,96(sp)
    46c0:	6be6                	ld	s7,88(sp)
    46c2:	6c46                	ld	s8,80(sp)
    46c4:	6ca6                	ld	s9,72(sp)
    46c6:	6d06                	ld	s10,64(sp)
    46c8:	610d                	addi	sp,sp,160
    46ca:	8082                	ret
    int total = 0;
    46cc:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    46ce:	00008a97          	auipc	s5,0x8
    46d2:	5daa8a93          	addi	s5,s5,1498 # cca8 <buf>
      if(cc < BSIZE)
    46d6:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    46da:	40000613          	li	a2,1024
    46de:	85d6                	mv	a1,s5
    46e0:	854a                	mv	a0,s2
    46e2:	5e4000ef          	jal	4cc6 <write>
      if(cc < BSIZE)
    46e6:	00aa5563          	bge	s4,a0,46f0 <fsfull+0x15a>
      total += cc;
    46ea:	00a989bb          	addw	s3,s3,a0
    while(1){
    46ee:	b7f5                	j	46da <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    46f0:	85ce                	mv	a1,s3
    46f2:	00003517          	auipc	a0,0x3
    46f6:	b5e50513          	addi	a0,a0,-1186 # 7250 <malloc+0x20c2>
    46fa:	1e1000ef          	jal	50da <printf>
    close(fd);
    46fe:	854a                	mv	a0,s2
    4700:	5ce000ef          	jal	4cce <close>
    if(total == 0)
    4704:	f2098fe3          	beqz	s3,4642 <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    4708:	2485                	addiw	s1,s1,1
    470a:	b5f1                	j	45d6 <fsfull+0x40>

000000000000470c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    470c:	7179                	addi	sp,sp,-48
    470e:	f406                	sd	ra,40(sp)
    4710:	f022                	sd	s0,32(sp)
    4712:	ec26                	sd	s1,24(sp)
    4714:	e84a                	sd	s2,16(sp)
    4716:	1800                	addi	s0,sp,48
    4718:	84aa                	mv	s1,a0
    471a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    471c:	00003517          	auipc	a0,0x3
    4720:	b5c50513          	addi	a0,a0,-1188 # 7278 <malloc+0x20ea>
    4724:	1b7000ef          	jal	50da <printf>
  if((pid = fork()) < 0) {
    4728:	576000ef          	jal	4c9e <fork>
    472c:	02054a63          	bltz	a0,4760 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4730:	c129                	beqz	a0,4772 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4732:	fdc40513          	addi	a0,s0,-36
    4736:	578000ef          	jal	4cae <wait>
    if(xstatus != 0) 
    473a:	fdc42783          	lw	a5,-36(s0)
    473e:	cf9d                	beqz	a5,477c <run+0x70>
      printf("FAILED\n");
    4740:	00003517          	auipc	a0,0x3
    4744:	b6050513          	addi	a0,a0,-1184 # 72a0 <malloc+0x2112>
    4748:	193000ef          	jal	50da <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    474c:	fdc42503          	lw	a0,-36(s0)
  }
}
    4750:	00153513          	seqz	a0,a0
    4754:	70a2                	ld	ra,40(sp)
    4756:	7402                	ld	s0,32(sp)
    4758:	64e2                	ld	s1,24(sp)
    475a:	6942                	ld	s2,16(sp)
    475c:	6145                	addi	sp,sp,48
    475e:	8082                	ret
    printf("runtest: fork error\n");
    4760:	00003517          	auipc	a0,0x3
    4764:	b2850513          	addi	a0,a0,-1240 # 7288 <malloc+0x20fa>
    4768:	173000ef          	jal	50da <printf>
    exit(1);
    476c:	4505                	li	a0,1
    476e:	538000ef          	jal	4ca6 <exit>
    f(s);
    4772:	854a                	mv	a0,s2
    4774:	9482                	jalr	s1
    exit(0);
    4776:	4501                	li	a0,0
    4778:	52e000ef          	jal	4ca6 <exit>
      printf("OK\n");
    477c:	00003517          	auipc	a0,0x3
    4780:	b2c50513          	addi	a0,a0,-1236 # 72a8 <malloc+0x211a>
    4784:	157000ef          	jal	50da <printf>
    4788:	b7d1                	j	474c <run+0x40>

000000000000478a <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    478a:	7139                	addi	sp,sp,-64
    478c:	fc06                	sd	ra,56(sp)
    478e:	f822                	sd	s0,48(sp)
    4790:	f426                	sd	s1,40(sp)
    4792:	ec4e                	sd	s3,24(sp)
    4794:	0080                	addi	s0,sp,64
    4796:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4798:	6508                	ld	a0,8(a0)
    479a:	cd39                	beqz	a0,47f8 <runtests+0x6e>
    479c:	f04a                	sd	s2,32(sp)
    479e:	e852                	sd	s4,16(sp)
    47a0:	e456                	sd	s5,8(sp)
    47a2:	892e                	mv	s2,a1
    47a4:	8a32                	mv	s4,a2
  int ntests = 0;
    47a6:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    47a8:	4a89                	li	s5,2
    47aa:	a021                	j	47b2 <runtests+0x28>
  for (struct test *t = tests; t->s != 0; t++) {
    47ac:	04c1                	addi	s1,s1,16
    47ae:	6488                	ld	a0,8(s1)
    47b0:	c915                	beqz	a0,47e4 <runtests+0x5a>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    47b2:	00090663          	beqz	s2,47be <runtests+0x34>
    47b6:	85ca                	mv	a1,s2
    47b8:	266000ef          	jal	4a1e <strcmp>
    47bc:	f965                	bnez	a0,47ac <runtests+0x22>
      ntests++;
    47be:	2985                	addiw	s3,s3,1 # 1000001 <base+0xff0359>
      if(!run(t->f, t->s)){
    47c0:	648c                	ld	a1,8(s1)
    47c2:	6088                	ld	a0,0(s1)
    47c4:	f49ff0ef          	jal	470c <run>
    47c8:	f175                	bnez	a0,47ac <runtests+0x22>
        if(continuous != 2){
    47ca:	ff5a01e3          	beq	s4,s5,47ac <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    47ce:	00003517          	auipc	a0,0x3
    47d2:	ae250513          	addi	a0,a0,-1310 # 72b0 <malloc+0x2122>
    47d6:	105000ef          	jal	50da <printf>
          return -1;
    47da:	59fd                	li	s3,-1
    47dc:	7902                	ld	s2,32(sp)
    47de:	6a42                	ld	s4,16(sp)
    47e0:	6aa2                	ld	s5,8(sp)
    47e2:	a021                	j	47ea <runtests+0x60>
    47e4:	7902                	ld	s2,32(sp)
    47e6:	6a42                	ld	s4,16(sp)
    47e8:	6aa2                	ld	s5,8(sp)
        }
      }
    }
  }
  return ntests;
}
    47ea:	854e                	mv	a0,s3
    47ec:	70e2                	ld	ra,56(sp)
    47ee:	7442                	ld	s0,48(sp)
    47f0:	74a2                	ld	s1,40(sp)
    47f2:	69e2                	ld	s3,24(sp)
    47f4:	6121                	addi	sp,sp,64
    47f6:	8082                	ret
  return ntests;
    47f8:	4981                	li	s3,0
    47fa:	bfc5                	j	47ea <runtests+0x60>

00000000000047fc <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    47fc:	7179                	addi	sp,sp,-48
    47fe:	f406                	sd	ra,40(sp)
    4800:	f022                	sd	s0,32(sp)
    4802:	ec26                	sd	s1,24(sp)
    4804:	e84a                	sd	s2,16(sp)
    4806:	e44e                	sd	s3,8(sp)
    4808:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    480a:	4501                	li	a0,0
    480c:	446000ef          	jal	4c52 <sbrk>
    4810:	89aa                	mv	s3,a0
  int n = 0;
    4812:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    if(a == SBRK_ERROR){
    4814:	597d                	li	s2,-1
    4816:	a011                	j	481a <countfree+0x1e>
      break;
    }
    n += 1;
    4818:	2485                	addiw	s1,s1,1
    char *a = sbrk(PGSIZE);
    481a:	6505                	lui	a0,0x1
    481c:	436000ef          	jal	4c52 <sbrk>
    if(a == SBRK_ERROR){
    4820:	ff251ce3          	bne	a0,s2,4818 <countfree+0x1c>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    4824:	4501                	li	a0,0
    4826:	42c000ef          	jal	4c52 <sbrk>
    482a:	40a9853b          	subw	a0,s3,a0
    482e:	424000ef          	jal	4c52 <sbrk>
  return n;
}
    4832:	8526                	mv	a0,s1
    4834:	70a2                	ld	ra,40(sp)
    4836:	7402                	ld	s0,32(sp)
    4838:	64e2                	ld	s1,24(sp)
    483a:	6942                	ld	s2,16(sp)
    483c:	69a2                	ld	s3,8(sp)
    483e:	6145                	addi	sp,sp,48
    4840:	8082                	ret

0000000000004842 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4842:	7159                	addi	sp,sp,-112
    4844:	f486                	sd	ra,104(sp)
    4846:	f0a2                	sd	s0,96(sp)
    4848:	eca6                	sd	s1,88(sp)
    484a:	e8ca                	sd	s2,80(sp)
    484c:	e4ce                	sd	s3,72(sp)
    484e:	e0d2                	sd	s4,64(sp)
    4850:	fc56                	sd	s5,56(sp)
    4852:	f85a                	sd	s6,48(sp)
    4854:	f45e                	sd	s7,40(sp)
    4856:	f062                	sd	s8,32(sp)
    4858:	ec66                	sd	s9,24(sp)
    485a:	e86a                	sd	s10,16(sp)
    485c:	e46e                	sd	s11,8(sp)
    485e:	1880                	addi	s0,sp,112
    4860:	8aaa                	mv	s5,a0
    4862:	89ae                	mv	s3,a1
    4864:	8a32                	mv	s4,a2
  do {
    printf("usertests starting\n");
    4866:	00003c17          	auipc	s8,0x3
    486a:	a62c0c13          	addi	s8,s8,-1438 # 72c8 <malloc+0x213a>
    int free0 = countfree();
    int free1 = 0;
    int ntests = 0;
    int n;
    n = runtests(quicktests, justone, continuous);
    486e:	00004b97          	auipc	s7,0x4
    4872:	7a2b8b93          	addi	s7,s7,1954 # 9010 <quicktests>
    if (n < 0) {
      if(continuous != 2) {
    4876:	4b09                	li	s6,2
      ntests += n;
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      n = runtests(slowtests, justone, continuous);
    4878:	00005c97          	auipc	s9,0x5
    487c:	b98c8c93          	addi	s9,s9,-1128 # 9410 <slowtests>
        printf("usertests slow tests starting\n");
    4880:	00003d97          	auipc	s11,0x3
    4884:	a60d8d93          	addi	s11,s11,-1440 # 72e0 <malloc+0x2152>
      } else {
        ntests += n;
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4888:	00003d17          	auipc	s10,0x3
    488c:	a78d0d13          	addi	s10,s10,-1416 # 7300 <malloc+0x2172>
    4890:	a025                	j	48b8 <drivetests+0x76>
      if(continuous != 2) {
    4892:	09699063          	bne	s3,s6,4912 <drivetests+0xd0>
    int ntests = 0;
    4896:	4481                	li	s1,0
    4898:	a835                	j	48d4 <drivetests+0x92>
        printf("usertests slow tests starting\n");
    489a:	856e                	mv	a0,s11
    489c:	03f000ef          	jal	50da <printf>
    48a0:	a835                	j	48dc <drivetests+0x9a>
        if(continuous != 2) {
    48a2:	07699a63          	bne	s3,s6,4916 <drivetests+0xd4>
    if((free1 = countfree()) < free0) {
    48a6:	f57ff0ef          	jal	47fc <countfree>
    48aa:	05254263          	blt	a0,s2,48ee <drivetests+0xac>
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    48ae:	000a0363          	beqz	s4,48b4 <drivetests+0x72>
    48b2:	c8a1                	beqz	s1,4902 <drivetests+0xc0>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    48b4:	06098563          	beqz	s3,491e <drivetests+0xdc>
    printf("usertests starting\n");
    48b8:	8562                	mv	a0,s8
    48ba:	021000ef          	jal	50da <printf>
    int free0 = countfree();
    48be:	f3fff0ef          	jal	47fc <countfree>
    48c2:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    48c4:	864e                	mv	a2,s3
    48c6:	85d2                	mv	a1,s4
    48c8:	855e                	mv	a0,s7
    48ca:	ec1ff0ef          	jal	478a <runtests>
    48ce:	84aa                	mv	s1,a0
    if (n < 0) {
    48d0:	fc0541e3          	bltz	a0,4892 <drivetests+0x50>
    if(!quick) {
    48d4:	fc0a99e3          	bnez	s5,48a6 <drivetests+0x64>
      if (justone == 0)
    48d8:	fc0a01e3          	beqz	s4,489a <drivetests+0x58>
      n = runtests(slowtests, justone, continuous);
    48dc:	864e                	mv	a2,s3
    48de:	85d2                	mv	a1,s4
    48e0:	8566                	mv	a0,s9
    48e2:	ea9ff0ef          	jal	478a <runtests>
      if (n < 0) {
    48e6:	fa054ee3          	bltz	a0,48a2 <drivetests+0x60>
        ntests += n;
    48ea:	9ca9                	addw	s1,s1,a0
    48ec:	bf6d                	j	48a6 <drivetests+0x64>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    48ee:	864a                	mv	a2,s2
    48f0:	85aa                	mv	a1,a0
    48f2:	856a                	mv	a0,s10
    48f4:	7e6000ef          	jal	50da <printf>
      if(continuous != 2) {
    48f8:	03699163          	bne	s3,s6,491a <drivetests+0xd8>
    if (justone != 0 && ntests == 0) {
    48fc:	fa0a1be3          	bnez	s4,48b2 <drivetests+0x70>
    4900:	bf65                	j	48b8 <drivetests+0x76>
      printf("NO TESTS EXECUTED\n");
    4902:	00003517          	auipc	a0,0x3
    4906:	a2e50513          	addi	a0,a0,-1490 # 7330 <malloc+0x21a2>
    490a:	7d0000ef          	jal	50da <printf>
      return 1;
    490e:	4505                	li	a0,1
    4910:	a801                	j	4920 <drivetests+0xde>
        return 1;
    4912:	4505                	li	a0,1
    4914:	a031                	j	4920 <drivetests+0xde>
          return 1;
    4916:	4505                	li	a0,1
    4918:	a021                	j	4920 <drivetests+0xde>
        return 1;
    491a:	4505                	li	a0,1
    491c:	a011                	j	4920 <drivetests+0xde>
  return 0;
    491e:	854e                	mv	a0,s3
}
    4920:	70a6                	ld	ra,104(sp)
    4922:	7406                	ld	s0,96(sp)
    4924:	64e6                	ld	s1,88(sp)
    4926:	6946                	ld	s2,80(sp)
    4928:	69a6                	ld	s3,72(sp)
    492a:	6a06                	ld	s4,64(sp)
    492c:	7ae2                	ld	s5,56(sp)
    492e:	7b42                	ld	s6,48(sp)
    4930:	7ba2                	ld	s7,40(sp)
    4932:	7c02                	ld	s8,32(sp)
    4934:	6ce2                	ld	s9,24(sp)
    4936:	6d42                	ld	s10,16(sp)
    4938:	6da2                	ld	s11,8(sp)
    493a:	6165                	addi	sp,sp,112
    493c:	8082                	ret

000000000000493e <main>:

int
main(int argc, char *argv[])
{
    493e:	1101                	addi	sp,sp,-32
    4940:	ec06                	sd	ra,24(sp)
    4942:	e822                	sd	s0,16(sp)
    4944:	e426                	sd	s1,8(sp)
    4946:	e04a                	sd	s2,0(sp)
    4948:	1000                	addi	s0,sp,32
    494a:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    494c:	4789                	li	a5,2
    494e:	00f50e63          	beq	a0,a5,496a <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4952:	4785                	li	a5,1
    4954:	06a7c663          	blt	a5,a0,49c0 <main+0x82>
  char *justone = 0;
    4958:	4601                	li	a2,0
  int quick = 0;
    495a:	4501                	li	a0,0
  int continuous = 0;
    495c:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    495e:	ee5ff0ef          	jal	4842 <drivetests>
    4962:	cd35                	beqz	a0,49de <main+0xa0>
    exit(1);
    4964:	4505                	li	a0,1
    4966:	340000ef          	jal	4ca6 <exit>
    496a:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    496c:	00003597          	auipc	a1,0x3
    4970:	9dc58593          	addi	a1,a1,-1572 # 7348 <malloc+0x21ba>
    4974:	00893503          	ld	a0,8(s2)
    4978:	0a6000ef          	jal	4a1e <strcmp>
    497c:	85aa                	mv	a1,a0
    497e:	e501                	bnez	a0,4986 <main+0x48>
  char *justone = 0;
    4980:	4601                	li	a2,0
    quick = 1;
    4982:	4505                	li	a0,1
    4984:	bfe9                	j	495e <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4986:	00003597          	auipc	a1,0x3
    498a:	9ca58593          	addi	a1,a1,-1590 # 7350 <malloc+0x21c2>
    498e:	00893503          	ld	a0,8(s2)
    4992:	08c000ef          	jal	4a1e <strcmp>
    4996:	cd15                	beqz	a0,49d2 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4998:	00003597          	auipc	a1,0x3
    499c:	a0858593          	addi	a1,a1,-1528 # 73a0 <malloc+0x2212>
    49a0:	00893503          	ld	a0,8(s2)
    49a4:	07a000ef          	jal	4a1e <strcmp>
    49a8:	c905                	beqz	a0,49d8 <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    49aa:	00893603          	ld	a2,8(s2)
    49ae:	00064703          	lbu	a4,0(a2) # 1000 <badarg>
    49b2:	02d00793          	li	a5,45
    49b6:	00f70563          	beq	a4,a5,49c0 <main+0x82>
  int quick = 0;
    49ba:	4501                	li	a0,0
  int continuous = 0;
    49bc:	4581                	li	a1,0
    49be:	b745                	j	495e <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    49c0:	00003517          	auipc	a0,0x3
    49c4:	99850513          	addi	a0,a0,-1640 # 7358 <malloc+0x21ca>
    49c8:	712000ef          	jal	50da <printf>
    exit(1);
    49cc:	4505                	li	a0,1
    49ce:	2d8000ef          	jal	4ca6 <exit>
  char *justone = 0;
    49d2:	4601                	li	a2,0
    continuous = 1;
    49d4:	4585                	li	a1,1
    49d6:	b761                	j	495e <main+0x20>
    continuous = 2;
    49d8:	85a6                	mv	a1,s1
  char *justone = 0;
    49da:	4601                	li	a2,0
    49dc:	b749                	j	495e <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    49de:	00003517          	auipc	a0,0x3
    49e2:	9aa50513          	addi	a0,a0,-1622 # 7388 <malloc+0x21fa>
    49e6:	6f4000ef          	jal	50da <printf>
  exit(0);
    49ea:	4501                	li	a0,0
    49ec:	2ba000ef          	jal	4ca6 <exit>

00000000000049f0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    49f0:	1141                	addi	sp,sp,-16
    49f2:	e406                	sd	ra,8(sp)
    49f4:	e022                	sd	s0,0(sp)
    49f6:	0800                	addi	s0,sp,16
  extern int main();
  main();
    49f8:	f47ff0ef          	jal	493e <main>
  exit(0);
    49fc:	4501                	li	a0,0
    49fe:	2a8000ef          	jal	4ca6 <exit>

0000000000004a02 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4a02:	1141                	addi	sp,sp,-16
    4a04:	e422                	sd	s0,8(sp)
    4a06:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4a08:	87aa                	mv	a5,a0
    4a0a:	0585                	addi	a1,a1,1
    4a0c:	0785                	addi	a5,a5,1
    4a0e:	fff5c703          	lbu	a4,-1(a1)
    4a12:	fee78fa3          	sb	a4,-1(a5)
    4a16:	fb75                	bnez	a4,4a0a <strcpy+0x8>
    ;
  return os;
}
    4a18:	6422                	ld	s0,8(sp)
    4a1a:	0141                	addi	sp,sp,16
    4a1c:	8082                	ret

0000000000004a1e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a1e:	1141                	addi	sp,sp,-16
    4a20:	e422                	sd	s0,8(sp)
    4a22:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4a24:	00054783          	lbu	a5,0(a0)
    4a28:	cb91                	beqz	a5,4a3c <strcmp+0x1e>
    4a2a:	0005c703          	lbu	a4,0(a1)
    4a2e:	00f71763          	bne	a4,a5,4a3c <strcmp+0x1e>
    p++, q++;
    4a32:	0505                	addi	a0,a0,1
    4a34:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4a36:	00054783          	lbu	a5,0(a0)
    4a3a:	fbe5                	bnez	a5,4a2a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4a3c:	0005c503          	lbu	a0,0(a1)
}
    4a40:	40a7853b          	subw	a0,a5,a0
    4a44:	6422                	ld	s0,8(sp)
    4a46:	0141                	addi	sp,sp,16
    4a48:	8082                	ret

0000000000004a4a <strlen>:

uint
strlen(const char *s)
{
    4a4a:	1141                	addi	sp,sp,-16
    4a4c:	e422                	sd	s0,8(sp)
    4a4e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4a50:	00054783          	lbu	a5,0(a0)
    4a54:	cf91                	beqz	a5,4a70 <strlen+0x26>
    4a56:	0505                	addi	a0,a0,1
    4a58:	87aa                	mv	a5,a0
    4a5a:	86be                	mv	a3,a5
    4a5c:	0785                	addi	a5,a5,1
    4a5e:	fff7c703          	lbu	a4,-1(a5)
    4a62:	ff65                	bnez	a4,4a5a <strlen+0x10>
    4a64:	40a6853b          	subw	a0,a3,a0
    4a68:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4a6a:	6422                	ld	s0,8(sp)
    4a6c:	0141                	addi	sp,sp,16
    4a6e:	8082                	ret
  for(n = 0; s[n]; n++)
    4a70:	4501                	li	a0,0
    4a72:	bfe5                	j	4a6a <strlen+0x20>

0000000000004a74 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4a74:	1141                	addi	sp,sp,-16
    4a76:	e422                	sd	s0,8(sp)
    4a78:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4a7a:	ca19                	beqz	a2,4a90 <memset+0x1c>
    4a7c:	87aa                	mv	a5,a0
    4a7e:	1602                	slli	a2,a2,0x20
    4a80:	9201                	srli	a2,a2,0x20
    4a82:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4a86:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4a8a:	0785                	addi	a5,a5,1
    4a8c:	fee79de3          	bne	a5,a4,4a86 <memset+0x12>
  }
  return dst;
}
    4a90:	6422                	ld	s0,8(sp)
    4a92:	0141                	addi	sp,sp,16
    4a94:	8082                	ret

0000000000004a96 <strchr>:

char*
strchr(const char *s, char c)
{
    4a96:	1141                	addi	sp,sp,-16
    4a98:	e422                	sd	s0,8(sp)
    4a9a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4a9c:	00054783          	lbu	a5,0(a0)
    4aa0:	cb99                	beqz	a5,4ab6 <strchr+0x20>
    if(*s == c)
    4aa2:	00f58763          	beq	a1,a5,4ab0 <strchr+0x1a>
  for(; *s; s++)
    4aa6:	0505                	addi	a0,a0,1
    4aa8:	00054783          	lbu	a5,0(a0)
    4aac:	fbfd                	bnez	a5,4aa2 <strchr+0xc>
      return (char*)s;
  return 0;
    4aae:	4501                	li	a0,0
}
    4ab0:	6422                	ld	s0,8(sp)
    4ab2:	0141                	addi	sp,sp,16
    4ab4:	8082                	ret
  return 0;
    4ab6:	4501                	li	a0,0
    4ab8:	bfe5                	j	4ab0 <strchr+0x1a>

0000000000004aba <gets>:

char*
gets(char *buf, int max)
{
    4aba:	711d                	addi	sp,sp,-96
    4abc:	ec86                	sd	ra,88(sp)
    4abe:	e8a2                	sd	s0,80(sp)
    4ac0:	e4a6                	sd	s1,72(sp)
    4ac2:	e0ca                	sd	s2,64(sp)
    4ac4:	fc4e                	sd	s3,56(sp)
    4ac6:	f852                	sd	s4,48(sp)
    4ac8:	f456                	sd	s5,40(sp)
    4aca:	f05a                	sd	s6,32(sp)
    4acc:	ec5e                	sd	s7,24(sp)
    4ace:	1080                	addi	s0,sp,96
    4ad0:	8baa                	mv	s7,a0
    4ad2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4ad4:	892a                	mv	s2,a0
    4ad6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4ad8:	4aa9                	li	s5,10
    4ada:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4adc:	89a6                	mv	s3,s1
    4ade:	2485                	addiw	s1,s1,1
    4ae0:	0344d663          	bge	s1,s4,4b0c <gets+0x52>
    cc = read(0, &c, 1);
    4ae4:	4605                	li	a2,1
    4ae6:	faf40593          	addi	a1,s0,-81
    4aea:	4501                	li	a0,0
    4aec:	1d2000ef          	jal	4cbe <read>
    if(cc < 1)
    4af0:	00a05e63          	blez	a0,4b0c <gets+0x52>
    buf[i++] = c;
    4af4:	faf44783          	lbu	a5,-81(s0)
    4af8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4afc:	01578763          	beq	a5,s5,4b0a <gets+0x50>
    4b00:	0905                	addi	s2,s2,1
    4b02:	fd679de3          	bne	a5,s6,4adc <gets+0x22>
    buf[i++] = c;
    4b06:	89a6                	mv	s3,s1
    4b08:	a011                	j	4b0c <gets+0x52>
    4b0a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4b0c:	99de                	add	s3,s3,s7
    4b0e:	00098023          	sb	zero,0(s3)
  return buf;
}
    4b12:	855e                	mv	a0,s7
    4b14:	60e6                	ld	ra,88(sp)
    4b16:	6446                	ld	s0,80(sp)
    4b18:	64a6                	ld	s1,72(sp)
    4b1a:	6906                	ld	s2,64(sp)
    4b1c:	79e2                	ld	s3,56(sp)
    4b1e:	7a42                	ld	s4,48(sp)
    4b20:	7aa2                	ld	s5,40(sp)
    4b22:	7b02                	ld	s6,32(sp)
    4b24:	6be2                	ld	s7,24(sp)
    4b26:	6125                	addi	sp,sp,96
    4b28:	8082                	ret

0000000000004b2a <stat>:

int
stat(const char *n, struct stat *st)
{
    4b2a:	1101                	addi	sp,sp,-32
    4b2c:	ec06                	sd	ra,24(sp)
    4b2e:	e822                	sd	s0,16(sp)
    4b30:	e04a                	sd	s2,0(sp)
    4b32:	1000                	addi	s0,sp,32
    4b34:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4b36:	4581                	li	a1,0
    4b38:	1ae000ef          	jal	4ce6 <open>
  if(fd < 0)
    4b3c:	02054263          	bltz	a0,4b60 <stat+0x36>
    4b40:	e426                	sd	s1,8(sp)
    4b42:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4b44:	85ca                	mv	a1,s2
    4b46:	1b8000ef          	jal	4cfe <fstat>
    4b4a:	892a                	mv	s2,a0
  close(fd);
    4b4c:	8526                	mv	a0,s1
    4b4e:	180000ef          	jal	4cce <close>
  return r;
    4b52:	64a2                	ld	s1,8(sp)
}
    4b54:	854a                	mv	a0,s2
    4b56:	60e2                	ld	ra,24(sp)
    4b58:	6442                	ld	s0,16(sp)
    4b5a:	6902                	ld	s2,0(sp)
    4b5c:	6105                	addi	sp,sp,32
    4b5e:	8082                	ret
    return -1;
    4b60:	597d                	li	s2,-1
    4b62:	bfcd                	j	4b54 <stat+0x2a>

0000000000004b64 <atoi>:

int
atoi(const char *s)
{
    4b64:	1141                	addi	sp,sp,-16
    4b66:	e422                	sd	s0,8(sp)
    4b68:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4b6a:	00054683          	lbu	a3,0(a0)
    4b6e:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x30328>
    4b72:	0ff7f793          	zext.b	a5,a5
    4b76:	4625                	li	a2,9
    4b78:	02f66863          	bltu	a2,a5,4ba8 <atoi+0x44>
    4b7c:	872a                	mv	a4,a0
  n = 0;
    4b7e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4b80:	0705                	addi	a4,a4,1 # 1000001 <base+0xff0359>
    4b82:	0025179b          	slliw	a5,a0,0x2
    4b86:	9fa9                	addw	a5,a5,a0
    4b88:	0017979b          	slliw	a5,a5,0x1
    4b8c:	9fb5                	addw	a5,a5,a3
    4b8e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4b92:	00074683          	lbu	a3,0(a4)
    4b96:	fd06879b          	addiw	a5,a3,-48
    4b9a:	0ff7f793          	zext.b	a5,a5
    4b9e:	fef671e3          	bgeu	a2,a5,4b80 <atoi+0x1c>
  return n;
}
    4ba2:	6422                	ld	s0,8(sp)
    4ba4:	0141                	addi	sp,sp,16
    4ba6:	8082                	ret
  n = 0;
    4ba8:	4501                	li	a0,0
    4baa:	bfe5                	j	4ba2 <atoi+0x3e>

0000000000004bac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4bac:	1141                	addi	sp,sp,-16
    4bae:	e422                	sd	s0,8(sp)
    4bb0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4bb2:	02b57463          	bgeu	a0,a1,4bda <memmove+0x2e>
    while(n-- > 0)
    4bb6:	00c05f63          	blez	a2,4bd4 <memmove+0x28>
    4bba:	1602                	slli	a2,a2,0x20
    4bbc:	9201                	srli	a2,a2,0x20
    4bbe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4bc2:	872a                	mv	a4,a0
      *dst++ = *src++;
    4bc4:	0585                	addi	a1,a1,1
    4bc6:	0705                	addi	a4,a4,1
    4bc8:	fff5c683          	lbu	a3,-1(a1)
    4bcc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4bd0:	fef71ae3          	bne	a4,a5,4bc4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4bd4:	6422                	ld	s0,8(sp)
    4bd6:	0141                	addi	sp,sp,16
    4bd8:	8082                	ret
    dst += n;
    4bda:	00c50733          	add	a4,a0,a2
    src += n;
    4bde:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4be0:	fec05ae3          	blez	a2,4bd4 <memmove+0x28>
    4be4:	fff6079b          	addiw	a5,a2,-1
    4be8:	1782                	slli	a5,a5,0x20
    4bea:	9381                	srli	a5,a5,0x20
    4bec:	fff7c793          	not	a5,a5
    4bf0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4bf2:	15fd                	addi	a1,a1,-1
    4bf4:	177d                	addi	a4,a4,-1
    4bf6:	0005c683          	lbu	a3,0(a1)
    4bfa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4bfe:	fee79ae3          	bne	a5,a4,4bf2 <memmove+0x46>
    4c02:	bfc9                	j	4bd4 <memmove+0x28>

0000000000004c04 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4c04:	1141                	addi	sp,sp,-16
    4c06:	e422                	sd	s0,8(sp)
    4c08:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4c0a:	ca05                	beqz	a2,4c3a <memcmp+0x36>
    4c0c:	fff6069b          	addiw	a3,a2,-1
    4c10:	1682                	slli	a3,a3,0x20
    4c12:	9281                	srli	a3,a3,0x20
    4c14:	0685                	addi	a3,a3,1
    4c16:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4c18:	00054783          	lbu	a5,0(a0)
    4c1c:	0005c703          	lbu	a4,0(a1)
    4c20:	00e79863          	bne	a5,a4,4c30 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4c24:	0505                	addi	a0,a0,1
    p2++;
    4c26:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4c28:	fed518e3          	bne	a0,a3,4c18 <memcmp+0x14>
  }
  return 0;
    4c2c:	4501                	li	a0,0
    4c2e:	a019                	j	4c34 <memcmp+0x30>
      return *p1 - *p2;
    4c30:	40e7853b          	subw	a0,a5,a4
}
    4c34:	6422                	ld	s0,8(sp)
    4c36:	0141                	addi	sp,sp,16
    4c38:	8082                	ret
  return 0;
    4c3a:	4501                	li	a0,0
    4c3c:	bfe5                	j	4c34 <memcmp+0x30>

0000000000004c3e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4c3e:	1141                	addi	sp,sp,-16
    4c40:	e406                	sd	ra,8(sp)
    4c42:	e022                	sd	s0,0(sp)
    4c44:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4c46:	f67ff0ef          	jal	4bac <memmove>
}
    4c4a:	60a2                	ld	ra,8(sp)
    4c4c:	6402                	ld	s0,0(sp)
    4c4e:	0141                	addi	sp,sp,16
    4c50:	8082                	ret

0000000000004c52 <sbrk>:

char *
sbrk(int n) {
    4c52:	1141                	addi	sp,sp,-16
    4c54:	e406                	sd	ra,8(sp)
    4c56:	e022                	sd	s0,0(sp)
    4c58:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4c5a:	4585                	li	a1,1
    4c5c:	0d2000ef          	jal	4d2e <sys_sbrk>
}
    4c60:	60a2                	ld	ra,8(sp)
    4c62:	6402                	ld	s0,0(sp)
    4c64:	0141                	addi	sp,sp,16
    4c66:	8082                	ret

0000000000004c68 <sbrklazy>:

char *
sbrklazy(int n) {
    4c68:	1141                	addi	sp,sp,-16
    4c6a:	e406                	sd	ra,8(sp)
    4c6c:	e022                	sd	s0,0(sp)
    4c6e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4c70:	4589                	li	a1,2
    4c72:	0bc000ef          	jal	4d2e <sys_sbrk>
}
    4c76:	60a2                	ld	ra,8(sp)
    4c78:	6402                	ld	s0,0(sp)
    4c7a:	0141                	addi	sp,sp,16
    4c7c:	8082                	ret

0000000000004c7e <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
    4c7e:	48e5                	li	a7,25
 ecall
    4c80:	00000073          	ecall
 ret
    4c84:	8082                	ret

0000000000004c86 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
    4c86:	48e1                	li	a7,24
 ecall
    4c88:	00000073          	ecall
 ret
    4c8c:	8082                	ret

0000000000004c8e <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
    4c8e:	48dd                	li	a7,23
 ecall
    4c90:	00000073          	ecall
 ret
    4c94:	8082                	ret

0000000000004c96 <trace>:
.global trace
trace:
 li a7, SYS_trace
    4c96:	48d9                	li	a7,22
 ecall
    4c98:	00000073          	ecall
 ret
    4c9c:	8082                	ret

0000000000004c9e <fork>:
.global fork
fork:
 li a7, SYS_fork
    4c9e:	4885                	li	a7,1
 ecall
    4ca0:	00000073          	ecall
 ret
    4ca4:	8082                	ret

0000000000004ca6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4ca6:	4889                	li	a7,2
 ecall
    4ca8:	00000073          	ecall
 ret
    4cac:	8082                	ret

0000000000004cae <wait>:
.global wait
wait:
 li a7, SYS_wait
    4cae:	488d                	li	a7,3
 ecall
    4cb0:	00000073          	ecall
 ret
    4cb4:	8082                	ret

0000000000004cb6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4cb6:	4891                	li	a7,4
 ecall
    4cb8:	00000073          	ecall
 ret
    4cbc:	8082                	ret

0000000000004cbe <read>:
.global read
read:
 li a7, SYS_read
    4cbe:	4895                	li	a7,5
 ecall
    4cc0:	00000073          	ecall
 ret
    4cc4:	8082                	ret

0000000000004cc6 <write>:
.global write
write:
 li a7, SYS_write
    4cc6:	48c1                	li	a7,16
 ecall
    4cc8:	00000073          	ecall
 ret
    4ccc:	8082                	ret

0000000000004cce <close>:
.global close
close:
 li a7, SYS_close
    4cce:	48d5                	li	a7,21
 ecall
    4cd0:	00000073          	ecall
 ret
    4cd4:	8082                	ret

0000000000004cd6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4cd6:	4899                	li	a7,6
 ecall
    4cd8:	00000073          	ecall
 ret
    4cdc:	8082                	ret

0000000000004cde <exec>:
.global exec
exec:
 li a7, SYS_exec
    4cde:	489d                	li	a7,7
 ecall
    4ce0:	00000073          	ecall
 ret
    4ce4:	8082                	ret

0000000000004ce6 <open>:
.global open
open:
 li a7, SYS_open
    4ce6:	48bd                	li	a7,15
 ecall
    4ce8:	00000073          	ecall
 ret
    4cec:	8082                	ret

0000000000004cee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4cee:	48c5                	li	a7,17
 ecall
    4cf0:	00000073          	ecall
 ret
    4cf4:	8082                	ret

0000000000004cf6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4cf6:	48c9                	li	a7,18
 ecall
    4cf8:	00000073          	ecall
 ret
    4cfc:	8082                	ret

0000000000004cfe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4cfe:	48a1                	li	a7,8
 ecall
    4d00:	00000073          	ecall
 ret
    4d04:	8082                	ret

0000000000004d06 <link>:
.global link
link:
 li a7, SYS_link
    4d06:	48cd                	li	a7,19
 ecall
    4d08:	00000073          	ecall
 ret
    4d0c:	8082                	ret

0000000000004d0e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4d0e:	48d1                	li	a7,20
 ecall
    4d10:	00000073          	ecall
 ret
    4d14:	8082                	ret

0000000000004d16 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4d16:	48a5                	li	a7,9
 ecall
    4d18:	00000073          	ecall
 ret
    4d1c:	8082                	ret

0000000000004d1e <dup>:
.global dup
dup:
 li a7, SYS_dup
    4d1e:	48a9                	li	a7,10
 ecall
    4d20:	00000073          	ecall
 ret
    4d24:	8082                	ret

0000000000004d26 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4d26:	48ad                	li	a7,11
 ecall
    4d28:	00000073          	ecall
 ret
    4d2c:	8082                	ret

0000000000004d2e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4d2e:	48b1                	li	a7,12
 ecall
    4d30:	00000073          	ecall
 ret
    4d34:	8082                	ret

0000000000004d36 <pause>:
.global pause
pause:
 li a7, SYS_pause
    4d36:	48b5                	li	a7,13
 ecall
    4d38:	00000073          	ecall
 ret
    4d3c:	8082                	ret

0000000000004d3e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4d3e:	48b9                	li	a7,14
 ecall
    4d40:	00000073          	ecall
 ret
    4d44:	8082                	ret

0000000000004d46 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4d46:	1101                	addi	sp,sp,-32
    4d48:	ec06                	sd	ra,24(sp)
    4d4a:	e822                	sd	s0,16(sp)
    4d4c:	1000                	addi	s0,sp,32
    4d4e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4d52:	4605                	li	a2,1
    4d54:	fef40593          	addi	a1,s0,-17
    4d58:	f6fff0ef          	jal	4cc6 <write>
}
    4d5c:	60e2                	ld	ra,24(sp)
    4d5e:	6442                	ld	s0,16(sp)
    4d60:	6105                	addi	sp,sp,32
    4d62:	8082                	ret

0000000000004d64 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4d64:	715d                	addi	sp,sp,-80
    4d66:	e486                	sd	ra,72(sp)
    4d68:	e0a2                	sd	s0,64(sp)
    4d6a:	fc26                	sd	s1,56(sp)
    4d6c:	0880                	addi	s0,sp,80
    4d6e:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4d70:	c299                	beqz	a3,4d76 <printint+0x12>
    4d72:	0805c963          	bltz	a1,4e04 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4d76:	2581                	sext.w	a1,a1
  neg = 0;
    4d78:	4881                	li	a7,0
    4d7a:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
    4d7e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4d80:	2601                	sext.w	a2,a2
    4d82:	00003517          	auipc	a0,0x3
    4d86:	a3e50513          	addi	a0,a0,-1474 # 77c0 <digits>
    4d8a:	883a                	mv	a6,a4
    4d8c:	2705                	addiw	a4,a4,1
    4d8e:	02c5f7bb          	remuw	a5,a1,a2
    4d92:	1782                	slli	a5,a5,0x20
    4d94:	9381                	srli	a5,a5,0x20
    4d96:	97aa                	add	a5,a5,a0
    4d98:	0007c783          	lbu	a5,0(a5)
    4d9c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4da0:	0005879b          	sext.w	a5,a1
    4da4:	02c5d5bb          	divuw	a1,a1,a2
    4da8:	0685                	addi	a3,a3,1
    4daa:	fec7f0e3          	bgeu	a5,a2,4d8a <printint+0x26>
  if(neg)
    4dae:	00088c63          	beqz	a7,4dc6 <printint+0x62>
    buf[i++] = '-';
    4db2:	fd070793          	addi	a5,a4,-48
    4db6:	00878733          	add	a4,a5,s0
    4dba:	02d00793          	li	a5,45
    4dbe:	fef70423          	sb	a5,-24(a4)
    4dc2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4dc6:	02e05a63          	blez	a4,4dfa <printint+0x96>
    4dca:	f84a                	sd	s2,48(sp)
    4dcc:	f44e                	sd	s3,40(sp)
    4dce:	fb840793          	addi	a5,s0,-72
    4dd2:	00e78933          	add	s2,a5,a4
    4dd6:	fff78993          	addi	s3,a5,-1
    4dda:	99ba                	add	s3,s3,a4
    4ddc:	377d                	addiw	a4,a4,-1
    4dde:	1702                	slli	a4,a4,0x20
    4de0:	9301                	srli	a4,a4,0x20
    4de2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4de6:	fff94583          	lbu	a1,-1(s2)
    4dea:	8526                	mv	a0,s1
    4dec:	f5bff0ef          	jal	4d46 <putc>
  while(--i >= 0)
    4df0:	197d                	addi	s2,s2,-1
    4df2:	ff391ae3          	bne	s2,s3,4de6 <printint+0x82>
    4df6:	7942                	ld	s2,48(sp)
    4df8:	79a2                	ld	s3,40(sp)
}
    4dfa:	60a6                	ld	ra,72(sp)
    4dfc:	6406                	ld	s0,64(sp)
    4dfe:	74e2                	ld	s1,56(sp)
    4e00:	6161                	addi	sp,sp,80
    4e02:	8082                	ret
    x = -xx;
    4e04:	40b005bb          	negw	a1,a1
    neg = 1;
    4e08:	4885                	li	a7,1
    x = -xx;
    4e0a:	bf85                	j	4d7a <printint+0x16>

0000000000004e0c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4e0c:	711d                	addi	sp,sp,-96
    4e0e:	ec86                	sd	ra,88(sp)
    4e10:	e8a2                	sd	s0,80(sp)
    4e12:	e0ca                	sd	s2,64(sp)
    4e14:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4e16:	0005c903          	lbu	s2,0(a1)
    4e1a:	28090663          	beqz	s2,50a6 <vprintf+0x29a>
    4e1e:	e4a6                	sd	s1,72(sp)
    4e20:	fc4e                	sd	s3,56(sp)
    4e22:	f852                	sd	s4,48(sp)
    4e24:	f456                	sd	s5,40(sp)
    4e26:	f05a                	sd	s6,32(sp)
    4e28:	ec5e                	sd	s7,24(sp)
    4e2a:	e862                	sd	s8,16(sp)
    4e2c:	e466                	sd	s9,8(sp)
    4e2e:	8b2a                	mv	s6,a0
    4e30:	8a2e                	mv	s4,a1
    4e32:	8bb2                	mv	s7,a2
  state = 0;
    4e34:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4e36:	4481                	li	s1,0
    4e38:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4e3a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4e3e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4e42:	06c00c93          	li	s9,108
    4e46:	a005                	j	4e66 <vprintf+0x5a>
        putc(fd, c0);
    4e48:	85ca                	mv	a1,s2
    4e4a:	855a                	mv	a0,s6
    4e4c:	efbff0ef          	jal	4d46 <putc>
    4e50:	a019                	j	4e56 <vprintf+0x4a>
    } else if(state == '%'){
    4e52:	03598263          	beq	s3,s5,4e76 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4e56:	2485                	addiw	s1,s1,1
    4e58:	8726                	mv	a4,s1
    4e5a:	009a07b3          	add	a5,s4,s1
    4e5e:	0007c903          	lbu	s2,0(a5)
    4e62:	22090a63          	beqz	s2,5096 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
    4e66:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4e6a:	fe0994e3          	bnez	s3,4e52 <vprintf+0x46>
      if(c0 == '%'){
    4e6e:	fd579de3          	bne	a5,s5,4e48 <vprintf+0x3c>
        state = '%';
    4e72:	89be                	mv	s3,a5
    4e74:	b7cd                	j	4e56 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4e76:	00ea06b3          	add	a3,s4,a4
    4e7a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4e7e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4e80:	c681                	beqz	a3,4e88 <vprintf+0x7c>
    4e82:	9752                	add	a4,a4,s4
    4e84:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4e88:	05878363          	beq	a5,s8,4ece <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
    4e8c:	05978d63          	beq	a5,s9,4ee6 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4e90:	07500713          	li	a4,117
    4e94:	0ee78763          	beq	a5,a4,4f82 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4e98:	07800713          	li	a4,120
    4e9c:	12e78963          	beq	a5,a4,4fce <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4ea0:	07000713          	li	a4,112
    4ea4:	14e78e63          	beq	a5,a4,5000 <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
    4ea8:	06300713          	li	a4,99
    4eac:	18e78e63          	beq	a5,a4,5048 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
    4eb0:	07300713          	li	a4,115
    4eb4:	1ae78463          	beq	a5,a4,505c <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4eb8:	02500713          	li	a4,37
    4ebc:	04e79563          	bne	a5,a4,4f06 <vprintf+0xfa>
        putc(fd, '%');
    4ec0:	02500593          	li	a1,37
    4ec4:	855a                	mv	a0,s6
    4ec6:	e81ff0ef          	jal	4d46 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    4eca:	4981                	li	s3,0
    4ecc:	b769                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4ece:	008b8913          	addi	s2,s7,8
    4ed2:	4685                	li	a3,1
    4ed4:	4629                	li	a2,10
    4ed6:	000ba583          	lw	a1,0(s7)
    4eda:	855a                	mv	a0,s6
    4edc:	e89ff0ef          	jal	4d64 <printint>
    4ee0:	8bca                	mv	s7,s2
      state = 0;
    4ee2:	4981                	li	s3,0
    4ee4:	bf8d                	j	4e56 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4ee6:	06400793          	li	a5,100
    4eea:	02f68963          	beq	a3,a5,4f1c <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4eee:	06c00793          	li	a5,108
    4ef2:	04f68263          	beq	a3,a5,4f36 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
    4ef6:	07500793          	li	a5,117
    4efa:	0af68063          	beq	a3,a5,4f9a <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
    4efe:	07800793          	li	a5,120
    4f02:	0ef68263          	beq	a3,a5,4fe6 <vprintf+0x1da>
        putc(fd, '%');
    4f06:	02500593          	li	a1,37
    4f0a:	855a                	mv	a0,s6
    4f0c:	e3bff0ef          	jal	4d46 <putc>
        putc(fd, c0);
    4f10:	85ca                	mv	a1,s2
    4f12:	855a                	mv	a0,s6
    4f14:	e33ff0ef          	jal	4d46 <putc>
      state = 0;
    4f18:	4981                	li	s3,0
    4f1a:	bf35                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f1c:	008b8913          	addi	s2,s7,8
    4f20:	4685                	li	a3,1
    4f22:	4629                	li	a2,10
    4f24:	000bb583          	ld	a1,0(s7)
    4f28:	855a                	mv	a0,s6
    4f2a:	e3bff0ef          	jal	4d64 <printint>
        i += 1;
    4f2e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f30:	8bca                	mv	s7,s2
      state = 0;
    4f32:	4981                	li	s3,0
        i += 1;
    4f34:	b70d                	j	4e56 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f36:	06400793          	li	a5,100
    4f3a:	02f60763          	beq	a2,a5,4f68 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4f3e:	07500793          	li	a5,117
    4f42:	06f60963          	beq	a2,a5,4fb4 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4f46:	07800793          	li	a5,120
    4f4a:	faf61ee3          	bne	a2,a5,4f06 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f4e:	008b8913          	addi	s2,s7,8
    4f52:	4681                	li	a3,0
    4f54:	4641                	li	a2,16
    4f56:	000bb583          	ld	a1,0(s7)
    4f5a:	855a                	mv	a0,s6
    4f5c:	e09ff0ef          	jal	4d64 <printint>
        i += 2;
    4f60:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f62:	8bca                	mv	s7,s2
      state = 0;
    4f64:	4981                	li	s3,0
        i += 2;
    4f66:	bdc5                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f68:	008b8913          	addi	s2,s7,8
    4f6c:	4685                	li	a3,1
    4f6e:	4629                	li	a2,10
    4f70:	000bb583          	ld	a1,0(s7)
    4f74:	855a                	mv	a0,s6
    4f76:	defff0ef          	jal	4d64 <printint>
        i += 2;
    4f7a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f7c:	8bca                	mv	s7,s2
      state = 0;
    4f7e:	4981                	li	s3,0
        i += 2;
    4f80:	bdd9                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
    4f82:	008b8913          	addi	s2,s7,8
    4f86:	4681                	li	a3,0
    4f88:	4629                	li	a2,10
    4f8a:	000be583          	lwu	a1,0(s7)
    4f8e:	855a                	mv	a0,s6
    4f90:	dd5ff0ef          	jal	4d64 <printint>
    4f94:	8bca                	mv	s7,s2
      state = 0;
    4f96:	4981                	li	s3,0
    4f98:	bd7d                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4f9a:	008b8913          	addi	s2,s7,8
    4f9e:	4681                	li	a3,0
    4fa0:	4629                	li	a2,10
    4fa2:	000bb583          	ld	a1,0(s7)
    4fa6:	855a                	mv	a0,s6
    4fa8:	dbdff0ef          	jal	4d64 <printint>
        i += 1;
    4fac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4fae:	8bca                	mv	s7,s2
      state = 0;
    4fb0:	4981                	li	s3,0
        i += 1;
    4fb2:	b555                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4fb4:	008b8913          	addi	s2,s7,8
    4fb8:	4681                	li	a3,0
    4fba:	4629                	li	a2,10
    4fbc:	000bb583          	ld	a1,0(s7)
    4fc0:	855a                	mv	a0,s6
    4fc2:	da3ff0ef          	jal	4d64 <printint>
        i += 2;
    4fc6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4fc8:	8bca                	mv	s7,s2
      state = 0;
    4fca:	4981                	li	s3,0
        i += 2;
    4fcc:	b569                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
    4fce:	008b8913          	addi	s2,s7,8
    4fd2:	4681                	li	a3,0
    4fd4:	4641                	li	a2,16
    4fd6:	000be583          	lwu	a1,0(s7)
    4fda:	855a                	mv	a0,s6
    4fdc:	d89ff0ef          	jal	4d64 <printint>
    4fe0:	8bca                	mv	s7,s2
      state = 0;
    4fe2:	4981                	li	s3,0
    4fe4:	bd8d                	j	4e56 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fe6:	008b8913          	addi	s2,s7,8
    4fea:	4681                	li	a3,0
    4fec:	4641                	li	a2,16
    4fee:	000bb583          	ld	a1,0(s7)
    4ff2:	855a                	mv	a0,s6
    4ff4:	d71ff0ef          	jal	4d64 <printint>
        i += 1;
    4ff8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4ffa:	8bca                	mv	s7,s2
      state = 0;
    4ffc:	4981                	li	s3,0
        i += 1;
    4ffe:	bda1                	j	4e56 <vprintf+0x4a>
    5000:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5002:	008b8d13          	addi	s10,s7,8
    5006:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    500a:	03000593          	li	a1,48
    500e:	855a                	mv	a0,s6
    5010:	d37ff0ef          	jal	4d46 <putc>
  putc(fd, 'x');
    5014:	07800593          	li	a1,120
    5018:	855a                	mv	a0,s6
    501a:	d2dff0ef          	jal	4d46 <putc>
    501e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5020:	00002b97          	auipc	s7,0x2
    5024:	7a0b8b93          	addi	s7,s7,1952 # 77c0 <digits>
    5028:	03c9d793          	srli	a5,s3,0x3c
    502c:	97de                	add	a5,a5,s7
    502e:	0007c583          	lbu	a1,0(a5)
    5032:	855a                	mv	a0,s6
    5034:	d13ff0ef          	jal	4d46 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5038:	0992                	slli	s3,s3,0x4
    503a:	397d                	addiw	s2,s2,-1
    503c:	fe0916e3          	bnez	s2,5028 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
    5040:	8bea                	mv	s7,s10
      state = 0;
    5042:	4981                	li	s3,0
    5044:	6d02                	ld	s10,0(sp)
    5046:	bd01                	j	4e56 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
    5048:	008b8913          	addi	s2,s7,8
    504c:	000bc583          	lbu	a1,0(s7)
    5050:	855a                	mv	a0,s6
    5052:	cf5ff0ef          	jal	4d46 <putc>
    5056:	8bca                	mv	s7,s2
      state = 0;
    5058:	4981                	li	s3,0
    505a:	bbf5                	j	4e56 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    505c:	008b8993          	addi	s3,s7,8
    5060:	000bb903          	ld	s2,0(s7)
    5064:	00090f63          	beqz	s2,5082 <vprintf+0x276>
        for(; *s; s++)
    5068:	00094583          	lbu	a1,0(s2)
    506c:	c195                	beqz	a1,5090 <vprintf+0x284>
          putc(fd, *s);
    506e:	855a                	mv	a0,s6
    5070:	cd7ff0ef          	jal	4d46 <putc>
        for(; *s; s++)
    5074:	0905                	addi	s2,s2,1
    5076:	00094583          	lbu	a1,0(s2)
    507a:	f9f5                	bnez	a1,506e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    507c:	8bce                	mv	s7,s3
      state = 0;
    507e:	4981                	li	s3,0
    5080:	bbd9                	j	4e56 <vprintf+0x4a>
          s = "(null)";
    5082:	00002917          	auipc	s2,0x2
    5086:	68e90913          	addi	s2,s2,1678 # 7710 <malloc+0x2582>
        for(; *s; s++)
    508a:	02800593          	li	a1,40
    508e:	b7c5                	j	506e <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
    5090:	8bce                	mv	s7,s3
      state = 0;
    5092:	4981                	li	s3,0
    5094:	b3c9                	j	4e56 <vprintf+0x4a>
    5096:	64a6                	ld	s1,72(sp)
    5098:	79e2                	ld	s3,56(sp)
    509a:	7a42                	ld	s4,48(sp)
    509c:	7aa2                	ld	s5,40(sp)
    509e:	7b02                	ld	s6,32(sp)
    50a0:	6be2                	ld	s7,24(sp)
    50a2:	6c42                	ld	s8,16(sp)
    50a4:	6ca2                	ld	s9,8(sp)
    }
  }
}
    50a6:	60e6                	ld	ra,88(sp)
    50a8:	6446                	ld	s0,80(sp)
    50aa:	6906                	ld	s2,64(sp)
    50ac:	6125                	addi	sp,sp,96
    50ae:	8082                	ret

00000000000050b0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    50b0:	715d                	addi	sp,sp,-80
    50b2:	ec06                	sd	ra,24(sp)
    50b4:	e822                	sd	s0,16(sp)
    50b6:	1000                	addi	s0,sp,32
    50b8:	e010                	sd	a2,0(s0)
    50ba:	e414                	sd	a3,8(s0)
    50bc:	e818                	sd	a4,16(s0)
    50be:	ec1c                	sd	a5,24(s0)
    50c0:	03043023          	sd	a6,32(s0)
    50c4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    50c8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    50cc:	8622                	mv	a2,s0
    50ce:	d3fff0ef          	jal	4e0c <vprintf>
}
    50d2:	60e2                	ld	ra,24(sp)
    50d4:	6442                	ld	s0,16(sp)
    50d6:	6161                	addi	sp,sp,80
    50d8:	8082                	ret

00000000000050da <printf>:

void
printf(const char *fmt, ...)
{
    50da:	711d                	addi	sp,sp,-96
    50dc:	ec06                	sd	ra,24(sp)
    50de:	e822                	sd	s0,16(sp)
    50e0:	1000                	addi	s0,sp,32
    50e2:	e40c                	sd	a1,8(s0)
    50e4:	e810                	sd	a2,16(s0)
    50e6:	ec14                	sd	a3,24(s0)
    50e8:	f018                	sd	a4,32(s0)
    50ea:	f41c                	sd	a5,40(s0)
    50ec:	03043823          	sd	a6,48(s0)
    50f0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    50f4:	00840613          	addi	a2,s0,8
    50f8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    50fc:	85aa                	mv	a1,a0
    50fe:	4505                	li	a0,1
    5100:	d0dff0ef          	jal	4e0c <vprintf>
}
    5104:	60e2                	ld	ra,24(sp)
    5106:	6442                	ld	s0,16(sp)
    5108:	6125                	addi	sp,sp,96
    510a:	8082                	ret

000000000000510c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    510c:	1141                	addi	sp,sp,-16
    510e:	e422                	sd	s0,8(sp)
    5110:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5112:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5116:	00004797          	auipc	a5,0x4
    511a:	36a7b783          	ld	a5,874(a5) # 9480 <freep>
    511e:	a02d                	j	5148 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5120:	4618                	lw	a4,8(a2)
    5122:	9f2d                	addw	a4,a4,a1
    5124:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5128:	6398                	ld	a4,0(a5)
    512a:	6310                	ld	a2,0(a4)
    512c:	a83d                	j	516a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    512e:	ff852703          	lw	a4,-8(a0)
    5132:	9f31                	addw	a4,a4,a2
    5134:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5136:	ff053683          	ld	a3,-16(a0)
    513a:	a091                	j	517e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    513c:	6398                	ld	a4,0(a5)
    513e:	00e7e463          	bltu	a5,a4,5146 <free+0x3a>
    5142:	00e6ea63          	bltu	a3,a4,5156 <free+0x4a>
{
    5146:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5148:	fed7fae3          	bgeu	a5,a3,513c <free+0x30>
    514c:	6398                	ld	a4,0(a5)
    514e:	00e6e463          	bltu	a3,a4,5156 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5152:	fee7eae3          	bltu	a5,a4,5146 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5156:	ff852583          	lw	a1,-8(a0)
    515a:	6390                	ld	a2,0(a5)
    515c:	02059813          	slli	a6,a1,0x20
    5160:	01c85713          	srli	a4,a6,0x1c
    5164:	9736                	add	a4,a4,a3
    5166:	fae60de3          	beq	a2,a4,5120 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    516a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    516e:	4790                	lw	a2,8(a5)
    5170:	02061593          	slli	a1,a2,0x20
    5174:	01c5d713          	srli	a4,a1,0x1c
    5178:	973e                	add	a4,a4,a5
    517a:	fae68ae3          	beq	a3,a4,512e <free+0x22>
    p->s.ptr = bp->s.ptr;
    517e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5180:	00004717          	auipc	a4,0x4
    5184:	30f73023          	sd	a5,768(a4) # 9480 <freep>
}
    5188:	6422                	ld	s0,8(sp)
    518a:	0141                	addi	sp,sp,16
    518c:	8082                	ret

000000000000518e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    518e:	7139                	addi	sp,sp,-64
    5190:	fc06                	sd	ra,56(sp)
    5192:	f822                	sd	s0,48(sp)
    5194:	f426                	sd	s1,40(sp)
    5196:	ec4e                	sd	s3,24(sp)
    5198:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    519a:	02051493          	slli	s1,a0,0x20
    519e:	9081                	srli	s1,s1,0x20
    51a0:	04bd                	addi	s1,s1,15
    51a2:	8091                	srli	s1,s1,0x4
    51a4:	0014899b          	addiw	s3,s1,1
    51a8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    51aa:	00004517          	auipc	a0,0x4
    51ae:	2d653503          	ld	a0,726(a0) # 9480 <freep>
    51b2:	c915                	beqz	a0,51e6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    51b4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    51b6:	4798                	lw	a4,8(a5)
    51b8:	08977a63          	bgeu	a4,s1,524c <malloc+0xbe>
    51bc:	f04a                	sd	s2,32(sp)
    51be:	e852                	sd	s4,16(sp)
    51c0:	e456                	sd	s5,8(sp)
    51c2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    51c4:	8a4e                	mv	s4,s3
    51c6:	0009871b          	sext.w	a4,s3
    51ca:	6685                	lui	a3,0x1
    51cc:	00d77363          	bgeu	a4,a3,51d2 <malloc+0x44>
    51d0:	6a05                	lui	s4,0x1
    51d2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    51d6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    51da:	00004917          	auipc	s2,0x4
    51de:	2a690913          	addi	s2,s2,678 # 9480 <freep>
  if(p == SBRK_ERROR)
    51e2:	5afd                	li	s5,-1
    51e4:	a081                	j	5224 <malloc+0x96>
    51e6:	f04a                	sd	s2,32(sp)
    51e8:	e852                	sd	s4,16(sp)
    51ea:	e456                	sd	s5,8(sp)
    51ec:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    51ee:	0000b797          	auipc	a5,0xb
    51f2:	aba78793          	addi	a5,a5,-1350 # fca8 <base>
    51f6:	00004717          	auipc	a4,0x4
    51fa:	28f73523          	sd	a5,650(a4) # 9480 <freep>
    51fe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5200:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5204:	b7c1                	j	51c4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    5206:	6398                	ld	a4,0(a5)
    5208:	e118                	sd	a4,0(a0)
    520a:	a8a9                	j	5264 <malloc+0xd6>
  hp->s.size = nu;
    520c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5210:	0541                	addi	a0,a0,16
    5212:	efbff0ef          	jal	510c <free>
  return freep;
    5216:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    521a:	c12d                	beqz	a0,527c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    521c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    521e:	4798                	lw	a4,8(a5)
    5220:	02977263          	bgeu	a4,s1,5244 <malloc+0xb6>
    if(p == freep)
    5224:	00093703          	ld	a4,0(s2)
    5228:	853e                	mv	a0,a5
    522a:	fef719e3          	bne	a4,a5,521c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    522e:	8552                	mv	a0,s4
    5230:	a23ff0ef          	jal	4c52 <sbrk>
  if(p == SBRK_ERROR)
    5234:	fd551ce3          	bne	a0,s5,520c <malloc+0x7e>
        return 0;
    5238:	4501                	li	a0,0
    523a:	7902                	ld	s2,32(sp)
    523c:	6a42                	ld	s4,16(sp)
    523e:	6aa2                	ld	s5,8(sp)
    5240:	6b02                	ld	s6,0(sp)
    5242:	a03d                	j	5270 <malloc+0xe2>
    5244:	7902                	ld	s2,32(sp)
    5246:	6a42                	ld	s4,16(sp)
    5248:	6aa2                	ld	s5,8(sp)
    524a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    524c:	fae48de3          	beq	s1,a4,5206 <malloc+0x78>
        p->s.size -= nunits;
    5250:	4137073b          	subw	a4,a4,s3
    5254:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5256:	02071693          	slli	a3,a4,0x20
    525a:	01c6d713          	srli	a4,a3,0x1c
    525e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5260:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5264:	00004717          	auipc	a4,0x4
    5268:	20a73e23          	sd	a0,540(a4) # 9480 <freep>
      return (void*)(p + 1);
    526c:	01078513          	addi	a0,a5,16
  }
}
    5270:	70e2                	ld	ra,56(sp)
    5272:	7442                	ld	s0,48(sp)
    5274:	74a2                	ld	s1,40(sp)
    5276:	69e2                	ld	s3,24(sp)
    5278:	6121                	addi	sp,sp,64
    527a:	8082                	ret
    527c:	7902                	ld	s2,32(sp)
    527e:	6a42                	ld	s4,16(sp)
    5280:	6aa2                	ld	s5,8(sp)
    5282:	6b02                	ld	s6,0(sp)
    5284:	b7f5                	j	5270 <malloc+0xe2>
