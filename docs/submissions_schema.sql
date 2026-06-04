-- Create Submissions Table to store form entries
CREATE TABLE IF NOT EXISTS public.submissions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    city TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Enable Row Level Security (RLS)
ALTER TABLE public.submissions ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anyone to insert entries (perfect for testing and learning)
CREATE POLICY "Allow anyone to insert submissions"
    ON public.submissions FOR INSERT
    WITH CHECK (true);

-- Create policy to allow anyone to view entries
CREATE POLICY "Allow anyone to view submissions"
    ON public.submissions FOR SELECT
    USING (true);
