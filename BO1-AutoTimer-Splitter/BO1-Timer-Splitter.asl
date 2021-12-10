state("BlackOps")
{
    // tick count -- x50 to get ms
    int timer : 0x1679870;  

    // player kills  
    int p1k : 0x180A6CC;
    int p2k : 0x180C3F4;
    int p3k : 0x180E11C;
    int p4k : 0x180FE44;
}

state("BGamerT5")
{
    int timer : 0x1679870;      
    int p1k : 0x180A6CC;
    int p2k : 0x180C3F4;
    int p3k : 0x180E11C;
    int p4k : 0x180FE44;
}

startup
{
    // Set up round signature -> scan on round 2
    vars.sigRound2 = new SigScanTarget(0, "02 00 00 00 ?? ?? 12 00");
    // Set up round signature -> scan on round 3
    vars.sigRound3 = new SigScanTarget(0, "03 00 00 00 ?? ?? 12 00");

    // Variables used for tracking
    vars.roundAddressFound = false;
    vars.roundAddress = IntPtr.Zero;
    vars.round = 0;

    // Settings
    timer.CurrentTimingMethod = TimingMethod.GameTime;
}

init
{
    // region to scan
    vars.scanner = new SignatureScanner(game, (IntPtr)0x2AB00000, 0x100000);
}

// this works for getting the round for now. needs a lot of fixing but works.

update
{
    if (current.p1k + current.p2k + current.p3k + current.p4k > 6 && !vars.roundAddressFound) // this means we are on round 2 or 3 maybe?
    {
        vars.roundAddress = vars.scanner.Scan(vars.sigRound2);

        if (vars.roundAddress != IntPtr.Zero)
        {   
            vars.roundAddressFound = true;
            return true;
        }

        vars.roundAddress = vars.scanner.Scan(vars.sigRound3);

        if (vars.roundAddress != IntPtr.Zero)
        {
            vars.roundAddressFound = true;
            return true;
        }
    }

    vars.round = memory.ReadValue<int>((IntPtr)vars.roundAddress);

    print(vars.round.ToString());

    return true;
    
}

gameTime
{
    return TimeSpan.FromMilliseconds(current.timer * 50);
}