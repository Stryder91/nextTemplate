// To determine different epochs based on timestamps
// Based on Paris GMT
export const MintPhase = () => {
  const now = Date.now();

  const privateDate = new Date('June 14, 2022 12:12:00 GMT+02:00');
  const privateEndDate = new Date('June 15, 2022 11:00:00 GMT+02:00');

  const raffleDate = new Date('June 15, 2022 16:12:00 GMT+02:00');
  const raffleEndDate = new Date('June 16, 2022 12:00:00 GMT+02:00');

  const publicDate = new Date('June 16, 2022 19:33:00 GMT+02:00');

  // DEV
  // const privateDate = new Date('June 14, 2022 12:12:00 GMT+02:00');
  // const privateEndDate = new Date('June 15, 2022 09:45:00 GMT+02:00');

  // const raffleDate = new Date('June 15, 2022 09:48:00 GMT+02:00');
  // const raffleEndDate = new Date('June 15, 2022 09:52:00 GMT+02:00');

  // const publicDate = new Date('June 15, 2022 09:59:00 GMT+02:00');

  const privateMint    = privateDate.getTime();
  const privateEndMint = privateEndDate.getTime();
  const raffleMint     = raffleDate.getTime();
  const raffleEndMint  = raffleEndDate.getTime();
  const publicMint     = publicDate.getTime();

  if (now > privateMint && now < privateEndMint) {
    return 2;
  } else if (now > raffleMint && now < raffleEndMint) {
    return 1;
  } else if (now > publicMint) {
    return 3;
  }
  console.log("Mint not available yet! Starting soon .....");
  return 0;
}