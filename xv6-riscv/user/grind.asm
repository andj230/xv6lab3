
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	addi	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xori	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	addi	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	addi	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	addi	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	addi	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	addi	a0,a0,-96 # 2000 <rand_next>
      68:	f99ff0ef          	jal	0 <do_rand>
}
      6c:	60a2                	ld	ra,8(sp)
      6e:	6402                	ld	s0,0(sp)
      70:	0141                	addi	sp,sp,16
      72:	8082                	ret

0000000000000074 <go>:

void
go(int which_child)
{
      74:	7159                	addi	sp,sp,-112
      76:	f486                	sd	ra,104(sp)
      78:	f0a2                	sd	s0,96(sp)
      7a:	eca6                	sd	s1,88(sp)
      7c:	fc56                	sd	s5,56(sp)
      7e:	1880                	addi	s0,sp,112
      80:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      82:	4501                	li	a0,0
      84:	2bd000ef          	jal	b40 <sbrk>
      88:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      8a:	00001517          	auipc	a0,0x1
      8e:	0f650513          	addi	a0,a0,246 # 1180 <malloc+0x104>
      92:	36b000ef          	jal	bfc <mkdir>
  if(chdir("grindir") != 0){
      96:	00001517          	auipc	a0,0x1
      9a:	0ea50513          	addi	a0,a0,234 # 1180 <malloc+0x104>
      9e:	367000ef          	jal	c04 <chdir>
      a2:	cd11                	beqz	a0,be <go+0x4a>
      a4:	e8ca                	sd	s2,80(sp)
      a6:	e4ce                	sd	s3,72(sp)
      a8:	e0d2                	sd	s4,64(sp)
      aa:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      ac:	00001517          	auipc	a0,0x1
      b0:	0dc50513          	addi	a0,a0,220 # 1188 <malloc+0x10c>
      b4:	715000ef          	jal	fc8 <printf>
    exit(1);
      b8:	4505                	li	a0,1
      ba:	2db000ef          	jal	b94 <exit>
      be:	e8ca                	sd	s2,80(sp)
      c0:	e4ce                	sd	s3,72(sp)
      c2:	e0d2                	sd	s4,64(sp)
      c4:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      c6:	00001517          	auipc	a0,0x1
      ca:	0ea50513          	addi	a0,a0,234 # 11b0 <malloc+0x134>
      ce:	337000ef          	jal	c04 <chdir>
      d2:	00001997          	auipc	s3,0x1
      d6:	0ee98993          	addi	s3,s3,238 # 11c0 <malloc+0x144>
      da:	c489                	beqz	s1,e4 <go+0x70>
      dc:	00001997          	auipc	s3,0x1
      e0:	0dc98993          	addi	s3,s3,220 # 11b8 <malloc+0x13c>
  uint64 iters = 0;
      e4:	4481                	li	s1,0
  int fd = -1;
      e6:	5a7d                	li	s4,-1
      e8:	00001917          	auipc	s2,0x1
      ec:	3a890913          	addi	s2,s2,936 # 1490 <malloc+0x414>
      f0:	a819                	j	106 <go+0x92>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
      f2:	20200593          	li	a1,514
      f6:	00001517          	auipc	a0,0x1
      fa:	0d250513          	addi	a0,a0,210 # 11c8 <malloc+0x14c>
      fe:	2d7000ef          	jal	bd4 <open>
     102:	2bb000ef          	jal	bbc <close>
    iters++;
     106:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
     108:	1f400793          	li	a5,500
     10c:	02f4f7b3          	remu	a5,s1,a5
     110:	e791                	bnez	a5,11c <go+0xa8>
      write(1, which_child?"B":"A", 1);
     112:	4605                	li	a2,1
     114:	85ce                	mv	a1,s3
     116:	4505                	li	a0,1
     118:	29d000ef          	jal	bb4 <write>
    int what = rand() % 23;
     11c:	f3dff0ef          	jal	58 <rand>
     120:	47dd                	li	a5,23
     122:	02f5653b          	remw	a0,a0,a5
     126:	0005071b          	sext.w	a4,a0
     12a:	47d9                	li	a5,22
     12c:	fce7ede3          	bltu	a5,a4,106 <go+0x92>
     130:	02051793          	slli	a5,a0,0x20
     134:	01e7d513          	srli	a0,a5,0x1e
     138:	954a                	add	a0,a0,s2
     13a:	411c                	lw	a5,0(a0)
     13c:	97ca                	add	a5,a5,s2
     13e:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     140:	20200593          	li	a1,514
     144:	00001517          	auipc	a0,0x1
     148:	09450513          	addi	a0,a0,148 # 11d8 <malloc+0x15c>
     14c:	289000ef          	jal	bd4 <open>
     150:	26d000ef          	jal	bbc <close>
     154:	bf4d                	j	106 <go+0x92>
    } else if(what == 3){
      unlink("grindir/../a");
     156:	00001517          	auipc	a0,0x1
     15a:	07250513          	addi	a0,a0,114 # 11c8 <malloc+0x14c>
     15e:	287000ef          	jal	be4 <unlink>
     162:	b755                	j	106 <go+0x92>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     164:	00001517          	auipc	a0,0x1
     168:	01c50513          	addi	a0,a0,28 # 1180 <malloc+0x104>
     16c:	299000ef          	jal	c04 <chdir>
     170:	ed11                	bnez	a0,18c <go+0x118>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     172:	00001517          	auipc	a0,0x1
     176:	07e50513          	addi	a0,a0,126 # 11f0 <malloc+0x174>
     17a:	26b000ef          	jal	be4 <unlink>
      chdir("/");
     17e:	00001517          	auipc	a0,0x1
     182:	03250513          	addi	a0,a0,50 # 11b0 <malloc+0x134>
     186:	27f000ef          	jal	c04 <chdir>
     18a:	bfb5                	j	106 <go+0x92>
        printf("grind: chdir grindir failed\n");
     18c:	00001517          	auipc	a0,0x1
     190:	ffc50513          	addi	a0,a0,-4 # 1188 <malloc+0x10c>
     194:	635000ef          	jal	fc8 <printf>
        exit(1);
     198:	4505                	li	a0,1
     19a:	1fb000ef          	jal	b94 <exit>
    } else if(what == 5){
      close(fd);
     19e:	8552                	mv	a0,s4
     1a0:	21d000ef          	jal	bbc <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1a4:	20200593          	li	a1,514
     1a8:	00001517          	auipc	a0,0x1
     1ac:	05050513          	addi	a0,a0,80 # 11f8 <malloc+0x17c>
     1b0:	225000ef          	jal	bd4 <open>
     1b4:	8a2a                	mv	s4,a0
     1b6:	bf81                	j	106 <go+0x92>
    } else if(what == 6){
      close(fd);
     1b8:	8552                	mv	a0,s4
     1ba:	203000ef          	jal	bbc <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     1be:	20200593          	li	a1,514
     1c2:	00001517          	auipc	a0,0x1
     1c6:	04650513          	addi	a0,a0,70 # 1208 <malloc+0x18c>
     1ca:	20b000ef          	jal	bd4 <open>
     1ce:	8a2a                	mv	s4,a0
     1d0:	bf1d                	j	106 <go+0x92>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     1d2:	3e700613          	li	a2,999
     1d6:	00002597          	auipc	a1,0x2
     1da:	e4a58593          	addi	a1,a1,-438 # 2020 <buf.0>
     1de:	8552                	mv	a0,s4
     1e0:	1d5000ef          	jal	bb4 <write>
     1e4:	b70d                	j	106 <go+0x92>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     1e6:	3e700613          	li	a2,999
     1ea:	00002597          	auipc	a1,0x2
     1ee:	e3658593          	addi	a1,a1,-458 # 2020 <buf.0>
     1f2:	8552                	mv	a0,s4
     1f4:	1b9000ef          	jal	bac <read>
     1f8:	b739                	j	106 <go+0x92>
    } else if(what == 9){
      mkdir("grindir/../a");
     1fa:	00001517          	auipc	a0,0x1
     1fe:	fce50513          	addi	a0,a0,-50 # 11c8 <malloc+0x14c>
     202:	1fb000ef          	jal	bfc <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     206:	20200593          	li	a1,514
     20a:	00001517          	auipc	a0,0x1
     20e:	01650513          	addi	a0,a0,22 # 1220 <malloc+0x1a4>
     212:	1c3000ef          	jal	bd4 <open>
     216:	1a7000ef          	jal	bbc <close>
      unlink("a/a");
     21a:	00001517          	auipc	a0,0x1
     21e:	01650513          	addi	a0,a0,22 # 1230 <malloc+0x1b4>
     222:	1c3000ef          	jal	be4 <unlink>
     226:	b5c5                	j	106 <go+0x92>
    } else if(what == 10){
      mkdir("/../b");
     228:	00001517          	auipc	a0,0x1
     22c:	01050513          	addi	a0,a0,16 # 1238 <malloc+0x1bc>
     230:	1cd000ef          	jal	bfc <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     234:	20200593          	li	a1,514
     238:	00001517          	auipc	a0,0x1
     23c:	00850513          	addi	a0,a0,8 # 1240 <malloc+0x1c4>
     240:	195000ef          	jal	bd4 <open>
     244:	179000ef          	jal	bbc <close>
      unlink("b/b");
     248:	00001517          	auipc	a0,0x1
     24c:	00850513          	addi	a0,a0,8 # 1250 <malloc+0x1d4>
     250:	195000ef          	jal	be4 <unlink>
     254:	bd4d                	j	106 <go+0x92>
    } else if(what == 11){
      unlink("b");
     256:	00001517          	auipc	a0,0x1
     25a:	00250513          	addi	a0,a0,2 # 1258 <malloc+0x1dc>
     25e:	187000ef          	jal	be4 <unlink>
      link("../grindir/./../a", "../b");
     262:	00001597          	auipc	a1,0x1
     266:	f8e58593          	addi	a1,a1,-114 # 11f0 <malloc+0x174>
     26a:	00001517          	auipc	a0,0x1
     26e:	ff650513          	addi	a0,a0,-10 # 1260 <malloc+0x1e4>
     272:	183000ef          	jal	bf4 <link>
     276:	bd41                	j	106 <go+0x92>
    } else if(what == 12){
      unlink("../grindir/../a");
     278:	00001517          	auipc	a0,0x1
     27c:	00050513          	mv	a0,a0
     280:	165000ef          	jal	be4 <unlink>
      link(".././b", "/grindir/../a");
     284:	00001597          	auipc	a1,0x1
     288:	f7458593          	addi	a1,a1,-140 # 11f8 <malloc+0x17c>
     28c:	00001517          	auipc	a0,0x1
     290:	ffc50513          	addi	a0,a0,-4 # 1288 <malloc+0x20c>
     294:	161000ef          	jal	bf4 <link>
     298:	b5bd                	j	106 <go+0x92>
    } else if(what == 13){
      int pid = fork();
     29a:	0f3000ef          	jal	b8c <fork>
      if(pid == 0){
     29e:	c519                	beqz	a0,2ac <go+0x238>
        exit(0);
      } else if(pid < 0){
     2a0:	00054863          	bltz	a0,2b0 <go+0x23c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2a4:	4501                	li	a0,0
     2a6:	0f7000ef          	jal	b9c <wait>
     2aa:	bdb1                	j	106 <go+0x92>
        exit(0);
     2ac:	0e9000ef          	jal	b94 <exit>
        printf("grind: fork failed\n");
     2b0:	00001517          	auipc	a0,0x1
     2b4:	fe050513          	addi	a0,a0,-32 # 1290 <malloc+0x214>
     2b8:	511000ef          	jal	fc8 <printf>
        exit(1);
     2bc:	4505                	li	a0,1
     2be:	0d7000ef          	jal	b94 <exit>
    } else if(what == 14){
      int pid = fork();
     2c2:	0cb000ef          	jal	b8c <fork>
      if(pid == 0){
     2c6:	c519                	beqz	a0,2d4 <go+0x260>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     2c8:	00054d63          	bltz	a0,2e2 <go+0x26e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     2cc:	4501                	li	a0,0
     2ce:	0cf000ef          	jal	b9c <wait>
     2d2:	bd15                	j	106 <go+0x92>
        fork();
     2d4:	0b9000ef          	jal	b8c <fork>
        fork();
     2d8:	0b5000ef          	jal	b8c <fork>
        exit(0);
     2dc:	4501                	li	a0,0
     2de:	0b7000ef          	jal	b94 <exit>
        printf("grind: fork failed\n");
     2e2:	00001517          	auipc	a0,0x1
     2e6:	fae50513          	addi	a0,a0,-82 # 1290 <malloc+0x214>
     2ea:	4df000ef          	jal	fc8 <printf>
        exit(1);
     2ee:	4505                	li	a0,1
     2f0:	0a5000ef          	jal	b94 <exit>
    } else if(what == 15){
      sbrk(6011);
     2f4:	6505                	lui	a0,0x1
     2f6:	77b50513          	addi	a0,a0,1915 # 177b <digits+0x28b>
     2fa:	047000ef          	jal	b40 <sbrk>
     2fe:	b521                	j	106 <go+0x92>
    } else if(what == 16){
      if(sbrk(0) > break0)
     300:	4501                	li	a0,0
     302:	03f000ef          	jal	b40 <sbrk>
     306:	e0aaf0e3          	bgeu	s5,a0,106 <go+0x92>
        sbrk(-(sbrk(0) - break0));
     30a:	4501                	li	a0,0
     30c:	035000ef          	jal	b40 <sbrk>
     310:	40aa853b          	subw	a0,s5,a0
     314:	02d000ef          	jal	b40 <sbrk>
     318:	b3fd                	j	106 <go+0x92>
    } else if(what == 17){
      int pid = fork();
     31a:	073000ef          	jal	b8c <fork>
     31e:	8b2a                	mv	s6,a0
      if(pid == 0){
     320:	c10d                	beqz	a0,342 <go+0x2ce>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     322:	02054d63          	bltz	a0,35c <go+0x2e8>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     326:	00001517          	auipc	a0,0x1
     32a:	f8a50513          	addi	a0,a0,-118 # 12b0 <malloc+0x234>
     32e:	0d7000ef          	jal	c04 <chdir>
     332:	ed15                	bnez	a0,36e <go+0x2fa>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     334:	855a                	mv	a0,s6
     336:	08f000ef          	jal	bc4 <kill>
      wait(0);
     33a:	4501                	li	a0,0
     33c:	061000ef          	jal	b9c <wait>
     340:	b3d9                	j	106 <go+0x92>
        close(open("a", O_CREATE|O_RDWR));
     342:	20200593          	li	a1,514
     346:	00001517          	auipc	a0,0x1
     34a:	f6250513          	addi	a0,a0,-158 # 12a8 <malloc+0x22c>
     34e:	087000ef          	jal	bd4 <open>
     352:	06b000ef          	jal	bbc <close>
        exit(0);
     356:	4501                	li	a0,0
     358:	03d000ef          	jal	b94 <exit>
        printf("grind: fork failed\n");
     35c:	00001517          	auipc	a0,0x1
     360:	f3450513          	addi	a0,a0,-204 # 1290 <malloc+0x214>
     364:	465000ef          	jal	fc8 <printf>
        exit(1);
     368:	4505                	li	a0,1
     36a:	02b000ef          	jal	b94 <exit>
        printf("grind: chdir failed\n");
     36e:	00001517          	auipc	a0,0x1
     372:	f5250513          	addi	a0,a0,-174 # 12c0 <malloc+0x244>
     376:	453000ef          	jal	fc8 <printf>
        exit(1);
     37a:	4505                	li	a0,1
     37c:	019000ef          	jal	b94 <exit>
    } else if(what == 18){
      int pid = fork();
     380:	00d000ef          	jal	b8c <fork>
      if(pid == 0){
     384:	c519                	beqz	a0,392 <go+0x31e>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     386:	00054d63          	bltz	a0,3a0 <go+0x32c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     38a:	4501                	li	a0,0
     38c:	011000ef          	jal	b9c <wait>
     390:	bb9d                	j	106 <go+0x92>
        kill(getpid());
     392:	083000ef          	jal	c14 <getpid>
     396:	02f000ef          	jal	bc4 <kill>
        exit(0);
     39a:	4501                	li	a0,0
     39c:	7f8000ef          	jal	b94 <exit>
        printf("grind: fork failed\n");
     3a0:	00001517          	auipc	a0,0x1
     3a4:	ef050513          	addi	a0,a0,-272 # 1290 <malloc+0x214>
     3a8:	421000ef          	jal	fc8 <printf>
        exit(1);
     3ac:	4505                	li	a0,1
     3ae:	7e6000ef          	jal	b94 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     3b2:	fa840513          	addi	a0,s0,-88
     3b6:	7ee000ef          	jal	ba4 <pipe>
     3ba:	02054363          	bltz	a0,3e0 <go+0x36c>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     3be:	7ce000ef          	jal	b8c <fork>
      if(pid == 0){
     3c2:	c905                	beqz	a0,3f2 <go+0x37e>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     3c4:	08054263          	bltz	a0,448 <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     3c8:	fa842503          	lw	a0,-88(s0)
     3cc:	7f0000ef          	jal	bbc <close>
      close(fds[1]);
     3d0:	fac42503          	lw	a0,-84(s0)
     3d4:	7e8000ef          	jal	bbc <close>
      wait(0);
     3d8:	4501                	li	a0,0
     3da:	7c2000ef          	jal	b9c <wait>
     3de:	b325                	j	106 <go+0x92>
        printf("grind: pipe failed\n");
     3e0:	00001517          	auipc	a0,0x1
     3e4:	ef850513          	addi	a0,a0,-264 # 12d8 <malloc+0x25c>
     3e8:	3e1000ef          	jal	fc8 <printf>
        exit(1);
     3ec:	4505                	li	a0,1
     3ee:	7a6000ef          	jal	b94 <exit>
        fork();
     3f2:	79a000ef          	jal	b8c <fork>
        fork();
     3f6:	796000ef          	jal	b8c <fork>
        if(write(fds[1], "x", 1) != 1)
     3fa:	4605                	li	a2,1
     3fc:	00001597          	auipc	a1,0x1
     400:	ef458593          	addi	a1,a1,-268 # 12f0 <malloc+0x274>
     404:	fac42503          	lw	a0,-84(s0)
     408:	7ac000ef          	jal	bb4 <write>
     40c:	4785                	li	a5,1
     40e:	00f51f63          	bne	a0,a5,42c <go+0x3b8>
        if(read(fds[0], &c, 1) != 1)
     412:	4605                	li	a2,1
     414:	fa040593          	addi	a1,s0,-96
     418:	fa842503          	lw	a0,-88(s0)
     41c:	790000ef          	jal	bac <read>
     420:	4785                	li	a5,1
     422:	00f51c63          	bne	a0,a5,43a <go+0x3c6>
        exit(0);
     426:	4501                	li	a0,0
     428:	76c000ef          	jal	b94 <exit>
          printf("grind: pipe write failed\n");
     42c:	00001517          	auipc	a0,0x1
     430:	ecc50513          	addi	a0,a0,-308 # 12f8 <malloc+0x27c>
     434:	395000ef          	jal	fc8 <printf>
     438:	bfe9                	j	412 <go+0x39e>
          printf("grind: pipe read failed\n");
     43a:	00001517          	auipc	a0,0x1
     43e:	ede50513          	addi	a0,a0,-290 # 1318 <malloc+0x29c>
     442:	387000ef          	jal	fc8 <printf>
     446:	b7c5                	j	426 <go+0x3b2>
        printf("grind: fork failed\n");
     448:	00001517          	auipc	a0,0x1
     44c:	e4850513          	addi	a0,a0,-440 # 1290 <malloc+0x214>
     450:	379000ef          	jal	fc8 <printf>
        exit(1);
     454:	4505                	li	a0,1
     456:	73e000ef          	jal	b94 <exit>
    } else if(what == 20){
      int pid = fork();
     45a:	732000ef          	jal	b8c <fork>
      if(pid == 0){
     45e:	c519                	beqz	a0,46c <go+0x3f8>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     460:	04054f63          	bltz	a0,4be <go+0x44a>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     464:	4501                	li	a0,0
     466:	736000ef          	jal	b9c <wait>
     46a:	b971                	j	106 <go+0x92>
        unlink("a");
     46c:	00001517          	auipc	a0,0x1
     470:	e3c50513          	addi	a0,a0,-452 # 12a8 <malloc+0x22c>
     474:	770000ef          	jal	be4 <unlink>
        mkdir("a");
     478:	00001517          	auipc	a0,0x1
     47c:	e3050513          	addi	a0,a0,-464 # 12a8 <malloc+0x22c>
     480:	77c000ef          	jal	bfc <mkdir>
        chdir("a");
     484:	00001517          	auipc	a0,0x1
     488:	e2450513          	addi	a0,a0,-476 # 12a8 <malloc+0x22c>
     48c:	778000ef          	jal	c04 <chdir>
        unlink("../a");
     490:	00001517          	auipc	a0,0x1
     494:	ea850513          	addi	a0,a0,-344 # 1338 <malloc+0x2bc>
     498:	74c000ef          	jal	be4 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     49c:	20200593          	li	a1,514
     4a0:	00001517          	auipc	a0,0x1
     4a4:	e5050513          	addi	a0,a0,-432 # 12f0 <malloc+0x274>
     4a8:	72c000ef          	jal	bd4 <open>
        unlink("x");
     4ac:	00001517          	auipc	a0,0x1
     4b0:	e4450513          	addi	a0,a0,-444 # 12f0 <malloc+0x274>
     4b4:	730000ef          	jal	be4 <unlink>
        exit(0);
     4b8:	4501                	li	a0,0
     4ba:	6da000ef          	jal	b94 <exit>
        printf("grind: fork failed\n");
     4be:	00001517          	auipc	a0,0x1
     4c2:	dd250513          	addi	a0,a0,-558 # 1290 <malloc+0x214>
     4c6:	303000ef          	jal	fc8 <printf>
        exit(1);
     4ca:	4505                	li	a0,1
     4cc:	6c8000ef          	jal	b94 <exit>
    } else if(what == 21){
      unlink("c");
     4d0:	00001517          	auipc	a0,0x1
     4d4:	e7050513          	addi	a0,a0,-400 # 1340 <malloc+0x2c4>
     4d8:	70c000ef          	jal	be4 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     4dc:	20200593          	li	a1,514
     4e0:	00001517          	auipc	a0,0x1
     4e4:	e6050513          	addi	a0,a0,-416 # 1340 <malloc+0x2c4>
     4e8:	6ec000ef          	jal	bd4 <open>
     4ec:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     4ee:	04054763          	bltz	a0,53c <go+0x4c8>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     4f2:	4605                	li	a2,1
     4f4:	00001597          	auipc	a1,0x1
     4f8:	dfc58593          	addi	a1,a1,-516 # 12f0 <malloc+0x274>
     4fc:	6b8000ef          	jal	bb4 <write>
     500:	4785                	li	a5,1
     502:	04f51663          	bne	a0,a5,54e <go+0x4da>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     506:	fa840593          	addi	a1,s0,-88
     50a:	855a                	mv	a0,s6
     50c:	6e0000ef          	jal	bec <fstat>
     510:	e921                	bnez	a0,560 <go+0x4ec>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     512:	fb843583          	ld	a1,-72(s0)
     516:	4785                	li	a5,1
     518:	04f59d63          	bne	a1,a5,572 <go+0x4fe>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     51c:	fac42583          	lw	a1,-84(s0)
     520:	0c800793          	li	a5,200
     524:	06b7e163          	bltu	a5,a1,586 <go+0x512>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     528:	855a                	mv	a0,s6
     52a:	692000ef          	jal	bbc <close>
      unlink("c");
     52e:	00001517          	auipc	a0,0x1
     532:	e1250513          	addi	a0,a0,-494 # 1340 <malloc+0x2c4>
     536:	6ae000ef          	jal	be4 <unlink>
     53a:	b6f1                	j	106 <go+0x92>
        printf("grind: create c failed\n");
     53c:	00001517          	auipc	a0,0x1
     540:	e0c50513          	addi	a0,a0,-500 # 1348 <malloc+0x2cc>
     544:	285000ef          	jal	fc8 <printf>
        exit(1);
     548:	4505                	li	a0,1
     54a:	64a000ef          	jal	b94 <exit>
        printf("grind: write c failed\n");
     54e:	00001517          	auipc	a0,0x1
     552:	e1250513          	addi	a0,a0,-494 # 1360 <malloc+0x2e4>
     556:	273000ef          	jal	fc8 <printf>
        exit(1);
     55a:	4505                	li	a0,1
     55c:	638000ef          	jal	b94 <exit>
        printf("grind: fstat failed\n");
     560:	00001517          	auipc	a0,0x1
     564:	e1850513          	addi	a0,a0,-488 # 1378 <malloc+0x2fc>
     568:	261000ef          	jal	fc8 <printf>
        exit(1);
     56c:	4505                	li	a0,1
     56e:	626000ef          	jal	b94 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     572:	2581                	sext.w	a1,a1
     574:	00001517          	auipc	a0,0x1
     578:	e1c50513          	addi	a0,a0,-484 # 1390 <malloc+0x314>
     57c:	24d000ef          	jal	fc8 <printf>
        exit(1);
     580:	4505                	li	a0,1
     582:	612000ef          	jal	b94 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     586:	00001517          	auipc	a0,0x1
     58a:	e3250513          	addi	a0,a0,-462 # 13b8 <malloc+0x33c>
     58e:	23b000ef          	jal	fc8 <printf>
        exit(1);
     592:	4505                	li	a0,1
     594:	600000ef          	jal	b94 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     598:	f9840513          	addi	a0,s0,-104
     59c:	608000ef          	jal	ba4 <pipe>
     5a0:	0c054263          	bltz	a0,664 <go+0x5f0>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     5a4:	fa040513          	addi	a0,s0,-96
     5a8:	5fc000ef          	jal	ba4 <pipe>
     5ac:	0c054663          	bltz	a0,678 <go+0x604>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     5b0:	5dc000ef          	jal	b8c <fork>
      if(pid1 == 0){
     5b4:	0c050c63          	beqz	a0,68c <go+0x618>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     5b8:	14054e63          	bltz	a0,714 <go+0x6a0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     5bc:	5d0000ef          	jal	b8c <fork>
      if(pid2 == 0){
     5c0:	16050463          	beqz	a0,728 <go+0x6b4>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     5c4:	20054263          	bltz	a0,7c8 <go+0x754>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     5c8:	f9842503          	lw	a0,-104(s0)
     5cc:	5f0000ef          	jal	bbc <close>
      close(aa[1]);
     5d0:	f9c42503          	lw	a0,-100(s0)
     5d4:	5e8000ef          	jal	bbc <close>
      close(bb[1]);
     5d8:	fa442503          	lw	a0,-92(s0)
     5dc:	5e0000ef          	jal	bbc <close>
      char buf[4] = { 0, 0, 0, 0 };
     5e0:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     5e4:	4605                	li	a2,1
     5e6:	f9040593          	addi	a1,s0,-112
     5ea:	fa042503          	lw	a0,-96(s0)
     5ee:	5be000ef          	jal	bac <read>
      read(bb[0], buf+1, 1);
     5f2:	4605                	li	a2,1
     5f4:	f9140593          	addi	a1,s0,-111
     5f8:	fa042503          	lw	a0,-96(s0)
     5fc:	5b0000ef          	jal	bac <read>
      read(bb[0], buf+2, 1);
     600:	4605                	li	a2,1
     602:	f9240593          	addi	a1,s0,-110
     606:	fa042503          	lw	a0,-96(s0)
     60a:	5a2000ef          	jal	bac <read>
      close(bb[0]);
     60e:	fa042503          	lw	a0,-96(s0)
     612:	5aa000ef          	jal	bbc <close>
      int st1, st2;
      wait(&st1);
     616:	f9440513          	addi	a0,s0,-108
     61a:	582000ef          	jal	b9c <wait>
      wait(&st2);
     61e:	fa840513          	addi	a0,s0,-88
     622:	57a000ef          	jal	b9c <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     626:	f9442783          	lw	a5,-108(s0)
     62a:	fa842703          	lw	a4,-88(s0)
     62e:	8fd9                	or	a5,a5,a4
     630:	eb99                	bnez	a5,646 <go+0x5d2>
     632:	00001597          	auipc	a1,0x1
     636:	e2658593          	addi	a1,a1,-474 # 1458 <malloc+0x3dc>
     63a:	f9040513          	addi	a0,s0,-112
     63e:	2ce000ef          	jal	90c <strcmp>
     642:	ac0502e3          	beqz	a0,106 <go+0x92>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     646:	f9040693          	addi	a3,s0,-112
     64a:	fa842603          	lw	a2,-88(s0)
     64e:	f9442583          	lw	a1,-108(s0)
     652:	00001517          	auipc	a0,0x1
     656:	e0e50513          	addi	a0,a0,-498 # 1460 <malloc+0x3e4>
     65a:	16f000ef          	jal	fc8 <printf>
        exit(1);
     65e:	4505                	li	a0,1
     660:	534000ef          	jal	b94 <exit>
        fprintf(2, "grind: pipe failed\n");
     664:	00001597          	auipc	a1,0x1
     668:	c7458593          	addi	a1,a1,-908 # 12d8 <malloc+0x25c>
     66c:	4509                	li	a0,2
     66e:	131000ef          	jal	f9e <fprintf>
        exit(1);
     672:	4505                	li	a0,1
     674:	520000ef          	jal	b94 <exit>
        fprintf(2, "grind: pipe failed\n");
     678:	00001597          	auipc	a1,0x1
     67c:	c6058593          	addi	a1,a1,-928 # 12d8 <malloc+0x25c>
     680:	4509                	li	a0,2
     682:	11d000ef          	jal	f9e <fprintf>
        exit(1);
     686:	4505                	li	a0,1
     688:	50c000ef          	jal	b94 <exit>
        close(bb[0]);
     68c:	fa042503          	lw	a0,-96(s0)
     690:	52c000ef          	jal	bbc <close>
        close(bb[1]);
     694:	fa442503          	lw	a0,-92(s0)
     698:	524000ef          	jal	bbc <close>
        close(aa[0]);
     69c:	f9842503          	lw	a0,-104(s0)
     6a0:	51c000ef          	jal	bbc <close>
        close(1);
     6a4:	4505                	li	a0,1
     6a6:	516000ef          	jal	bbc <close>
        if(dup(aa[1]) != 1){
     6aa:	f9c42503          	lw	a0,-100(s0)
     6ae:	55e000ef          	jal	c0c <dup>
     6b2:	4785                	li	a5,1
     6b4:	00f50c63          	beq	a0,a5,6cc <go+0x658>
          fprintf(2, "grind: dup failed\n");
     6b8:	00001597          	auipc	a1,0x1
     6bc:	d2858593          	addi	a1,a1,-728 # 13e0 <malloc+0x364>
     6c0:	4509                	li	a0,2
     6c2:	0dd000ef          	jal	f9e <fprintf>
          exit(1);
     6c6:	4505                	li	a0,1
     6c8:	4cc000ef          	jal	b94 <exit>
        close(aa[1]);
     6cc:	f9c42503          	lw	a0,-100(s0)
     6d0:	4ec000ef          	jal	bbc <close>
        char *args[3] = { "echo", "hi", 0 };
     6d4:	00001797          	auipc	a5,0x1
     6d8:	d2478793          	addi	a5,a5,-732 # 13f8 <malloc+0x37c>
     6dc:	faf43423          	sd	a5,-88(s0)
     6e0:	00001797          	auipc	a5,0x1
     6e4:	d2078793          	addi	a5,a5,-736 # 1400 <malloc+0x384>
     6e8:	faf43823          	sd	a5,-80(s0)
     6ec:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     6f0:	fa840593          	addi	a1,s0,-88
     6f4:	00001517          	auipc	a0,0x1
     6f8:	d1450513          	addi	a0,a0,-748 # 1408 <malloc+0x38c>
     6fc:	4d0000ef          	jal	bcc <exec>
        fprintf(2, "grind: echo: not found\n");
     700:	00001597          	auipc	a1,0x1
     704:	d1858593          	addi	a1,a1,-744 # 1418 <malloc+0x39c>
     708:	4509                	li	a0,2
     70a:	095000ef          	jal	f9e <fprintf>
        exit(2);
     70e:	4509                	li	a0,2
     710:	484000ef          	jal	b94 <exit>
        fprintf(2, "grind: fork failed\n");
     714:	00001597          	auipc	a1,0x1
     718:	b7c58593          	addi	a1,a1,-1156 # 1290 <malloc+0x214>
     71c:	4509                	li	a0,2
     71e:	081000ef          	jal	f9e <fprintf>
        exit(3);
     722:	450d                	li	a0,3
     724:	470000ef          	jal	b94 <exit>
        close(aa[1]);
     728:	f9c42503          	lw	a0,-100(s0)
     72c:	490000ef          	jal	bbc <close>
        close(bb[0]);
     730:	fa042503          	lw	a0,-96(s0)
     734:	488000ef          	jal	bbc <close>
        close(0);
     738:	4501                	li	a0,0
     73a:	482000ef          	jal	bbc <close>
        if(dup(aa[0]) != 0){
     73e:	f9842503          	lw	a0,-104(s0)
     742:	4ca000ef          	jal	c0c <dup>
     746:	c919                	beqz	a0,75c <go+0x6e8>
          fprintf(2, "grind: dup failed\n");
     748:	00001597          	auipc	a1,0x1
     74c:	c9858593          	addi	a1,a1,-872 # 13e0 <malloc+0x364>
     750:	4509                	li	a0,2
     752:	04d000ef          	jal	f9e <fprintf>
          exit(4);
     756:	4511                	li	a0,4
     758:	43c000ef          	jal	b94 <exit>
        close(aa[0]);
     75c:	f9842503          	lw	a0,-104(s0)
     760:	45c000ef          	jal	bbc <close>
        close(1);
     764:	4505                	li	a0,1
     766:	456000ef          	jal	bbc <close>
        if(dup(bb[1]) != 1){
     76a:	fa442503          	lw	a0,-92(s0)
     76e:	49e000ef          	jal	c0c <dup>
     772:	4785                	li	a5,1
     774:	00f50c63          	beq	a0,a5,78c <go+0x718>
          fprintf(2, "grind: dup failed\n");
     778:	00001597          	auipc	a1,0x1
     77c:	c6858593          	addi	a1,a1,-920 # 13e0 <malloc+0x364>
     780:	4509                	li	a0,2
     782:	01d000ef          	jal	f9e <fprintf>
          exit(5);
     786:	4515                	li	a0,5
     788:	40c000ef          	jal	b94 <exit>
        close(bb[1]);
     78c:	fa442503          	lw	a0,-92(s0)
     790:	42c000ef          	jal	bbc <close>
        char *args[2] = { "cat", 0 };
     794:	00001797          	auipc	a5,0x1
     798:	c9c78793          	addi	a5,a5,-868 # 1430 <malloc+0x3b4>
     79c:	faf43423          	sd	a5,-88(s0)
     7a0:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     7a4:	fa840593          	addi	a1,s0,-88
     7a8:	00001517          	auipc	a0,0x1
     7ac:	c9050513          	addi	a0,a0,-880 # 1438 <malloc+0x3bc>
     7b0:	41c000ef          	jal	bcc <exec>
        fprintf(2, "grind: cat: not found\n");
     7b4:	00001597          	auipc	a1,0x1
     7b8:	c8c58593          	addi	a1,a1,-884 # 1440 <malloc+0x3c4>
     7bc:	4509                	li	a0,2
     7be:	7e0000ef          	jal	f9e <fprintf>
        exit(6);
     7c2:	4519                	li	a0,6
     7c4:	3d0000ef          	jal	b94 <exit>
        fprintf(2, "grind: fork failed\n");
     7c8:	00001597          	auipc	a1,0x1
     7cc:	ac858593          	addi	a1,a1,-1336 # 1290 <malloc+0x214>
     7d0:	4509                	li	a0,2
     7d2:	7cc000ef          	jal	f9e <fprintf>
        exit(7);
     7d6:	451d                	li	a0,7
     7d8:	3bc000ef          	jal	b94 <exit>

00000000000007dc <iter>:
  }
}

void
iter()
{
     7dc:	7179                	addi	sp,sp,-48
     7de:	f406                	sd	ra,40(sp)
     7e0:	f022                	sd	s0,32(sp)
     7e2:	1800                	addi	s0,sp,48
  unlink("a");
     7e4:	00001517          	auipc	a0,0x1
     7e8:	ac450513          	addi	a0,a0,-1340 # 12a8 <malloc+0x22c>
     7ec:	3f8000ef          	jal	be4 <unlink>
  unlink("b");
     7f0:	00001517          	auipc	a0,0x1
     7f4:	a6850513          	addi	a0,a0,-1432 # 1258 <malloc+0x1dc>
     7f8:	3ec000ef          	jal	be4 <unlink>
  
  int pid1 = fork();
     7fc:	390000ef          	jal	b8c <fork>
  if(pid1 < 0){
     800:	02054163          	bltz	a0,822 <iter+0x46>
     804:	ec26                	sd	s1,24(sp)
     806:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     808:	e905                	bnez	a0,838 <iter+0x5c>
     80a:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     80c:	00001717          	auipc	a4,0x1
     810:	7f470713          	addi	a4,a4,2036 # 2000 <rand_next>
     814:	631c                	ld	a5,0(a4)
     816:	01f7c793          	xori	a5,a5,31
     81a:	e31c                	sd	a5,0(a4)
    go(0);
     81c:	4501                	li	a0,0
     81e:	857ff0ef          	jal	74 <go>
     822:	ec26                	sd	s1,24(sp)
     824:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     826:	00001517          	auipc	a0,0x1
     82a:	a6a50513          	addi	a0,a0,-1430 # 1290 <malloc+0x214>
     82e:	79a000ef          	jal	fc8 <printf>
    exit(1);
     832:	4505                	li	a0,1
     834:	360000ef          	jal	b94 <exit>
     838:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     83a:	352000ef          	jal	b8c <fork>
     83e:	892a                	mv	s2,a0
  if(pid2 < 0){
     840:	02054063          	bltz	a0,860 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     844:	e51d                	bnez	a0,872 <iter+0x96>
    rand_next ^= 7177;
     846:	00001697          	auipc	a3,0x1
     84a:	7ba68693          	addi	a3,a3,1978 # 2000 <rand_next>
     84e:	629c                	ld	a5,0(a3)
     850:	6709                	lui	a4,0x2
     852:	c0970713          	addi	a4,a4,-1015 # 1c09 <digits+0x719>
     856:	8fb9                	xor	a5,a5,a4
     858:	e29c                	sd	a5,0(a3)
    go(1);
     85a:	4505                	li	a0,1
     85c:	819ff0ef          	jal	74 <go>
    printf("grind: fork failed\n");
     860:	00001517          	auipc	a0,0x1
     864:	a3050513          	addi	a0,a0,-1488 # 1290 <malloc+0x214>
     868:	760000ef          	jal	fc8 <printf>
    exit(1);
     86c:	4505                	li	a0,1
     86e:	326000ef          	jal	b94 <exit>
    exit(0);
  }

  int st1 = -1;
     872:	57fd                	li	a5,-1
     874:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     878:	fdc40513          	addi	a0,s0,-36
     87c:	320000ef          	jal	b9c <wait>
  if(st1 != 0){
     880:	fdc42783          	lw	a5,-36(s0)
     884:	eb99                	bnez	a5,89a <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     886:	57fd                	li	a5,-1
     888:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     88c:	fd840513          	addi	a0,s0,-40
     890:	30c000ef          	jal	b9c <wait>

  exit(0);
     894:	4501                	li	a0,0
     896:	2fe000ef          	jal	b94 <exit>
    kill(pid1);
     89a:	8526                	mv	a0,s1
     89c:	328000ef          	jal	bc4 <kill>
    kill(pid2);
     8a0:	854a                	mv	a0,s2
     8a2:	322000ef          	jal	bc4 <kill>
     8a6:	b7c5                	j	886 <iter+0xaa>

00000000000008a8 <main>:
}

int
main()
{
     8a8:	1101                	addi	sp,sp,-32
     8aa:	ec06                	sd	ra,24(sp)
     8ac:	e822                	sd	s0,16(sp)
     8ae:	e426                	sd	s1,8(sp)
     8b0:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    pause(20);
    rand_next += 1;
     8b2:	00001497          	auipc	s1,0x1
     8b6:	74e48493          	addi	s1,s1,1870 # 2000 <rand_next>
     8ba:	a809                	j	8cc <main+0x24>
      iter();
     8bc:	f21ff0ef          	jal	7dc <iter>
    pause(20);
     8c0:	4551                	li	a0,20
     8c2:	362000ef          	jal	c24 <pause>
    rand_next += 1;
     8c6:	609c                	ld	a5,0(s1)
     8c8:	0785                	addi	a5,a5,1
     8ca:	e09c                	sd	a5,0(s1)
    int pid = fork();
     8cc:	2c0000ef          	jal	b8c <fork>
    if(pid == 0){
     8d0:	d575                	beqz	a0,8bc <main+0x14>
    if(pid > 0){
     8d2:	fea057e3          	blez	a0,8c0 <main+0x18>
      wait(0);
     8d6:	4501                	li	a0,0
     8d8:	2c4000ef          	jal	b9c <wait>
     8dc:	b7d5                	j	8c0 <main+0x18>

00000000000008de <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     8de:	1141                	addi	sp,sp,-16
     8e0:	e406                	sd	ra,8(sp)
     8e2:	e022                	sd	s0,0(sp)
     8e4:	0800                	addi	s0,sp,16
  extern int main();
  main();
     8e6:	fc3ff0ef          	jal	8a8 <main>
  exit(0);
     8ea:	4501                	li	a0,0
     8ec:	2a8000ef          	jal	b94 <exit>

00000000000008f0 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     8f0:	1141                	addi	sp,sp,-16
     8f2:	e422                	sd	s0,8(sp)
     8f4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     8f6:	87aa                	mv	a5,a0
     8f8:	0585                	addi	a1,a1,1
     8fa:	0785                	addi	a5,a5,1
     8fc:	fff5c703          	lbu	a4,-1(a1)
     900:	fee78fa3          	sb	a4,-1(a5)
     904:	fb75                	bnez	a4,8f8 <strcpy+0x8>
    ;
  return os;
}
     906:	6422                	ld	s0,8(sp)
     908:	0141                	addi	sp,sp,16
     90a:	8082                	ret

000000000000090c <strcmp>:

int
strcmp(const char *p, const char *q)
{
     90c:	1141                	addi	sp,sp,-16
     90e:	e422                	sd	s0,8(sp)
     910:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     912:	00054783          	lbu	a5,0(a0)
     916:	cb91                	beqz	a5,92a <strcmp+0x1e>
     918:	0005c703          	lbu	a4,0(a1)
     91c:	00f71763          	bne	a4,a5,92a <strcmp+0x1e>
    p++, q++;
     920:	0505                	addi	a0,a0,1
     922:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     924:	00054783          	lbu	a5,0(a0)
     928:	fbe5                	bnez	a5,918 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     92a:	0005c503          	lbu	a0,0(a1)
}
     92e:	40a7853b          	subw	a0,a5,a0
     932:	6422                	ld	s0,8(sp)
     934:	0141                	addi	sp,sp,16
     936:	8082                	ret

0000000000000938 <strlen>:

uint
strlen(const char *s)
{
     938:	1141                	addi	sp,sp,-16
     93a:	e422                	sd	s0,8(sp)
     93c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     93e:	00054783          	lbu	a5,0(a0)
     942:	cf91                	beqz	a5,95e <strlen+0x26>
     944:	0505                	addi	a0,a0,1
     946:	87aa                	mv	a5,a0
     948:	86be                	mv	a3,a5
     94a:	0785                	addi	a5,a5,1
     94c:	fff7c703          	lbu	a4,-1(a5)
     950:	ff65                	bnez	a4,948 <strlen+0x10>
     952:	40a6853b          	subw	a0,a3,a0
     956:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     958:	6422                	ld	s0,8(sp)
     95a:	0141                	addi	sp,sp,16
     95c:	8082                	ret
  for(n = 0; s[n]; n++)
     95e:	4501                	li	a0,0
     960:	bfe5                	j	958 <strlen+0x20>

0000000000000962 <memset>:

void*
memset(void *dst, int c, uint n)
{
     962:	1141                	addi	sp,sp,-16
     964:	e422                	sd	s0,8(sp)
     966:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     968:	ca19                	beqz	a2,97e <memset+0x1c>
     96a:	87aa                	mv	a5,a0
     96c:	1602                	slli	a2,a2,0x20
     96e:	9201                	srli	a2,a2,0x20
     970:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     974:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     978:	0785                	addi	a5,a5,1
     97a:	fee79de3          	bne	a5,a4,974 <memset+0x12>
  }
  return dst;
}
     97e:	6422                	ld	s0,8(sp)
     980:	0141                	addi	sp,sp,16
     982:	8082                	ret

0000000000000984 <strchr>:

char*
strchr(const char *s, char c)
{
     984:	1141                	addi	sp,sp,-16
     986:	e422                	sd	s0,8(sp)
     988:	0800                	addi	s0,sp,16
  for(; *s; s++)
     98a:	00054783          	lbu	a5,0(a0)
     98e:	cb99                	beqz	a5,9a4 <strchr+0x20>
    if(*s == c)
     990:	00f58763          	beq	a1,a5,99e <strchr+0x1a>
  for(; *s; s++)
     994:	0505                	addi	a0,a0,1
     996:	00054783          	lbu	a5,0(a0)
     99a:	fbfd                	bnez	a5,990 <strchr+0xc>
      return (char*)s;
  return 0;
     99c:	4501                	li	a0,0
}
     99e:	6422                	ld	s0,8(sp)
     9a0:	0141                	addi	sp,sp,16
     9a2:	8082                	ret
  return 0;
     9a4:	4501                	li	a0,0
     9a6:	bfe5                	j	99e <strchr+0x1a>

00000000000009a8 <gets>:

char*
gets(char *buf, int max)
{
     9a8:	711d                	addi	sp,sp,-96
     9aa:	ec86                	sd	ra,88(sp)
     9ac:	e8a2                	sd	s0,80(sp)
     9ae:	e4a6                	sd	s1,72(sp)
     9b0:	e0ca                	sd	s2,64(sp)
     9b2:	fc4e                	sd	s3,56(sp)
     9b4:	f852                	sd	s4,48(sp)
     9b6:	f456                	sd	s5,40(sp)
     9b8:	f05a                	sd	s6,32(sp)
     9ba:	ec5e                	sd	s7,24(sp)
     9bc:	1080                	addi	s0,sp,96
     9be:	8baa                	mv	s7,a0
     9c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9c2:	892a                	mv	s2,a0
     9c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     9c6:	4aa9                	li	s5,10
     9c8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     9ca:	89a6                	mv	s3,s1
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0344d663          	bge	s1,s4,9fa <gets+0x52>
    cc = read(0, &c, 1);
     9d2:	4605                	li	a2,1
     9d4:	faf40593          	addi	a1,s0,-81
     9d8:	4501                	li	a0,0
     9da:	1d2000ef          	jal	bac <read>
    if(cc < 1)
     9de:	00a05e63          	blez	a0,9fa <gets+0x52>
    buf[i++] = c;
     9e2:	faf44783          	lbu	a5,-81(s0)
     9e6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9ea:	01578763          	beq	a5,s5,9f8 <gets+0x50>
     9ee:	0905                	addi	s2,s2,1
     9f0:	fd679de3          	bne	a5,s6,9ca <gets+0x22>
    buf[i++] = c;
     9f4:	89a6                	mv	s3,s1
     9f6:	a011                	j	9fa <gets+0x52>
     9f8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     9fa:	99de                	add	s3,s3,s7
     9fc:	00098023          	sb	zero,0(s3)
  return buf;
}
     a00:	855e                	mv	a0,s7
     a02:	60e6                	ld	ra,88(sp)
     a04:	6446                	ld	s0,80(sp)
     a06:	64a6                	ld	s1,72(sp)
     a08:	6906                	ld	s2,64(sp)
     a0a:	79e2                	ld	s3,56(sp)
     a0c:	7a42                	ld	s4,48(sp)
     a0e:	7aa2                	ld	s5,40(sp)
     a10:	7b02                	ld	s6,32(sp)
     a12:	6be2                	ld	s7,24(sp)
     a14:	6125                	addi	sp,sp,96
     a16:	8082                	ret

0000000000000a18 <stat>:

int
stat(const char *n, struct stat *st)
{
     a18:	1101                	addi	sp,sp,-32
     a1a:	ec06                	sd	ra,24(sp)
     a1c:	e822                	sd	s0,16(sp)
     a1e:	e04a                	sd	s2,0(sp)
     a20:	1000                	addi	s0,sp,32
     a22:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a24:	4581                	li	a1,0
     a26:	1ae000ef          	jal	bd4 <open>
  if(fd < 0)
     a2a:	02054263          	bltz	a0,a4e <stat+0x36>
     a2e:	e426                	sd	s1,8(sp)
     a30:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     a32:	85ca                	mv	a1,s2
     a34:	1b8000ef          	jal	bec <fstat>
     a38:	892a                	mv	s2,a0
  close(fd);
     a3a:	8526                	mv	a0,s1
     a3c:	180000ef          	jal	bbc <close>
  return r;
     a40:	64a2                	ld	s1,8(sp)
}
     a42:	854a                	mv	a0,s2
     a44:	60e2                	ld	ra,24(sp)
     a46:	6442                	ld	s0,16(sp)
     a48:	6902                	ld	s2,0(sp)
     a4a:	6105                	addi	sp,sp,32
     a4c:	8082                	ret
    return -1;
     a4e:	597d                	li	s2,-1
     a50:	bfcd                	j	a42 <stat+0x2a>

0000000000000a52 <atoi>:

int
atoi(const char *s)
{
     a52:	1141                	addi	sp,sp,-16
     a54:	e422                	sd	s0,8(sp)
     a56:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a58:	00054683          	lbu	a3,0(a0)
     a5c:	fd06879b          	addiw	a5,a3,-48
     a60:	0ff7f793          	zext.b	a5,a5
     a64:	4625                	li	a2,9
     a66:	02f66863          	bltu	a2,a5,a96 <atoi+0x44>
     a6a:	872a                	mv	a4,a0
  n = 0;
     a6c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a6e:	0705                	addi	a4,a4,1
     a70:	0025179b          	slliw	a5,a0,0x2
     a74:	9fa9                	addw	a5,a5,a0
     a76:	0017979b          	slliw	a5,a5,0x1
     a7a:	9fb5                	addw	a5,a5,a3
     a7c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a80:	00074683          	lbu	a3,0(a4)
     a84:	fd06879b          	addiw	a5,a3,-48
     a88:	0ff7f793          	zext.b	a5,a5
     a8c:	fef671e3          	bgeu	a2,a5,a6e <atoi+0x1c>
  return n;
}
     a90:	6422                	ld	s0,8(sp)
     a92:	0141                	addi	sp,sp,16
     a94:	8082                	ret
  n = 0;
     a96:	4501                	li	a0,0
     a98:	bfe5                	j	a90 <atoi+0x3e>

0000000000000a9a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a9a:	1141                	addi	sp,sp,-16
     a9c:	e422                	sd	s0,8(sp)
     a9e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     aa0:	02b57463          	bgeu	a0,a1,ac8 <memmove+0x2e>
    while(n-- > 0)
     aa4:	00c05f63          	blez	a2,ac2 <memmove+0x28>
     aa8:	1602                	slli	a2,a2,0x20
     aaa:	9201                	srli	a2,a2,0x20
     aac:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ab0:	872a                	mv	a4,a0
      *dst++ = *src++;
     ab2:	0585                	addi	a1,a1,1
     ab4:	0705                	addi	a4,a4,1
     ab6:	fff5c683          	lbu	a3,-1(a1)
     aba:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     abe:	fef71ae3          	bne	a4,a5,ab2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ac2:	6422                	ld	s0,8(sp)
     ac4:	0141                	addi	sp,sp,16
     ac6:	8082                	ret
    dst += n;
     ac8:	00c50733          	add	a4,a0,a2
    src += n;
     acc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     ace:	fec05ae3          	blez	a2,ac2 <memmove+0x28>
     ad2:	fff6079b          	addiw	a5,a2,-1
     ad6:	1782                	slli	a5,a5,0x20
     ad8:	9381                	srli	a5,a5,0x20
     ada:	fff7c793          	not	a5,a5
     ade:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     ae0:	15fd                	addi	a1,a1,-1
     ae2:	177d                	addi	a4,a4,-1
     ae4:	0005c683          	lbu	a3,0(a1)
     ae8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     aec:	fee79ae3          	bne	a5,a4,ae0 <memmove+0x46>
     af0:	bfc9                	j	ac2 <memmove+0x28>

0000000000000af2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e422                	sd	s0,8(sp)
     af6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     af8:	ca05                	beqz	a2,b28 <memcmp+0x36>
     afa:	fff6069b          	addiw	a3,a2,-1
     afe:	1682                	slli	a3,a3,0x20
     b00:	9281                	srli	a3,a3,0x20
     b02:	0685                	addi	a3,a3,1
     b04:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b06:	00054783          	lbu	a5,0(a0)
     b0a:	0005c703          	lbu	a4,0(a1)
     b0e:	00e79863          	bne	a5,a4,b1e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b12:	0505                	addi	a0,a0,1
    p2++;
     b14:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b16:	fed518e3          	bne	a0,a3,b06 <memcmp+0x14>
  }
  return 0;
     b1a:	4501                	li	a0,0
     b1c:	a019                	j	b22 <memcmp+0x30>
      return *p1 - *p2;
     b1e:	40e7853b          	subw	a0,a5,a4
}
     b22:	6422                	ld	s0,8(sp)
     b24:	0141                	addi	sp,sp,16
     b26:	8082                	ret
  return 0;
     b28:	4501                	li	a0,0
     b2a:	bfe5                	j	b22 <memcmp+0x30>

0000000000000b2c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b2c:	1141                	addi	sp,sp,-16
     b2e:	e406                	sd	ra,8(sp)
     b30:	e022                	sd	s0,0(sp)
     b32:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b34:	f67ff0ef          	jal	a9a <memmove>
}
     b38:	60a2                	ld	ra,8(sp)
     b3a:	6402                	ld	s0,0(sp)
     b3c:	0141                	addi	sp,sp,16
     b3e:	8082                	ret

0000000000000b40 <sbrk>:

char *
sbrk(int n) {
     b40:	1141                	addi	sp,sp,-16
     b42:	e406                	sd	ra,8(sp)
     b44:	e022                	sd	s0,0(sp)
     b46:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     b48:	4585                	li	a1,1
     b4a:	0d2000ef          	jal	c1c <sys_sbrk>
}
     b4e:	60a2                	ld	ra,8(sp)
     b50:	6402                	ld	s0,0(sp)
     b52:	0141                	addi	sp,sp,16
     b54:	8082                	ret

0000000000000b56 <sbrklazy>:

char *
sbrklazy(int n) {
     b56:	1141                	addi	sp,sp,-16
     b58:	e406                	sd	ra,8(sp)
     b5a:	e022                	sd	s0,0(sp)
     b5c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     b5e:	4589                	li	a1,2
     b60:	0bc000ef          	jal	c1c <sys_sbrk>
}
     b64:	60a2                	ld	ra,8(sp)
     b66:	6402                	ld	s0,0(sp)
     b68:	0141                	addi	sp,sp,16
     b6a:	8082                	ret

0000000000000b6c <cps>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global cps
cps:
 li a7, SYS_cps
     b6c:	48e5                	li	a7,25
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <set_priority>:
.global set_priority
set_priority:
 li a7, SYS_set_priority
     b74:	48e1                	li	a7,24
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <get_priority>:
.global get_priority
get_priority:
 li a7, SYS_get_priority
     b7c:	48dd                	li	a7,23
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <trace>:
.global trace
trace:
 li a7, SYS_trace
     b84:	48d9                	li	a7,22
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <fork>:
.global fork
fork:
 li a7, SYS_fork
     b8c:	4885                	li	a7,1
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b94:	4889                	li	a7,2
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <wait>:
.global wait
wait:
 li a7, SYS_wait
     b9c:	488d                	li	a7,3
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ba4:	4891                	li	a7,4
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <read>:
.global read
read:
 li a7, SYS_read
     bac:	4895                	li	a7,5
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <write>:
.global write
write:
 li a7, SYS_write
     bb4:	48c1                	li	a7,16
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <close>:
.global close
close:
 li a7, SYS_close
     bbc:	48d5                	li	a7,21
 ecall
     bbe:	00000073          	ecall
 ret
     bc2:	8082                	ret

0000000000000bc4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     bc4:	4899                	li	a7,6
 ecall
     bc6:	00000073          	ecall
 ret
     bca:	8082                	ret

0000000000000bcc <exec>:
.global exec
exec:
 li a7, SYS_exec
     bcc:	489d                	li	a7,7
 ecall
     bce:	00000073          	ecall
 ret
     bd2:	8082                	ret

0000000000000bd4 <open>:
.global open
open:
 li a7, SYS_open
     bd4:	48bd                	li	a7,15
 ecall
     bd6:	00000073          	ecall
 ret
     bda:	8082                	ret

0000000000000bdc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bdc:	48c5                	li	a7,17
 ecall
     bde:	00000073          	ecall
 ret
     be2:	8082                	ret

0000000000000be4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     be4:	48c9                	li	a7,18
 ecall
     be6:	00000073          	ecall
 ret
     bea:	8082                	ret

0000000000000bec <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bec:	48a1                	li	a7,8
 ecall
     bee:	00000073          	ecall
 ret
     bf2:	8082                	ret

0000000000000bf4 <link>:
.global link
link:
 li a7, SYS_link
     bf4:	48cd                	li	a7,19
 ecall
     bf6:	00000073          	ecall
 ret
     bfa:	8082                	ret

0000000000000bfc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bfc:	48d1                	li	a7,20
 ecall
     bfe:	00000073          	ecall
 ret
     c02:	8082                	ret

0000000000000c04 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c04:	48a5                	li	a7,9
 ecall
     c06:	00000073          	ecall
 ret
     c0a:	8082                	ret

0000000000000c0c <dup>:
.global dup
dup:
 li a7, SYS_dup
     c0c:	48a9                	li	a7,10
 ecall
     c0e:	00000073          	ecall
 ret
     c12:	8082                	ret

0000000000000c14 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c14:	48ad                	li	a7,11
 ecall
     c16:	00000073          	ecall
 ret
     c1a:	8082                	ret

0000000000000c1c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     c1c:	48b1                	li	a7,12
 ecall
     c1e:	00000073          	ecall
 ret
     c22:	8082                	ret

0000000000000c24 <pause>:
.global pause
pause:
 li a7, SYS_pause
     c24:	48b5                	li	a7,13
 ecall
     c26:	00000073          	ecall
 ret
     c2a:	8082                	ret

0000000000000c2c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c2c:	48b9                	li	a7,14
 ecall
     c2e:	00000073          	ecall
 ret
     c32:	8082                	ret

0000000000000c34 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c34:	1101                	addi	sp,sp,-32
     c36:	ec06                	sd	ra,24(sp)
     c38:	e822                	sd	s0,16(sp)
     c3a:	1000                	addi	s0,sp,32
     c3c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c40:	4605                	li	a2,1
     c42:	fef40593          	addi	a1,s0,-17
     c46:	f6fff0ef          	jal	bb4 <write>
}
     c4a:	60e2                	ld	ra,24(sp)
     c4c:	6442                	ld	s0,16(sp)
     c4e:	6105                	addi	sp,sp,32
     c50:	8082                	ret

0000000000000c52 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     c52:	715d                	addi	sp,sp,-80
     c54:	e486                	sd	ra,72(sp)
     c56:	e0a2                	sd	s0,64(sp)
     c58:	fc26                	sd	s1,56(sp)
     c5a:	0880                	addi	s0,sp,80
     c5c:	84aa                	mv	s1,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c5e:	c299                	beqz	a3,c64 <printint+0x12>
     c60:	0805c963          	bltz	a1,cf2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     c64:	2581                	sext.w	a1,a1
  neg = 0;
     c66:	4881                	li	a7,0
     c68:	fb840693          	addi	a3,s0,-72
  }

  i = 0;
     c6c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c6e:	2601                	sext.w	a2,a2
     c70:	00001517          	auipc	a0,0x1
     c74:	88050513          	addi	a0,a0,-1920 # 14f0 <digits>
     c78:	883a                	mv	a6,a4
     c7a:	2705                	addiw	a4,a4,1
     c7c:	02c5f7bb          	remuw	a5,a1,a2
     c80:	1782                	slli	a5,a5,0x20
     c82:	9381                	srli	a5,a5,0x20
     c84:	97aa                	add	a5,a5,a0
     c86:	0007c783          	lbu	a5,0(a5)
     c8a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c8e:	0005879b          	sext.w	a5,a1
     c92:	02c5d5bb          	divuw	a1,a1,a2
     c96:	0685                	addi	a3,a3,1
     c98:	fec7f0e3          	bgeu	a5,a2,c78 <printint+0x26>
  if(neg)
     c9c:	00088c63          	beqz	a7,cb4 <printint+0x62>
    buf[i++] = '-';
     ca0:	fd070793          	addi	a5,a4,-48
     ca4:	00878733          	add	a4,a5,s0
     ca8:	02d00793          	li	a5,45
     cac:	fef70423          	sb	a5,-24(a4)
     cb0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     cb4:	02e05a63          	blez	a4,ce8 <printint+0x96>
     cb8:	f84a                	sd	s2,48(sp)
     cba:	f44e                	sd	s3,40(sp)
     cbc:	fb840793          	addi	a5,s0,-72
     cc0:	00e78933          	add	s2,a5,a4
     cc4:	fff78993          	addi	s3,a5,-1
     cc8:	99ba                	add	s3,s3,a4
     cca:	377d                	addiw	a4,a4,-1
     ccc:	1702                	slli	a4,a4,0x20
     cce:	9301                	srli	a4,a4,0x20
     cd0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cd4:	fff94583          	lbu	a1,-1(s2)
     cd8:	8526                	mv	a0,s1
     cda:	f5bff0ef          	jal	c34 <putc>
  while(--i >= 0)
     cde:	197d                	addi	s2,s2,-1
     ce0:	ff391ae3          	bne	s2,s3,cd4 <printint+0x82>
     ce4:	7942                	ld	s2,48(sp)
     ce6:	79a2                	ld	s3,40(sp)
}
     ce8:	60a6                	ld	ra,72(sp)
     cea:	6406                	ld	s0,64(sp)
     cec:	74e2                	ld	s1,56(sp)
     cee:	6161                	addi	sp,sp,80
     cf0:	8082                	ret
    x = -xx;
     cf2:	40b005bb          	negw	a1,a1
    neg = 1;
     cf6:	4885                	li	a7,1
    x = -xx;
     cf8:	bf85                	j	c68 <printint+0x16>

0000000000000cfa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cfa:	711d                	addi	sp,sp,-96
     cfc:	ec86                	sd	ra,88(sp)
     cfe:	e8a2                	sd	s0,80(sp)
     d00:	e0ca                	sd	s2,64(sp)
     d02:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d04:	0005c903          	lbu	s2,0(a1)
     d08:	28090663          	beqz	s2,f94 <vprintf+0x29a>
     d0c:	e4a6                	sd	s1,72(sp)
     d0e:	fc4e                	sd	s3,56(sp)
     d10:	f852                	sd	s4,48(sp)
     d12:	f456                	sd	s5,40(sp)
     d14:	f05a                	sd	s6,32(sp)
     d16:	ec5e                	sd	s7,24(sp)
     d18:	e862                	sd	s8,16(sp)
     d1a:	e466                	sd	s9,8(sp)
     d1c:	8b2a                	mv	s6,a0
     d1e:	8a2e                	mv	s4,a1
     d20:	8bb2                	mv	s7,a2
  state = 0;
     d22:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     d24:	4481                	li	s1,0
     d26:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     d28:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     d2c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     d30:	06c00c93          	li	s9,108
     d34:	a005                	j	d54 <vprintf+0x5a>
        putc(fd, c0);
     d36:	85ca                	mv	a1,s2
     d38:	855a                	mv	a0,s6
     d3a:	efbff0ef          	jal	c34 <putc>
     d3e:	a019                	j	d44 <vprintf+0x4a>
    } else if(state == '%'){
     d40:	03598263          	beq	s3,s5,d64 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
     d44:	2485                	addiw	s1,s1,1
     d46:	8726                	mv	a4,s1
     d48:	009a07b3          	add	a5,s4,s1
     d4c:	0007c903          	lbu	s2,0(a5)
     d50:	22090a63          	beqz	s2,f84 <vprintf+0x28a>
    c0 = fmt[i] & 0xff;
     d54:	0009079b          	sext.w	a5,s2
    if(state == 0){
     d58:	fe0994e3          	bnez	s3,d40 <vprintf+0x46>
      if(c0 == '%'){
     d5c:	fd579de3          	bne	a5,s5,d36 <vprintf+0x3c>
        state = '%';
     d60:	89be                	mv	s3,a5
     d62:	b7cd                	j	d44 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     d64:	00ea06b3          	add	a3,s4,a4
     d68:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     d6c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     d6e:	c681                	beqz	a3,d76 <vprintf+0x7c>
     d70:	9752                	add	a4,a4,s4
     d72:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     d76:	05878363          	beq	a5,s8,dbc <vprintf+0xc2>
      } else if(c0 == 'l' && c1 == 'd'){
     d7a:	05978d63          	beq	a5,s9,dd4 <vprintf+0xda>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     d7e:	07500713          	li	a4,117
     d82:	0ee78763          	beq	a5,a4,e70 <vprintf+0x176>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     d86:	07800713          	li	a4,120
     d8a:	12e78963          	beq	a5,a4,ebc <vprintf+0x1c2>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     d8e:	07000713          	li	a4,112
     d92:	14e78e63          	beq	a5,a4,eee <vprintf+0x1f4>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 'c'){
     d96:	06300713          	li	a4,99
     d9a:	18e78e63          	beq	a5,a4,f36 <vprintf+0x23c>
        putc(fd, va_arg(ap, uint32));
      } else if(c0 == 's'){
     d9e:	07300713          	li	a4,115
     da2:	1ae78463          	beq	a5,a4,f4a <vprintf+0x250>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     da6:	02500713          	li	a4,37
     daa:	04e79563          	bne	a5,a4,df4 <vprintf+0xfa>
        putc(fd, '%');
     dae:	02500593          	li	a1,37
     db2:	855a                	mv	a0,s6
     db4:	e81ff0ef          	jal	c34 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     db8:	4981                	li	s3,0
     dba:	b769                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     dbc:	008b8913          	addi	s2,s7,8
     dc0:	4685                	li	a3,1
     dc2:	4629                	li	a2,10
     dc4:	000ba583          	lw	a1,0(s7)
     dc8:	855a                	mv	a0,s6
     dca:	e89ff0ef          	jal	c52 <printint>
     dce:	8bca                	mv	s7,s2
      state = 0;
     dd0:	4981                	li	s3,0
     dd2:	bf8d                	j	d44 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     dd4:	06400793          	li	a5,100
     dd8:	02f68963          	beq	a3,a5,e0a <vprintf+0x110>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     ddc:	06c00793          	li	a5,108
     de0:	04f68263          	beq	a3,a5,e24 <vprintf+0x12a>
      } else if(c0 == 'l' && c1 == 'u'){
     de4:	07500793          	li	a5,117
     de8:	0af68063          	beq	a3,a5,e88 <vprintf+0x18e>
      } else if(c0 == 'l' && c1 == 'x'){
     dec:	07800793          	li	a5,120
     df0:	0ef68263          	beq	a3,a5,ed4 <vprintf+0x1da>
        putc(fd, '%');
     df4:	02500593          	li	a1,37
     df8:	855a                	mv	a0,s6
     dfa:	e3bff0ef          	jal	c34 <putc>
        putc(fd, c0);
     dfe:	85ca                	mv	a1,s2
     e00:	855a                	mv	a0,s6
     e02:	e33ff0ef          	jal	c34 <putc>
      state = 0;
     e06:	4981                	li	s3,0
     e08:	bf35                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e0a:	008b8913          	addi	s2,s7,8
     e0e:	4685                	li	a3,1
     e10:	4629                	li	a2,10
     e12:	000bb583          	ld	a1,0(s7)
     e16:	855a                	mv	a0,s6
     e18:	e3bff0ef          	jal	c52 <printint>
        i += 1;
     e1c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     e1e:	8bca                	mv	s7,s2
      state = 0;
     e20:	4981                	li	s3,0
        i += 1;
     e22:	b70d                	j	d44 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     e24:	06400793          	li	a5,100
     e28:	02f60763          	beq	a2,a5,e56 <vprintf+0x15c>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     e2c:	07500793          	li	a5,117
     e30:	06f60963          	beq	a2,a5,ea2 <vprintf+0x1a8>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     e34:	07800793          	li	a5,120
     e38:	faf61ee3          	bne	a2,a5,df4 <vprintf+0xfa>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e3c:	008b8913          	addi	s2,s7,8
     e40:	4681                	li	a3,0
     e42:	4641                	li	a2,16
     e44:	000bb583          	ld	a1,0(s7)
     e48:	855a                	mv	a0,s6
     e4a:	e09ff0ef          	jal	c52 <printint>
        i += 2;
     e4e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     e50:	8bca                	mv	s7,s2
      state = 0;
     e52:	4981                	li	s3,0
        i += 2;
     e54:	bdc5                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     e56:	008b8913          	addi	s2,s7,8
     e5a:	4685                	li	a3,1
     e5c:	4629                	li	a2,10
     e5e:	000bb583          	ld	a1,0(s7)
     e62:	855a                	mv	a0,s6
     e64:	defff0ef          	jal	c52 <printint>
        i += 2;
     e68:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     e6a:	8bca                	mv	s7,s2
      state = 0;
     e6c:	4981                	li	s3,0
        i += 2;
     e6e:	bdd9                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 10, 0);
     e70:	008b8913          	addi	s2,s7,8
     e74:	4681                	li	a3,0
     e76:	4629                	li	a2,10
     e78:	000be583          	lwu	a1,0(s7)
     e7c:	855a                	mv	a0,s6
     e7e:	dd5ff0ef          	jal	c52 <printint>
     e82:	8bca                	mv	s7,s2
      state = 0;
     e84:	4981                	li	s3,0
     e86:	bd7d                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e88:	008b8913          	addi	s2,s7,8
     e8c:	4681                	li	a3,0
     e8e:	4629                	li	a2,10
     e90:	000bb583          	ld	a1,0(s7)
     e94:	855a                	mv	a0,s6
     e96:	dbdff0ef          	jal	c52 <printint>
        i += 1;
     e9a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e9c:	8bca                	mv	s7,s2
      state = 0;
     e9e:	4981                	li	s3,0
        i += 1;
     ea0:	b555                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     ea2:	008b8913          	addi	s2,s7,8
     ea6:	4681                	li	a3,0
     ea8:	4629                	li	a2,10
     eaa:	000bb583          	ld	a1,0(s7)
     eae:	855a                	mv	a0,s6
     eb0:	da3ff0ef          	jal	c52 <printint>
        i += 2;
     eb4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     eb6:	8bca                	mv	s7,s2
      state = 0;
     eb8:	4981                	li	s3,0
        i += 2;
     eba:	b569                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint32), 16, 0);
     ebc:	008b8913          	addi	s2,s7,8
     ec0:	4681                	li	a3,0
     ec2:	4641                	li	a2,16
     ec4:	000be583          	lwu	a1,0(s7)
     ec8:	855a                	mv	a0,s6
     eca:	d89ff0ef          	jal	c52 <printint>
     ece:	8bca                	mv	s7,s2
      state = 0;
     ed0:	4981                	li	s3,0
     ed2:	bd8d                	j	d44 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ed4:	008b8913          	addi	s2,s7,8
     ed8:	4681                	li	a3,0
     eda:	4641                	li	a2,16
     edc:	000bb583          	ld	a1,0(s7)
     ee0:	855a                	mv	a0,s6
     ee2:	d71ff0ef          	jal	c52 <printint>
        i += 1;
     ee6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     ee8:	8bca                	mv	s7,s2
      state = 0;
     eea:	4981                	li	s3,0
        i += 1;
     eec:	bda1                	j	d44 <vprintf+0x4a>
     eee:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     ef0:	008b8d13          	addi	s10,s7,8
     ef4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     ef8:	03000593          	li	a1,48
     efc:	855a                	mv	a0,s6
     efe:	d37ff0ef          	jal	c34 <putc>
  putc(fd, 'x');
     f02:	07800593          	li	a1,120
     f06:	855a                	mv	a0,s6
     f08:	d2dff0ef          	jal	c34 <putc>
     f0c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     f0e:	00000b97          	auipc	s7,0x0
     f12:	5e2b8b93          	addi	s7,s7,1506 # 14f0 <digits>
     f16:	03c9d793          	srli	a5,s3,0x3c
     f1a:	97de                	add	a5,a5,s7
     f1c:	0007c583          	lbu	a1,0(a5)
     f20:	855a                	mv	a0,s6
     f22:	d13ff0ef          	jal	c34 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     f26:	0992                	slli	s3,s3,0x4
     f28:	397d                	addiw	s2,s2,-1
     f2a:	fe0916e3          	bnez	s2,f16 <vprintf+0x21c>
        printptr(fd, va_arg(ap, uint64));
     f2e:	8bea                	mv	s7,s10
      state = 0;
     f30:	4981                	li	s3,0
     f32:	6d02                	ld	s10,0(sp)
     f34:	bd01                	j	d44 <vprintf+0x4a>
        putc(fd, va_arg(ap, uint32));
     f36:	008b8913          	addi	s2,s7,8
     f3a:	000bc583          	lbu	a1,0(s7)
     f3e:	855a                	mv	a0,s6
     f40:	cf5ff0ef          	jal	c34 <putc>
     f44:	8bca                	mv	s7,s2
      state = 0;
     f46:	4981                	li	s3,0
     f48:	bbf5                	j	d44 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     f4a:	008b8993          	addi	s3,s7,8
     f4e:	000bb903          	ld	s2,0(s7)
     f52:	00090f63          	beqz	s2,f70 <vprintf+0x276>
        for(; *s; s++)
     f56:	00094583          	lbu	a1,0(s2)
     f5a:	c195                	beqz	a1,f7e <vprintf+0x284>
          putc(fd, *s);
     f5c:	855a                	mv	a0,s6
     f5e:	cd7ff0ef          	jal	c34 <putc>
        for(; *s; s++)
     f62:	0905                	addi	s2,s2,1
     f64:	00094583          	lbu	a1,0(s2)
     f68:	f9f5                	bnez	a1,f5c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
     f6a:	8bce                	mv	s7,s3
      state = 0;
     f6c:	4981                	li	s3,0
     f6e:	bbd9                	j	d44 <vprintf+0x4a>
          s = "(null)";
     f70:	00000917          	auipc	s2,0x0
     f74:	51890913          	addi	s2,s2,1304 # 1488 <malloc+0x40c>
        for(; *s; s++)
     f78:	02800593          	li	a1,40
     f7c:	b7c5                	j	f5c <vprintf+0x262>
        if((s = va_arg(ap, char*)) == 0)
     f7e:	8bce                	mv	s7,s3
      state = 0;
     f80:	4981                	li	s3,0
     f82:	b3c9                	j	d44 <vprintf+0x4a>
     f84:	64a6                	ld	s1,72(sp)
     f86:	79e2                	ld	s3,56(sp)
     f88:	7a42                	ld	s4,48(sp)
     f8a:	7aa2                	ld	s5,40(sp)
     f8c:	7b02                	ld	s6,32(sp)
     f8e:	6be2                	ld	s7,24(sp)
     f90:	6c42                	ld	s8,16(sp)
     f92:	6ca2                	ld	s9,8(sp)
    }
  }
}
     f94:	60e6                	ld	ra,88(sp)
     f96:	6446                	ld	s0,80(sp)
     f98:	6906                	ld	s2,64(sp)
     f9a:	6125                	addi	sp,sp,96
     f9c:	8082                	ret

0000000000000f9e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f9e:	715d                	addi	sp,sp,-80
     fa0:	ec06                	sd	ra,24(sp)
     fa2:	e822                	sd	s0,16(sp)
     fa4:	1000                	addi	s0,sp,32
     fa6:	e010                	sd	a2,0(s0)
     fa8:	e414                	sd	a3,8(s0)
     faa:	e818                	sd	a4,16(s0)
     fac:	ec1c                	sd	a5,24(s0)
     fae:	03043023          	sd	a6,32(s0)
     fb2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     fb6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     fba:	8622                	mv	a2,s0
     fbc:	d3fff0ef          	jal	cfa <vprintf>
}
     fc0:	60e2                	ld	ra,24(sp)
     fc2:	6442                	ld	s0,16(sp)
     fc4:	6161                	addi	sp,sp,80
     fc6:	8082                	ret

0000000000000fc8 <printf>:

void
printf(const char *fmt, ...)
{
     fc8:	711d                	addi	sp,sp,-96
     fca:	ec06                	sd	ra,24(sp)
     fcc:	e822                	sd	s0,16(sp)
     fce:	1000                	addi	s0,sp,32
     fd0:	e40c                	sd	a1,8(s0)
     fd2:	e810                	sd	a2,16(s0)
     fd4:	ec14                	sd	a3,24(s0)
     fd6:	f018                	sd	a4,32(s0)
     fd8:	f41c                	sd	a5,40(s0)
     fda:	03043823          	sd	a6,48(s0)
     fde:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fe2:	00840613          	addi	a2,s0,8
     fe6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fea:	85aa                	mv	a1,a0
     fec:	4505                	li	a0,1
     fee:	d0dff0ef          	jal	cfa <vprintf>
}
     ff2:	60e2                	ld	ra,24(sp)
     ff4:	6442                	ld	s0,16(sp)
     ff6:	6125                	addi	sp,sp,96
     ff8:	8082                	ret

0000000000000ffa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ffa:	1141                	addi	sp,sp,-16
     ffc:	e422                	sd	s0,8(sp)
     ffe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1000:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1004:	00001797          	auipc	a5,0x1
    1008:	00c7b783          	ld	a5,12(a5) # 2010 <freep>
    100c:	a02d                	j	1036 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    100e:	4618                	lw	a4,8(a2)
    1010:	9f2d                	addw	a4,a4,a1
    1012:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1016:	6398                	ld	a4,0(a5)
    1018:	6310                	ld	a2,0(a4)
    101a:	a83d                	j	1058 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    101c:	ff852703          	lw	a4,-8(a0)
    1020:	9f31                	addw	a4,a4,a2
    1022:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1024:	ff053683          	ld	a3,-16(a0)
    1028:	a091                	j	106c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    102a:	6398                	ld	a4,0(a5)
    102c:	00e7e463          	bltu	a5,a4,1034 <free+0x3a>
    1030:	00e6ea63          	bltu	a3,a4,1044 <free+0x4a>
{
    1034:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1036:	fed7fae3          	bgeu	a5,a3,102a <free+0x30>
    103a:	6398                	ld	a4,0(a5)
    103c:	00e6e463          	bltu	a3,a4,1044 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1040:	fee7eae3          	bltu	a5,a4,1034 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1044:	ff852583          	lw	a1,-8(a0)
    1048:	6390                	ld	a2,0(a5)
    104a:	02059813          	slli	a6,a1,0x20
    104e:	01c85713          	srli	a4,a6,0x1c
    1052:	9736                	add	a4,a4,a3
    1054:	fae60de3          	beq	a2,a4,100e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1058:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    105c:	4790                	lw	a2,8(a5)
    105e:	02061593          	slli	a1,a2,0x20
    1062:	01c5d713          	srli	a4,a1,0x1c
    1066:	973e                	add	a4,a4,a5
    1068:	fae68ae3          	beq	a3,a4,101c <free+0x22>
    p->s.ptr = bp->s.ptr;
    106c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    106e:	00001717          	auipc	a4,0x1
    1072:	faf73123          	sd	a5,-94(a4) # 2010 <freep>
}
    1076:	6422                	ld	s0,8(sp)
    1078:	0141                	addi	sp,sp,16
    107a:	8082                	ret

000000000000107c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    107c:	7139                	addi	sp,sp,-64
    107e:	fc06                	sd	ra,56(sp)
    1080:	f822                	sd	s0,48(sp)
    1082:	f426                	sd	s1,40(sp)
    1084:	ec4e                	sd	s3,24(sp)
    1086:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1088:	02051493          	slli	s1,a0,0x20
    108c:	9081                	srli	s1,s1,0x20
    108e:	04bd                	addi	s1,s1,15
    1090:	8091                	srli	s1,s1,0x4
    1092:	0014899b          	addiw	s3,s1,1
    1096:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1098:	00001517          	auipc	a0,0x1
    109c:	f7853503          	ld	a0,-136(a0) # 2010 <freep>
    10a0:	c915                	beqz	a0,10d4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10a4:	4798                	lw	a4,8(a5)
    10a6:	08977a63          	bgeu	a4,s1,113a <malloc+0xbe>
    10aa:	f04a                	sd	s2,32(sp)
    10ac:	e852                	sd	s4,16(sp)
    10ae:	e456                	sd	s5,8(sp)
    10b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    10b2:	8a4e                	mv	s4,s3
    10b4:	0009871b          	sext.w	a4,s3
    10b8:	6685                	lui	a3,0x1
    10ba:	00d77363          	bgeu	a4,a3,10c0 <malloc+0x44>
    10be:	6a05                	lui	s4,0x1
    10c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10c8:	00001917          	auipc	s2,0x1
    10cc:	f4890913          	addi	s2,s2,-184 # 2010 <freep>
  if(p == SBRK_ERROR)
    10d0:	5afd                	li	s5,-1
    10d2:	a081                	j	1112 <malloc+0x96>
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	e852                	sd	s4,16(sp)
    10d8:	e456                	sd	s5,8(sp)
    10da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    10dc:	00001797          	auipc	a5,0x1
    10e0:	32c78793          	addi	a5,a5,812 # 2408 <base>
    10e4:	00001717          	auipc	a4,0x1
    10e8:	f2f73623          	sd	a5,-212(a4) # 2010 <freep>
    10ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10f2:	b7c1                	j	10b2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    10f4:	6398                	ld	a4,0(a5)
    10f6:	e118                	sd	a4,0(a0)
    10f8:	a8a9                	j	1152 <malloc+0xd6>
  hp->s.size = nu;
    10fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10fe:	0541                	addi	a0,a0,16
    1100:	efbff0ef          	jal	ffa <free>
  return freep;
    1104:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1108:	c12d                	beqz	a0,116a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    110a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    110c:	4798                	lw	a4,8(a5)
    110e:	02977263          	bgeu	a4,s1,1132 <malloc+0xb6>
    if(p == freep)
    1112:	00093703          	ld	a4,0(s2)
    1116:	853e                	mv	a0,a5
    1118:	fef719e3          	bne	a4,a5,110a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    111c:	8552                	mv	a0,s4
    111e:	a23ff0ef          	jal	b40 <sbrk>
  if(p == SBRK_ERROR)
    1122:	fd551ce3          	bne	a0,s5,10fa <malloc+0x7e>
        return 0;
    1126:	4501                	li	a0,0
    1128:	7902                	ld	s2,32(sp)
    112a:	6a42                	ld	s4,16(sp)
    112c:	6aa2                	ld	s5,8(sp)
    112e:	6b02                	ld	s6,0(sp)
    1130:	a03d                	j	115e <malloc+0xe2>
    1132:	7902                	ld	s2,32(sp)
    1134:	6a42                	ld	s4,16(sp)
    1136:	6aa2                	ld	s5,8(sp)
    1138:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    113a:	fae48de3          	beq	s1,a4,10f4 <malloc+0x78>
        p->s.size -= nunits;
    113e:	4137073b          	subw	a4,a4,s3
    1142:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1144:	02071693          	slli	a3,a4,0x20
    1148:	01c6d713          	srli	a4,a3,0x1c
    114c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    114e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1152:	00001717          	auipc	a4,0x1
    1156:	eaa73f23          	sd	a0,-322(a4) # 2010 <freep>
      return (void*)(p + 1);
    115a:	01078513          	addi	a0,a5,16
  }
}
    115e:	70e2                	ld	ra,56(sp)
    1160:	7442                	ld	s0,48(sp)
    1162:	74a2                	ld	s1,40(sp)
    1164:	69e2                	ld	s3,24(sp)
    1166:	6121                	addi	sp,sp,64
    1168:	8082                	ret
    116a:	7902                	ld	s2,32(sp)
    116c:	6a42                	ld	s4,16(sp)
    116e:	6aa2                	ld	s5,8(sp)
    1170:	6b02                	ld	s6,0(sp)
    1172:	b7f5                	j	115e <malloc+0xe2>
