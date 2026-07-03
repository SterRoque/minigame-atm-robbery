import { useEffect, useMemo, useRef, useState } from 'react';
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
   const errorsCount = useRef(0);

   useEffect(() => {
      document.addEventListener('keydown', (event) => {
         if (errorsCount.current >= 3) {
            alert('Game Over');
            return;
         }

         const pressedKey = event.key.toUpperCase();
         const noMatchedLetterIndex = sequenceLetters.findIndex(
            (sequenceLetter) => !sequenceLetter.matched,
         );

         if (noMatchedLetterIndex !== -1) {
            const isMatchLetter =
               sequenceLetters[noMatchedLetterIndex].letter === pressedKey;

            if (!isMatchLetter && errorsCount.current < 3) {
               console.log('no match');
               errorsCount.current += 1;
            }

            const updatedSequenceLetters = [...sequenceLetters];

            updatedSequenceLetters[noMatchedLetterIndex].matched =
               isMatchLetter;

            setSequenceLetters(updatedSequenceLetters);
         }
      });
   }, []);

   return (
      <div className='flex h-screen w-screen items-center justify-center'>
         <div className='flex flex-col items-center gap-4 rounded-2xl bg-slate-800 p-8'>
            <span className='text-slate-400'>{errorsCount.current} / 3</span>
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
         </div>
      </div>
   );
}

export default App;
