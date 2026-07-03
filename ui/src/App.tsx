import { useEffect, useMemo, useState } from 'react';
import { randomSequenceString } from './utils/utils';
import { cn } from './utils/cn';

const allowedLetters = ['Q', 'W', 'E', 'A', 'S', 'D'];
const quantityLetters = 30;

function App() {
   const sequenceLettersMemo = useMemo(
      () =>
         randomSequenceString(quantityLetters, allowedLetters)
            .split('')
            .map((letter) => {
               return {
                  letter,
                  matched: undefined,
               };
            }),
      [],
   ) as { letter: string; matched: boolean | undefined }[];
   const [sequenceLetters, setSequenceLetters] = useState(sequenceLettersMemo);
   const [time, setTime] = useState(100);
   const [errors, setErrors] = useState(0);
   const [gameOver, setGameOver] = useState(false);
   const [gameCompleted, setGameCompleted] = useState(false);

   useEffect(() => {
      if (gameOver) {
         alert('Game Over!');
         return;
      }

      if (gameCompleted) return;

      const duration = 30000;
      const interval = 16;
      const decrement = 100 / (duration / interval);

      const timer = setInterval(() => {
         setTime((prev) => {
            const next = prev - decrement;

            if (next <= 0) {
               clearInterval(timer);
               setGameOver(true);
               return 0;
            }

            return next;
         });
      }, interval);
      return () => clearInterval(timer);
   }, [gameOver, gameCompleted]);

   useEffect(() => {
      const handleKeyDown = (event: KeyboardEvent) => {
         if (gameOver) {
            alert('Game Over!');
            return;
         }

         const pressedKey = event.key.toUpperCase();
         const noMatchedLetterIndex = sequenceLetters.findIndex(
            (sequenceLetter) => !sequenceLetter.matched,
         );

         if (noMatchedLetterIndex === -1) return;

         const isMatchLetter =
            sequenceLetters[noMatchedLetterIndex].letter === pressedKey;

         if (!isMatchLetter) {
            const nextErrors = errors + 1;
            setErrors(nextErrors);

            if (nextErrors >= 3) {
               setGameOver(true);
            }
         }

         const updatedSequenceLetters = [...sequenceLetters];
         updatedSequenceLetters[noMatchedLetterIndex] = {
            ...updatedSequenceLetters[noMatchedLetterIndex],
            matched: isMatchLetter,
         };

         setSequenceLetters(updatedSequenceLetters);

         const success = updatedSequenceLetters.every(
            (sequenceLetter) => sequenceLetter.matched === true,
         );

         if (success) {
            alert('Parabéns! Você completou a sequência!');
            setGameCompleted(true);
            return;
         }
      };

      document.addEventListener('keydown', handleKeyDown);
      return () => document.removeEventListener('keydown', handleKeyDown);
   }, [gameOver, gameCompleted, sequenceLetters, errors]);

   return (
      <div className='flex h-screen w-screen items-center justify-center'>
         <div className='flex flex-col items-center gap-4 rounded-2xl bg-slate-800 p-8'>
            <p className='text-xl font-bold text-white'>
               Digite a sequencia correta
            </p>
            <span className='flex gap-1.5 self-end text-slate-400'>
               Errors:{' '}
               <span className='font-bold text-slate-200'>{errors} / 3</span>
            </span>
            <div className='grid grid-cols-6 gap-2 rounded-2xl text-center text-2xl text-white'>
               {sequenceLetters.map((sequenceLetter, index) => {
                  return (
                     <div
                        key={index}
                        className={cn(
                           'flex h-16 w-20 items-center justify-center rounded-lg bg-slate-700 text-xl',
                           sequenceLetter.matched && 'bg-green-500',
                           sequenceLetter.matched === false && 'bg-red-500',
                        )}>
                        {sequenceLetter.letter}
                     </div>
                  );
               })}
            </div>

            <div className='w-full'>
               <div className='h-2 w-full overflow-hidden rounded-full bg-zinc-700'>
                  <div
                     className='h-full bg-green-500 transition-[width] duration-75 ease-linear'
                     style={{ width: `${time}%` }}
                  />
               </div>
            </div>
         </div>
      </div>
   );
}

export default App;
