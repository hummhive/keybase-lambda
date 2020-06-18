'use strict';

const { exec, spawn, spawnSync } = require('child_process');

var ls = function(dir) {

 const ls = spawnSync('ls', ['-la', dir]);

 console.log(`ls: ${ls.stdout}`)

 // ls.stdout.on('data', (data) => {
 //   console.log(`stdout: ${data}`);
 // });
 //
 // ls.stderr.on('data', (data) => {
 //   console.error(`stderr: ${data}`);
 // });
 //
 // ls.on('close', (code) => {
 //   console.log(`child process exited with code ${code}`);
 // });
}


var runBot = function(recipient) {

return new Promise(function(resolve) {


 process.env['PATH'] = process.env['PATH'] + ':' + process.env['LAMBDA_TASK_ROOT'] + '/.deploy';

 const Bot = require('keybase-bot')

 const bot = new Bot('/tmp')
 const username = process.env['KEYBASE_USERNAME']
 const paperkey = process.env['KEYBASE_PAPERKEY'];

 bot
   .init(username, paperkey, {verbose: false})
   .then((value) => {
     console.log(value);
     console.log(`Your bot is initialized. It is logged in as ${bot.myInfo().username}`)
     ls('$HOME')

     const child = spawn(process.env['LAMBDA_TASK_ROOT'] + '/.deploy/keybase', ['--home', '/tmp', '-F', 'fs', 'read', 'keybase://private/thedavidmeister/foo.txt']);

     child.stdout.on('data', (data) => {
      console.log('barzz')
      console.log(data.toString('utf8'))
      resolve(true)
     })

     child.stderr.on('data', (data) => {
      console.log('foooz')
      console.log(data)
      console.log(data.toString('utf8'))
      resolve(false)
     })

     // // const channel = {name: recipient + ',' + bot.myInfo().username, public: false, topicType: 'chat'}
     // const channel = {name: 'humm#humm', public: false, topicType: 'chat'}
     // const message = {
     //   body: `Hello! This is lambda saying hello from my device`,
     // }

  //    bot.chat
  //      .send(channel, message)
  //      .then(() => {
  // console.log('Message sent!')
  // bot.deinit()
  // resolve(true);
  //      })
  //      .catch(error => {
  // console.error(error)
  // bot.deinit()
  // resolve(false);
  //      })
  //  })
  //  .catch(error => {
  //    console.error(error)
  //    bot.deinit()
  // resolve(false);
   })

});
};
exports.handler = async (event) => {


  // const requestBody = JSON.parse(event.body);
  // const recipient = requestBody.recipient;

var invokeBot = await runBot();
const response = {
 statusCode: 200,
 body: JSON.stringify('Hello from Lambda!'),
};
return response;
};













module.exports.hello = async event => {
  // console.log('foo', process.env.PAPERKEY);

  const cmd = '/var/task/.deploy/keybase --home /tmp/keybase --no-auto-fork --enable-bot-lite-mode';
  const file = 'keybase://private/thedavidmeister/foo.txt';

  // const myShellScript = exec('ls --all -l /var/task/.deploy');
  const script = await exec(cmd + ' oneshot && ' + cmd + ' fs read ' + file);
  script.stdout.on('data', (data) => {
    console.log('fooz')
      console.log(data);
      // do whatever you want here with data
  });
  script.stderr.on('data', (data) => {
    console.log('fooj')
      console.log(data);
      // do whatever you want here with data
  });

  // const script2 = await exec('/var/task/.deploy/keybase --home /tmp/keybase fs read keybase://private/thedavidmeister/foo.txt');
  // script2.stdout.on('data', (data) => {
  //  console.log('bar');
  //  console.log(data);
  // });
  //
  // script2.stderr.on('data', (data) => {
  //   console.log('barj')
  //     console.log(data);
  //     // do whatever you want here with data
  // });

  let promise = new Promise((resolve, reject) => {
    setTimeout(() => resolve("done!"), 5000)
  });

  // console.log(stdout);


  return await promise

  // return await myShellScript.stdout;

  // return {
  //   statusCode: 200,
  //   body: JSON.stringify(
  //     {
  //       message: 'Go Serverless v1.0! Your function executed successfully!',
  //       input: event,
  //     },
  //     null,
  //     2
  //   ),
  // };

  // Use this code if you don't use the http event with the LAMBDA-PROXY integration
  // return { message: 'Go Serverless v1.0! Your function executed successfully!', event };
};
